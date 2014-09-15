//
//  LKTagsViewController.m
//  LKEvernote
//
//  Created by Hiroshi Hashiguchi on 2014/09/15.
//  Copyright (c) 2014年 Hiroshi Hashiguchi. All rights reserved.
//

#import "LKTagsViewController.h"
#import "LKEvernote.h"

@interface LKTagsViewController ()

@end

@implementation LKTagsViewController

- (void)onRefresh:(id)sender
{
    [self.refreshControl beginRefreshing];
    
    [LKEvernoteAttributeManager.sharedManager reloadTagWithSuccess:^(NSArray *tags) {
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.refreshControl = UIRefreshControl.new;
    [self.refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return LKEvernoteAttributeManager.sharedManager.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TagsCell" forIndexPath:indexPath];
    
    LKEvernoteTag* tag = LKEvernoteAttributeManager.sharedManager.tags[indexPath.row];
    cell.textLabel.text = tag.name;
    
    return cell;
}

@end

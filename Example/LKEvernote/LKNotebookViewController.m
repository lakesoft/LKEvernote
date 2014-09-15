//
//  LKNotebookViewController.m
//  LKEvernote
//
//  Created by Hiroshi Hashiguchi on 2014/09/15.
//  Copyright (c) 2014年 Hiroshi Hashiguchi. All rights reserved.
//

#import "LKNotebookViewController.h"
#import "LKEvernote.h"

@interface LKNotebookViewController ()

@end

@implementation LKNotebookViewController

- (void)onRefresh:(id)sender
{
    [self.refreshControl beginRefreshing];
    
    [LKEvernoteAttributeManager.sharedManager reloadNotebookWithSuccess:^(NSArray *notebooks) {
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
    
    return LKEvernoteAttributeManager.sharedManager.notebooks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotebookCell" forIndexPath:indexPath];

    LKEvernoteNotebook* notebook = LKEvernoteAttributeManager.sharedManager.notebooks[indexPath.row];
    cell.textLabel.text = notebook.name;
    
    return cell;
}


@end

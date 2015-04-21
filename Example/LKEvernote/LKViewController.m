//
//  LKViewController.m
//  LKEvernote
//
//  Created by Hiroshi Hashiguchi on 09/15/2014.
//  Copyright (c) 2014 Hiroshi Hashiguchi. All rights reserved.
//

#import "LKViewController.h"
#import "LKEvernote.h"

@interface LKViewController ()
@property (weak, nonatomic) IBOutlet UILabel *stausLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultNoteBookLabel;

@end

@implementation LKViewController

- (void)_updateStatus
{
    self.stausLabel.text = LKEvernoteManager.sharedManager.isAuthenticated ? @"logged in" : @"logged out";
    
    LKEvernoteManager.sharedManager.noteLimit;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _updateStatus];
    self.defaultNoteBookLabel.text = LKEvernoteAttributeManager.sharedManager.defaultNotebook.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    [LKEvernoteManager.sharedManager authenticateWithViewController:self
                                                  completionHandler:^(NSError* error) {
                                                      if (error == nil) {
                                                          [self _updateStatus];
                                                          NSLog(@"logged in");
                                                      } else {
                                                          NSLog(@"[ERROR] %@", error);
                                                      }
                                                  }];

}
- (IBAction)logout:(id)sender {
    [LKEvernoteManager.sharedManager logout];
    [self _updateStatus];
}

@end

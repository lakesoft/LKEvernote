# LKEvernote

[![CI Status](http://img.shields.io/travis/Hiroshi Hashiguchi/LKEvernote.svg?style=flat)](https://travis-ci.org/Hiroshi Hashiguchi/LKEvernote)
[![Version](https://img.shields.io/cocoapods/v/LKEvernote.svg?style=flat)](http://cocoadocs.org/docsets/LKEvernote)
[![License](https://img.shields.io/cocoapods/l/LKEvernote.svg?style=flat)](http://cocoadocs.org/docsets/LKEvernote)
[![Platform](https://img.shields.io/cocoapods/p/LKEvernote.svg?style=flat)](http://cocoadocs.org/docsets/LKEvernote)

## Usage

### STEP1

Put some codes on app delegate.

    #import "LKEvernote.h"
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        [LKEvernoteManager.sharedManager setupWithHost:BootstrapServerBaseURLStringUS   // Host
                                                   key:@"xxxxxx"                        // Consumer Key
                                                secret:@"yyyyyy"];                      // Consumer Secret 
        return YES;
    }

    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
        if ([LKEvernoteManager.sharedManager canHandleWithURL:url]) {
            return YES;
        }
        return NO;
    }

### STEP2

Put login codes in your view controller.

    - (IBAction)login:(id)sender {
        [LKEvernoteManager.sharedManager authenticateWithViewController:self
                                                      completionHandler:^(NSError* error) {
                                                          if (error == nil) {
                                                              [self _updateStatus];
                                                              NSLog(@"logged in");
                                                          } else {
                                                              NSLog(@"%@", error);
                                                          }
                                                      }];

    }

### Checking login status

    BOOL loggedin = LKEvernoteManager.sharedManager.isAuthenticated;


### Get notebooks and tags (and default notebook)

    NSArray* notebooks = LKEvernoteAttributeManager.sharedManager.notebooks;
    for (LKEvernoteNotebook* notebook in notebooks) {
        NSLog(@"%@: %@", notebook.guid, notebook.name);
    }
    
    NSArray* tags = LKEvernoteAttributeManager.sharedManager.tags;
    for (LKEvernoteTag* tag in tags) {
        NSLog(@"%@: %@", tag.guid, tag.name);
    }
    
    LKEvernoteNotebook* defaultNotebook = LKEvernoteAttributeManager.sharedManager.defaultNotebook;
    NSLog(@"%@: %@", notebook.guid, notebook.name);


### Reload notebooks (also tags)

    [LKEvernoteAttributeManager.sharedManager reloadNotebookWithSuccess:^(NSArray *notebooks) {
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];


## Note

Notebooks and tags are saved in cache files at setup (or reload). The cache files are used the next time (not calling Evernote API). If you refresh the caches, you call reload methos.


## Requirements

## Installation

LKEvernote is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "LKEvernote", :git => 'https://github.com/lakesoft/LKEvernote.git'

## Author

Hiroshi Hashiguchi, xcatsan@mac.com

## License

LKEvernote is available under the MIT license. See the LICENSE file for more info.


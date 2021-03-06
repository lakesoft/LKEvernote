//
//  LKEvernoteManager.h
//

#import <Foundation/Foundation.h>
#import "EvernoteSDK.h"

@interface LKEvernoteManager : NSObject

+ (instancetype)sharedManager;

- (void)setupWithHost:(NSString*)host key:(NSString*)key secret:(NSString*)secret;
- (BOOL)canHandleWithURL:(NSURL*)url;

- (BOOL)isAuthenticated;
- (void)authenticateWithViewController:(UIViewController *)viewController
                     completionHandler:(EvernoteAuthCompletionHandler)completionHandler;
- (void)logout;

// Accounting
- (NSInteger)uploadLimit;
- (BOOL)isPremium;
- (NSInteger)noteLimit;

@end

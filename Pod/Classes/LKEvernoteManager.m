//
//  LKEvernoteManager.m
//

#import "LKEvernoteManager.h"
#import "LKEvernoteAttributeManager.h"

@implementation LKEvernoteManager

#pragma mark - API

- (void)setupWithHost:(NSString*)host key:(NSString*)key secret:(NSString*)secret
{
    [EvernoteSession setSharedSessionHost:host consumerKey:key consumerSecret:secret];
    
    if (self.isAuthenticated) {
        [LKEvernoteAttributeManager.sharedManager setup]; //[*1]
    }
}

- (BOOL)canHandleWithURL:(NSURL*)url
{
    BOOL canHandle = NO;
    if ([[NSString stringWithFormat:@"en-%@", [[EvernoteSession sharedSession] consumerKey]] isEqualToString:[url scheme]] == YES) {
        canHandle = [[EvernoteSession sharedSession] canHandleOpenURL:url];
    }
    return canHandle;
}

+ (instancetype)sharedManager
{
    static LKEvernoteManager* _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = self.new;
    });
    return _sharedManager;
}

#pragma mark - Authentication

- (BOOL)isAuthenticated
{
    return EvernoteSession.sharedSession.isAuthenticated;
}

- (void)authenticateWithViewController:(UIViewController *)viewController
                     completionHandler:(EvernoteAuthCompletionHandler)completionHandler
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    [session authenticateWithViewController:viewController completionHandler:^(NSError *error) {
        if (error || !session.isAuthenticated) {
            NSLog(@"%s:%@", __PRETTY_FUNCTION__, error);
        } else {
            [LKEvernoteAttributeManager.sharedManager setup];     //[*2]
        }
        completionHandler(error);
    }];
}

- (void)logout
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    [session logout];
    
    [LKEvernoteAttributeManager.sharedManager clearAll];
}

#pragma mark - Accounting
- (NSInteger)uploadLimit
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    EDAMUser* user = [session.userStore getUser:session.authenticationToken];
    EDAMAccounting* accounting = user.accounting;
    return accounting.uploadLimit;
}

- (BOOL)isPremium
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    EDAMUser* user = [session.userStore getUser:session.authenticationToken];
    EDAMAccounting* accounting = user.accounting;
    return accounting.premiumServiceStatus == 2;    // 2=ACTIVE
    // @see https://dev.evernote.com/doc/reference/Types.html#Enum_PremiumOrderStatus
}

- (NSInteger)noteLimit
{
    if (self.isPremium) {
        return EDAMLimitsConstants.EDAM_USER_UPLOAD_LIMIT_PREMIUM;
    } else {
        return EDAMLimitsConstants.EDAM_USER_UPLOAD_LIMIT_FREE;
    }
}


@end

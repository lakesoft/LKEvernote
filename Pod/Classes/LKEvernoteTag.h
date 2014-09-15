//
//  EvernoteTag.h
//

#import <Foundation/Foundation.h>
#import "LKEvernoteAttribute.h"

@class EDAMTag;

@interface LKEvernoteTag : LKEvernoteAttribute

#pragma mark - API
+ (LKEvernoteTag*)tagWithEDAMTag:(EDAMTag*)tag;

@end

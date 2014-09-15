//
//  LKEvernoteNotebook.h
//

#import <Foundation/Foundation.h>
#import "LKEvernoteAttribute.h"

@class EDAMNotebook;
@interface LKEvernoteNotebook : LKEvernoteAttribute

#pragma mark - API
+ (LKEvernoteNotebook*)notebookWithEDAMNotebook:(EDAMNotebook*)notebook;

@end

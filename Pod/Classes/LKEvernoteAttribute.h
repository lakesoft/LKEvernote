//
//  LKEvernoteAttribute.h
//

#import <Foundation/Foundation.h>
#import "LKCodingObject.h"

@interface LKEvernoteAttribute : LKCodingObject

@property (strong, nonatomic, readonly) NSString* guid;
@property (strong, nonatomic, readonly) NSString* name;

+ (instancetype)attributeWithGuid:(NSString*)guid name:(NSString*)name;

- (NSComparisonResult)compare:(LKEvernoteAttribute*)attr;

@end

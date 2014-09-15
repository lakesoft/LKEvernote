//
//  LKEvernoteAttribute.m
//

#import "LKEvernoteAttribute.h"

@interface LKEvernoteAttribute()
@property (strong, nonatomic) NSString* guid;
@property (strong, nonatomic) NSString* name;
@end

@implementation LKEvernoteAttribute

#pragma mark - for collection
- (BOOL)isEqual:(id)object
{
    LKEvernoteAttribute* attribute = (LKEvernoteAttribute*)object;
    return [self.guid isEqual:attribute.guid];
}

- (NSUInteger)hash
{
    return self.guid.hash;
}

- (NSComparisonResult)compare:(LKEvernoteAttribute*)attr
{
    return [self.name compare:attr.name];
}

#pragma mark - API
+ (instancetype)attributeWithGuid:(NSString*)guid name:(NSString*)name
{
    LKEvernoteAttribute* attribute = self.new;
    attribute.guid = guid;
    attribute.name = name;
    return attribute;

}

@end

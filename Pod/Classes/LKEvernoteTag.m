//
//  LKEvernoteTag.m
//
#import "EvernoteSDK.h"
#import "LKEvernoteTag.h"

@implementation LKEvernoteTag

#pragma mark - API
+ (LKEvernoteTag*)tagWithEDAMTag:(EDAMTag*)edamTag
{
    return [self attributeWithGuid:edamTag.guid
                              name:edamTag.name];
}

@end

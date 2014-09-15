//
//  EvernoteNotebook.m
//  OneEver
//
//  Created by Hiroshi Hashiguchi on 2013/12/21.
//  Copyright (c) 2013年 lakesoft. All rights reserved.
//

#import "LKEvernoteNotebook.h"
#import "EvernoteSDK.h"

@implementation LKEvernoteNotebook

#pragma mark - API

+ (LKEvernoteNotebook*)notebookWithEDAMNotebook:(EDAMNotebook*)edamNotebook
{
    return [self attributeWithGuid:edamNotebook.guid
                              name:edamNotebook.name];
}


@end

//
//  EvernoteImageResource.h
//  ScrapOne
//
//  Created by Hiroshi Hashiguchi on 2013/12/31.
//  Copyright (c) 2013年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvernoteSDK.h"

@interface LKEvernoteImage : NSObject

@property (strong, nonatomic, readonly) EDAMResource* resource;
@property (strong, nonatomic, readonly) NSString* content;

- (id)initWithData:(NSData*)data;

@end

//
//  EvernoteImageResource.m
//  ScrapOne
//
//  Created by Hiroshi Hashiguchi on 2013/12/31.
//  Copyright (c) 2013年 lakesoft. All rights reserved.
//

#import "LKEvernoteImage.h"
#import "CommonCrypto/CommonDigest.h"

@interface LKEvernoteImage()

@property (strong, nonatomic) EDAMResource* resource;
@property (strong, nonatomic) NSString* content;

@end


@implementation LKEvernoteImage

- (id)initWithData:(NSData*)data
{
    self = [super init];
    if (self) {
        if (data) {
            unsigned char digest[CC_MD5_DIGEST_LENGTH];
            CC_MD5([data bytes], (CC_LONG)[data length], digest);
            char md5cstring[CC_MD5_DIGEST_LENGTH*2];
            for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
                sprintf(md5cstring+i*2, "%02x", digest[i]);
            }
            NSString *hash = [NSString stringWithCString:md5cstring encoding:NSASCIIStringEncoding];
            EDAMData * imageData = [[EDAMData alloc] initWithBodyHash:[hash dataUsingEncoding: NSASCIIStringEncoding]
                                                                 size:(int32_t)[data length]
                                                                 body:data];
            EDAMResourceAttributes * imageAttributes = [[EDAMResourceAttributes alloc] init];
            self.resource  = [[EDAMResource alloc]init];
            [self.resource setMime:@"image/jpeg"];
            [self.resource setData:imageData];
            [self.resource setAttributes:imageAttributes];
            self.content = [NSString stringWithFormat:@"<en-media type=\"image/jpeg\" hash=\"%@\"/>", hash];
        } else {
            self.content = @"";
        }
    }
    return self;
}

@end

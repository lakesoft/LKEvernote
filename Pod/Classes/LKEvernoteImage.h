//
//  LKEvernoteImageResource.h
//

#import <Foundation/Foundation.h>
#import "EvernoteSDK.h"

@interface LKEvernoteImage : NSObject

@property (strong, nonatomic, readonly) EDAMResource* resource;
@property (strong, nonatomic, readonly) NSString* content;

- (id)initWithData:(NSData*)data;

@end

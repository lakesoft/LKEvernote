//
//  LKEvernoteAttribute.h
//

#import <Foundation/Foundation.h>
#import "LKEvernoteNotebook.h"
#import "LKEvernoteTag.h"

@interface LKEvernoteAttributeManager : NSObject

@property (strong, nonatomic, readonly) LKEvernoteNotebook* defaultNotebook;
@property (strong, nonatomic, readonly) NSArray* notebooks;
@property (strong, nonatomic, readonly) NSArray* tags;

#pragma mark - API
+ (instancetype)sharedManager;
- (void)setup;
- (NSString*)attributeDescriptionWithNotebookGuid:(NSString*)notebookGuid tagGuids:(NSArray*)tagGuids separator:(NSString*)separator;
- (NSString*)attributeDescriptionSlashWithNotebookGuid:(NSString*)notebookGuid tagGuids:(NSArray*)tagGuids;  // notebook / tags
- (NSString*)attributeDescriptionReturnWithNotebookGuid:(NSString*)notebookGuid tagGuids:(NSArray*)tagGuids;  // notebook\ntags

- (void)clearAll;   // clear notebooks and tags, remove caches

#pragma mark - API (Notebook)
- (void)reloadNotebookWithSuccess:(void(^)(NSArray* notebooks))success failure:(void(^)(NSError* error))failure;
- (LKEvernoteNotebook*)notebookForGuid:(NSString*)guid;
- (NSString*)notebookDescriptionForGuid:(NSString*)guid;
- (NSInteger)indexForNotebookGuid:(NSString*)notebookGuid;

#pragma mark - API (Tag)
- (void)reloadTagWithSuccess:(void(^)(NSArray* tags))success failure:(void(^)(NSError* error))failure;
- (NSArray*)tagsForGuids:(NSArray*)guids;    // <EvernoteTag>
- (NSMutableOrderedSet*)tagsAsOrderedSetForGuids:(NSArray*)guids;
- (NSString*)tagsDescriptionForGuids:(NSArray*)guids;

@end

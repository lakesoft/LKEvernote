//
//  LKEvernoteAttribute.h
//

#import <Foundation/Foundation.h>
#import "LKEvernoteNotebook.h"
#import "LKEvernoteTag.h"

#define LKEvernoteAttributeDidLoadNotebook    @"LKEvernoteAttributeDidLoadNotebook"
#define LKEvernoteAttributeDidLoadTag         @"LKEvernoteAttributeDidLoadTag"


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

#pragma mark - API (Notebook)
- (void)reloadNotebooks;
- (LKEvernoteNotebook*)notebookForGuid:(NSString*)guid;
- (NSString*)notebookDescriptionForGuid:(NSString*)guid;
- (NSInteger)indexForNotebookGuid:(NSString*)notebookGuid;

#pragma mark - API (Tag)
- (void)reloadTags;
- (NSArray*)tagsForGuids:(NSArray*)guids;    // <EvernoteTag>
- (NSMutableOrderedSet*)tagsAsOrderedSetForGuids:(NSArray*)guids;
- (NSString*)tagsDescriptionForGuids:(NSArray*)guids;

@end

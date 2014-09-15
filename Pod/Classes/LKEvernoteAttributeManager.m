//
//  LKEvernoteAttribute.m
//

#import "EvernoteSDK.h"
#import "LKEvernoteAttributeManager.h"
#import "LKEvernoteNotebook.h"
#import "LKEvernoteTag.h"
#import "LKCachesDirectoryArchiver.h"

#define LK_EVERNOTE_DEFAULT_NOTEBOOK_ARCHIVE_KEY   @"LKEvernote.DefaultNotebooks"
#define LK_EVERNOTE_NOTEBOOK_ARCHIVE_KEY           @"LKEvernote.Notebooks"
#define LK_EVERNOTE_TAGS_ARCHIVE_KEY               @"LKEvernote.Tags"

@interface LKEvernoteAttributeManager()

@property (strong, nonatomic) LKEvernoteNotebook* defaultNotebook;
@property (strong, nonatomic) NSArray* notebooks;
@property (strong, nonatomic) NSArray* tags;

@end


@implementation LKEvernoteAttributeManager

#pragma mark - Privates


#pragma mark - Basics
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - API
+ (instancetype)sharedManager
{
    static LKEvernoteAttributeManager* _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = self.new;
    });
    return _sharedManager;
}

- (void)setup
{
    __weak typeof (self) _weak_self = self;
    // load attrs
    self.notebooks = [LKCachesDirectoryArchiver
                      unarchiveObjectForKey:LK_EVERNOTE_NOTEBOOK_ARCHIVE_KEY
                      defaultObject:^id{
                          [_weak_self reloadNotebookWithSuccess:nil
                                                        failure:^(NSError *error) {
                                                            NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
                                                        }];
                          return nil;
                      }];
    
    self.tags = [LKCachesDirectoryArchiver
                 unarchiveObjectForKey:LK_EVERNOTE_TAGS_ARCHIVE_KEY
                 defaultObject:^id{
                     [_weak_self reloadTagWithSuccess:nil
                                              failure:^(NSError *error) {
                                                  NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
                                              }];
                     return nil;
                 }];

    // default notebook
    self.defaultNotebook = [LKCachesDirectoryArchiver
                 unarchiveObjectForKey:LK_EVERNOTE_DEFAULT_NOTEBOOK_ARCHIVE_KEY];
    
    [EvernoteNoteStore.noteStore getDefaultNotebookWithSuccess:^(EDAMNotebook* edamNotebook) {
        if (edamNotebook) {
            self.defaultNotebook = [LKEvernoteNotebook notebookWithEDAMNotebook:edamNotebook];
            [LKCachesDirectoryArchiver archiveRootObject:self.defaultNotebook
                                                                forKey:LK_EVERNOTE_DEFAULT_NOTEBOOK_ARCHIVE_KEY];
        }
    }
                                                       failure:^(NSError* error) {
                                                           NSLog(@"%s:%@", __PRETTY_FUNCTION__, error);
                                                       }];
}

- (NSString*)attributeDescriptionWithNotebookGuid:(NSString*)notebookGuid tagGuids:(NSArray*)tagGuids separator:(NSString*)separator
{
    NSString* notebookDescription = [self notebookDescriptionForGuid:notebookGuid];
    NSString* tagsDescription = [self tagsDescriptionForGuids:tagGuids];
    return [NSString stringWithFormat:@"%@%@%@",
            notebookDescription,
            tagsDescription.length > 0 ? separator : @"",
            tagsDescription];

}

- (NSString*)attributeDescriptionSlashWithNotebookGuid:(NSString*)notebookGuid tagGuids:(NSArray*)tagGuids
{
    return [self attributeDescriptionWithNotebookGuid:notebookGuid
                                             tagGuids:tagGuids
                                            separator:@" / "];
}
- (NSString*)attributeDescriptionReturnWithNotebookGuid:(NSString*)notebookGuid tagGuids:(NSArray*)tagGuids
{
    return [self attributeDescriptionWithNotebookGuid:notebookGuid
                                             tagGuids:tagGuids
                                            separator:@"\n"];
}


- (void)clearAll
{
    self.defaultNotebook = nil;
    self.notebooks = nil;
    self.tags = nil;
    
    [LKCachesDirectoryArchiver removeArchiveForKey:LK_EVERNOTE_DEFAULT_NOTEBOOK_ARCHIVE_KEY];
    [LKCachesDirectoryArchiver removeArchiveForKey:LK_EVERNOTE_NOTEBOOK_ARCHIVE_KEY];
    [LKCachesDirectoryArchiver removeArchiveForKey:LK_EVERNOTE_TAGS_ARCHIVE_KEY];
}


#pragma mark - API (Notebook)
- (void)reloadNotebookWithSuccess:(void(^)(NSArray* notebooks))success failure:(void(^)(NSError* error))failure
{
    [EvernoteNoteStore.noteStore listNotebooksWithSuccess:^(NSArray* edamNotebooks) {
        NSMutableArray* notebooks = @[].mutableCopy;
        for (EDAMNotebook* edamNotebook in edamNotebooks) {
            [notebooks addObject:[LKEvernoteNotebook notebookWithEDAMNotebook:edamNotebook]];
        }
        NSArray* result = [notebooks sortedArrayUsingComparator:^NSComparisonResult(LKEvernoteNotebook* n1, LKEvernoteNotebook* n2) {
            return [n1 compare:n2];
        }];
        self.notebooks = result;
        [LKCachesDirectoryArchiver archiveRootObject:self.notebooks forKey:LK_EVERNOTE_NOTEBOOK_ARCHIVE_KEY];
        success(result);
    }
                                                  failure:^(NSError* error) {
                                                      failure(error);
                                                  }];
}

- (LKEvernoteNotebook*)notebookForGuid:(NSString*)guid
{
    if (guid == nil) {
        return self.defaultNotebook;
    }
    for (LKEvernoteNotebook* notebook in self.notebooks) {
        if ([guid isEqualToString:notebook.guid]) {
            return notebook;
        }
    }
    return self.defaultNotebook;
}

- (NSString*)notebookDescriptionForGuid:(NSString*)guid
{
    NSString* name = [self notebookForGuid:guid].name;
    return name ? name : @"";
}

- (NSInteger)indexForNotebookGuid:(NSString*)notebookGuid
{
    if (notebookGuid == nil) {
        notebookGuid = self.defaultNotebook.guid;
    }
    NSInteger index = 0;
    for (LKEvernoteNotebook* notebook in self.notebooks) {
        if ([notebookGuid isEqualToString:notebook.guid]) {
            break;
        }
        index++;
    }
    if (index >= self.notebooks.count) {
        index = 0;
    }
    return index;
}


#pragma mark - API (Tag)
- (void)reloadTagWithSuccess:(void(^)(NSArray* tags))success failure:(void(^)(NSError* error))failure
{
    [EvernoteNoteStore.noteStore listTagsWithSuccess:^(NSArray* edamTags) {
        NSMutableArray* tags = @[].mutableCopy;
        for (EDAMTag* edamTag in edamTags) {
            [tags addObject:[LKEvernoteTag tagWithEDAMTag:edamTag]];
        }
        NSArray* result = [tags sortedArrayUsingComparator:^NSComparisonResult(LKEvernoteTag* n1, LKEvernoteTag* n2) {
            return [n1 compare:n2];
        }];
        self.tags = result;
        [LKCachesDirectoryArchiver archiveRootObject:self.tags forKey:LK_EVERNOTE_TAGS_ARCHIVE_KEY];
        
        success(result);
    }
                                                  failure:^(NSError* error) {
                                                      failure(error);
                                                  }];
}

- (NSArray*)tagsForGuids:(NSArray*)guids
{
    NSMutableArray* tags = @[].mutableCopy;
    for (NSString* guid in guids) {
        for (LKEvernoteTag* tag in self.tags) {
            if ([guid isEqualToString:tag.guid]) {
                [tags addObject:tag];
            }
        }
    }
    return tags;

}

- (NSMutableOrderedSet*)tagsAsOrderedSetForGuids:(NSArray*)guids
{
    return [NSMutableOrderedSet orderedSetWithArray:[self tagsForGuids:guids]];
}

- (NSString*)tagsDescriptionForGuids:(NSArray*)guids
{
    NSMutableString* result = [NSMutableString string];
    for (LKEvernoteTag* tag in [self tagsForGuids:guids]) {
        if (result.length > 0) {
            [result appendString:@","];
        }
        [result appendString:tag.name];
    }
    return result;
}

@end

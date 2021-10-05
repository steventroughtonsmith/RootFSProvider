//
//  FileProviderExtension.m
//  FinderFileProvider
//
//  Created by Steven Troughton-Smith on 07/06/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import "FileProviderExtension.h"
#import "FileProviderEnumerator.h"
#import "FileProviderItem.h"

@import FileProviderUI;

#define NSLog(...) /* ... */

#import <UIKit/UIKit.h>

NSMutableDictionary *identifierLookupTable = nil;

@interface FileProviderExtension ()

@property (nonatomic, readonly, strong) NSFileManager *fileManager;

@end

@implementation FileProviderExtension

- (instancetype)init {
    if (self = [super init]) {
        _fileManager = [[NSFileManager alloc] init];
        
        if (!identifierLookupTable)
        {
            identifierLookupTable = @{}.mutableCopy;
            identifierLookupTable[NSFileProviderRootContainerItemIdentifier] = FBSharedContainerHomeDirectory();
        }
    }
    return self;
}

- (nullable NSFileProviderItem)itemForIdentifier:(NSFileProviderItemIdentifier)identifier error:(NSError * _Nullable *)error {
    
    NSString *path = identifierLookupTable[identifier];
    
    if (!path)
        path = FBSharedContainerHomeDirectory();
    
    FileProviderItem * item = [[FileProviderItem alloc] initWithPath:path];
    
    NSLog(@"\r\n\r\nitemForIdentifier: %@ - %@", identifier, item);
    
    return item;
}

#pragma mark -

- (nullable NSURL *)URLForItemWithPersistentIdentifier:(NSFileProviderItemIdentifier)identifier {
    
    NSString *sourcePath = identifierLookupTable[identifier];
    
    BOOL isDir = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:sourcePath isDirectory:&isDir];
    
    if (!sourcePath)
    {
        NSLog(@"NO SOURCE PATH %@ for ID %@", sourcePath, identifier);
        return nil;
    }
    
    NSString *bookmarkPath = [[NSFileProviderManager defaultManager].documentStorageURL.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", identifier, [sourcePath lastPathComponent]]];
    
    NSURL *url = [NSURL fileURLWithPath:bookmarkPath];
    
    NSLog(@"\r\n\r\nURLForItemWithPersistentIdentifier: %@ - %@", identifier, url);
    
    return url;
}

- (nullable NSFileProviderItemIdentifier)persistentIdentifierForItemAtURL:(NSURL *)url {
    // resolve the given URL to a persistent identifier using a database
    NSArray <NSString *> *pathComponents = [url pathComponents];
    
    // exploit the fact that the path structure has been defined as
    // <base storage directory>/<item identifier>/<item file name> above
    
    NSParameterAssert(pathComponents.count > 2);
    NSLog(@"\r\n\r\npersistentIdentifierForItemAtURL : %@", url);
    
    return pathComponents[pathComponents.count - 2];
    
}

#pragma mark -

/**
 This method is called when a placeholder URL should be provided for the item at the given URL.
 
 The implementation of this method should call +[NSFileProviderManager writePlaceholderAtURL:withMetadata:error:] with the URL returned by +[NSFileProviderManager placeholderURLForURL:], then call the completion handler.
 */

- (void)providePlaceholderAtURL:(NSURL *)url completionHandler:(void (^)(NSError * _Nullable error))completionHandler
{
    NSLog(@"\r\n\r\nprovidePlaceholderAtURL: %@", url);
    
   // NSURL *placeholderURL = [NSFileProviderManager placeholderURLForURL:url];
    
    //    [self.fileCoordinator coordinateWritingItemAtURL:placeholderURL options:0 error:NULL byAccessor:^(NSURL *newURL) {
    //
    //        FileProviderItem *fp = [[FileProviderItem alloc] initWithPath:url.path];
    //
    //        [NSFileProviderManager writePlaceholderAtURL:placeholderURL withMetadata:fp error:NULL];
    //
    //    }];
    
    if (completionHandler) {
        completionHandler(nil);
    }
}

- (void)startProvidingItemAtURL:(NSURL *)url completionHandler:(void (^)(NSError *))completionHandler {
    NSLog(@"\r\n\r\nstartProvidingItemAtURL : %@", url);
    NSError* error = NULL;
    BOOL isDirectory = NO;
    
    //    completionHandler([NSError errorWithDomain:NSFileProviderErrorDomain
    //                                          code:NSFileProviderErrorNotAuthenticated
    //                                      userInfo:nil]);
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:url.path isDirectory:&isDirectory])
    {
        error = [NSError errorWithDomain:NSPOSIXErrorDomain code:-1 userInfo:nil];
    }
    
    if (completionHandler)
    {
        completionHandler(error);
    }
    
}


- (void)itemChangedAtURL:(NSURL *)url {
    // Called at some point after the file has changed; the provider may then trigger an upload
    
    /* TODO:
     - mark file at <url> as needing an update in the model
     - if there are existing NSURLSessionTasks uploading this file, cancel them
     - create a fresh background NSURLSessionTask and schedule it to upload the current modifications
     - register the NSURLSessionTask with NSFileProviderManager to provide progress updates
     */
    
    NSLog(@"\r\n\r\nitemChangedAtURL : %@", url);
}

- (void)stopProvidingItemAtURL:(NSURL *)url {
    
    NSLog(@"\r\n\r\nstopProvidingItemAtURL %@", url);
    //    [self.fileCoordinator coordinateWritingItemAtURL:url options:NSFileCoordinatorWritingForDeleting error:nil byAccessor:^(NSURL *newURL) {
    //        [[NSFileManager defaultManager] removeItemAtURL:newURL error:nil];
    //    }];
    //    [self providePlaceholderAtURL:url completionHandler:^(NSError *error){
    //    }];
    
}

#pragma mark - Actions

/* TODO: implement the actions for items here
 each of the actions follows the same pattern:
 - make a note of the change in the local model
 - schedule a server request as a background task to inform the server of the change
 - call the completion block with the modified item in its post-modification state
 */

#pragma mark - Enumeration

- (nullable id<NSFileProviderEnumerator>)enumeratorForContainerItemIdentifier:(NSFileProviderItemIdentifier)containerItemIdentifier error:(NSError **)error {
    return [[FileProviderEnumerator alloc] initWithEnumeratedItemIdentifier:containerItemIdentifier];
}

- (void)trashItemWithIdentifier:(NSFileProviderItemIdentifier)itemIdentifier
              completionHandler:(void (^)(NSFileProviderItem _Nullable trashedItem, NSError * _Nullable error))completionHandler
{
    
    completionHandler(nil, nil);
}

- (void)untrashItemWithIdentifier:(NSFileProviderItemIdentifier)itemIdentifier
           toParentItemIdentifier:(nullable NSFileProviderItemIdentifier)parentItemIdentifier
                completionHandler:(void (^)(NSFileProviderItem _Nullable untrashedItem, NSError * _Nullable error))completionHandler
{
    completionHandler(nil, nil);
}

- (void)reparentItemWithIdentifier:(NSFileProviderItemIdentifier)itemIdentifier
        toParentItemWithIdentifier:(NSFileProviderItemIdentifier)parentItemIdentifier
                 completionHandler:(void (^)(NSFileProviderItem _Nullable reparentedItem, NSError * _Nullable error))completionHandler
{
    completionHandler(nil, nil);
}

- (void)renameItemWithIdentifier:(NSFileProviderItemIdentifier)itemIdentifier
                          toName:(NSString *)itemName
               completionHandler:(void (^)(NSFileProviderItem _Nullable renamedItem, NSError * _Nullable error))completionHandler
{
    completionHandler(nil, nil);
}
- (void)createDirectoryWithName:(NSString *)directoryName
         inParentItemIdentifier:(NSFileProviderItemIdentifier)parentItemIdentifier
              completionHandler:(void (^)(NSFileProviderItem _Nullable createdDirectoryItem, NSError * _Nullable error))completionHandler
{
    completionHandler(nil, nil);
}
- (void)importDocumentAtURL:(NSURL *)fileURL
     toParentItemIdentifier:(NSFileProviderItemIdentifier)parentItemIdentifier
          completionHandler:(void (^)(NSFileProviderItem _Nullable importedDocumentItem, NSError * _Nullable error))completionHandler
{
    completionHandler(nil, nil);
}
@end

NSString *FBSharedContainerHomeDirectory()
{
    return @"/";
}



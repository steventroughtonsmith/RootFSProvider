//
//  FileProviderEnumerator.m
//  FinderFileProvider
//
//  Created by Steven Troughton-Smith on 07/06/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import "FileProviderEnumerator.h"
#import "FileProviderItem.h"
#import "FileProviderExtension.h"

extern NSMutableDictionary *identifierLookupTable;

@interface NSString (MD5)
- (NSString *)generateMD5;
@end

@implementation FileProviderEnumerator

-(NSArray *)contentsForPath:(NSString *)path
{
    NSError *error = nil;
    NSArray *tempFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    
    if (error)
    {
        NSLog(@"ERROR: %@", error);
        
        if ([path isEqualToString:@"/System"])
            tempFiles = @[@"Library"];
        
        if ([path isEqualToString:@"/Library"])
            tempFiles = @[@"Preferences"];
        
        if ([path isEqualToString:@"/var"])
            tempFiles = @[@"mobile"];
        
        if ([path isEqualToString:@"/usr"])
            tempFiles = @[@"lib", @"libexec", @"bin"];
    }
    
    return tempFiles;
}

-(void)createLocalReferenceToPath:(NSString *)sourcePath
{
    NSString *identifier = [sourcePath generateMD5];
    
    identifierLookupTable[identifier] = sourcePath;
    
    NSString *bookmarkPath = [[NSFileProviderManager defaultManager].documentStorageURL.path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", identifier, [sourcePath lastPathComponent]]];
    
    BOOL isDir = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:sourcePath isDirectory:&isDir];
    [[NSFileManager defaultManager] removeItemAtPath:bookmarkPath error:nil];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:bookmarkPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[bookmarkPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        
        if (isDir)
        {
            [[NSFileManager defaultManager] linkItemAtPath:sourcePath toPath:bookmarkPath error:nil];
           // [[NSFileManager defaultManager] createSymbolicLinkAtPath:bookmarkPath withDestinationPath:sourcePath error:nil];
            [[NSFileManager defaultManager] setAttributes:@{NSFilePosixPermissions:@0777} ofItemAtPath:bookmarkPath error:nil];
        }
        else
        {
            [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:bookmarkPath error:nil];
        }
    }
}

- (instancetype)initWithEnumeratedItemIdentifier:(NSFileProviderItemIdentifier)enumeratedItemIdentifier {
    if (self = [super init]) {
        _enumeratedItemIdentifier = enumeratedItemIdentifier;
    }
    return self;
}

- (void)invalidate {
    // TODO: perform invalidation of server connection if necessary
}

- (void)enumerateItemsForObserver:(id<NSFileProviderEnumerationObserver>)observer startingAtPage:(NSFileProviderPage)page {
    /* TODO:
     - inspect the page to determine whether this is an initial or a follow-up request
     
     If this is an enumerator for a directory, the root container or all directories:
     - perform a server request to fetch directory contents
     If this is an enumerator for the active set:
     - perform a server request to update your local database
     - fetch the active set from your local database
     
     - inform the observer about the items returned by the server (possibly multiple times)
     - inform the observer that you are finished with this page
     */
    
    NSMutableArray *providersArray = @[].mutableCopy;
    
    NSString *basePath = identifierLookupTable[_enumeratedItemIdentifier];
    
    BOOL dir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:basePath isDirectory:&dir];
    
    if (!basePath)
    {
        
        NSLog(@"NO BASE PATH!!");
        return;
        
    }
    
    if (dir)
    {
        for (NSString *item in [self contentsForPath:basePath])
        {
            NSString *path = [basePath stringByAppendingPathComponent:item];
            
            [self createLocalReferenceToPath:path];
            
            
            FileProviderItem *providerItem = [[FileProviderItem alloc] initWithPath:path];
            [providersArray addObject:providerItem];
        }
        
        //    [observer finishEnumeratingWithError:[NSError errorWithDomain:NSFileProviderErrorDomain
        //                                                             code:NSFileProviderErrorNotAuthenticated
        //                                                         userInfo:nil]];
        
        [observer didEnumerateItems:providersArray];
    }
    
    [observer finishEnumeratingUpToPage:nil];
}


@end


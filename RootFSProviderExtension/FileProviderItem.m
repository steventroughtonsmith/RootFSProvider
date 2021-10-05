//
//  FileProviderItem.m
//  FinderFileProvider
//
//  Created by Steven Troughton-Smith on 07/06/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

@import MobileCoreServices;
#import <CommonCrypto/CommonDigest.h>

#import "FileProviderItem.h"
#import "FileProviderExtension.h"


@implementation NSString (MD5)
/*
 
 https://github.com/Wixel/NSString-MD5/blob/master/NSString%2BMD5.m
 
 The MIT License (MIT)
 
 Copyright (c) 2013 Wixel Development Team
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

- (NSString *)generateMD5{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, (unsigned int)strlen(cStr), result );
    
    return [NSString
            stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}
@end

extern NSMutableDictionary *identifierLookupTable;

@implementation FileProviderItem

- (instancetype)initWithPath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        self.internalFilePath = filePath;
    }
    return self;
}

- (NSFileProviderItemIdentifier)itemIdentifier
{
    if ([self.internalFilePath isEqualToString:FBSharedContainerHomeDirectory()])
        return NSFileProviderRootContainerItemIdentifier;
    else
        return [self.internalFilePath generateMD5];
}

- (NSFileProviderItemIdentifier)parentItemIdentifier
{
    if ([[self.internalFilePath stringByDeletingLastPathComponent] isEqualToString:FBSharedContainerHomeDirectory()])
        return NSFileProviderRootContainerItemIdentifier;
    else
        return [[self.internalFilePath stringByDeletingLastPathComponent] generateMD5];
}

- (NSFileProviderItemCapabilities)capabilities
{
    
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:self.internalFilePath isDirectory:&isDirectory];
    
    return isDirectory? NSFileProviderItemCapabilitiesAllowsContentEnumerating : NSFileProviderItemCapabilitiesAllowsReading;
}

- (NSString *)filename
{
    return self.internalFilePath.lastPathComponent;
}

- (NSString *)typeIdentifier
{
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:self.internalFilePath isDirectory:&isDirectory];
    return isDirectory? @"public.folder" : (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, CFBridgingRetain(self.internalFilePath.pathExtension), NULL);
}

-(BOOL)isDownloaded
{
    return YES;
}

-(BOOL)isUploaded
{
    return YES;
}

-(BOOL)isMostRecentVersionDownloaded
{
    return YES;
}

-(NSNumber *)documentSize
{
    NSDictionary *attribs = [[NSFileManager defaultManager] attributesOfItemAtPath:self.internalFilePath error:nil];
    
    unsigned long long fileSize = [attribs fileSize];
    
    return @(fileSize);
}

-(NSNumber *)childItemCount
{
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.internalFilePath error:nil];
    return @(contents.count);
}

-(NSData *)versionIdentifier
{
    NSTimeInterval i = [NSDate timeIntervalSinceReferenceDate];
    
    return [[NSString stringWithFormat:@"%f", i] dataUsingEncoding:NSUTF8StringEncoding];
}
//
//-(NSDate *)creationDate
//{
//    return [NSDate date];
//}
//
//-(NSDate *)contentModificationDate
//{
//    return [NSDate date];
//}

@end


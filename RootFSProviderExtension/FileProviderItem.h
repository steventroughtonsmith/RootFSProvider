//
//  FileProviderItem.h
//  FinderFileProvider
//
//  Created by Steven Troughton-Smith on 07/06/2017.
//  Copyright © 2017 High Caffeine Content. All rights reserved.
//

#import <FileProvider/FileProvider.h>

@interface FileProviderItem : NSObject <NSFileProviderItem>

@property NSString *internalFilePath;
- (instancetype)initWithPath:(NSString *)filePath;


@end


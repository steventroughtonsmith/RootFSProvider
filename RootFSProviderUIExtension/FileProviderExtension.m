//
//  FileProviderExtension.m
//  RootFSProviderUIExtension
//
//  Created by Steven Troughton-Smith on 01/07/2017.
//  Copyright © 2017 Steven Troughton-Smith. All rights reserved.
//

#import "FileProviderExtension.h"

@implementation FileProviderExtension

- (void)prepareForAuthentication
{
	// NSLog(@"FILE UI?? PREPARE FOR AUTH");
	//[super prepareForAuthentication];
}

- (void)prepareForActionWithIdentifier:(NSString *)actionIdentifier itemIdentifiers:(NSArray <NSFileProviderItemIdentifier> *)itemIdentifiers
{
	// [super prepareForActionWithIdentifier:actionIdentifier itemIdentifiers:itemIdentifiers];
}
@end


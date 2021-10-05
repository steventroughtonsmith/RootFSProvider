//
//  PreviewViewController.m
//  NeuePreviewExtension
//
//  Created by Steven Troughton-Smith on 08/11/2019.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#import "PreviewViewController.h"
#import <QuickLook/QuickLook.h>

@interface PreviewViewController () <QLPreviewingController>

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
 * Implement this method and set QLSupportsSearchableItems to YES in the Info.plist of the extension if you support CoreSpotlight.
 *
- (void)preparePreviewOfSearchableItemWithIdentifier:(NSString *)identifier queryString:(NSString * _Nullable)queryString completionHandler:(void (^)(NSError * _Nullable))handler {
    // Perform any setup necessary in order to prepare the view.
    
    // Call the completion handler so Quick Look knows that the preview is fully loaded.
    // Quick Look will display a loading spinner while the completion handler is not called.
    handler (nil);
}
 */

- (void)preparePreviewOfFileAtURL:(NSURL *)url completionHandler:(void (^)(NSError * _Nullable))handler {
    
    // Add the supported content types to the QLSupportedContentTypes array in the Info.plist of the extension.
    
    // Perform any setup necessary in order to prepare the view.
    
    // Call the completion handler so Quick Look knows that the preview is fully loaded.
    // Quick Look will display a loading spinner while the completion handler is not called.
    handler(nil);
}


@end

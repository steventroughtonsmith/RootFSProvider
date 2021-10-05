//
//  ThumbnailProvider.m
//  RootFSThumbnailExtension
//
//  Created by Steven Troughton-Smith on 08/11/2019.
//  Copyright © 2019 Steven Troughton-Smith. All rights reserved.
//

#import "ThumbnailProvider.h"
#import <UIKit/UIKit.h>

@implementation ThumbnailProvider

- (void)provideThumbnailForFileRequest:(QLFileThumbnailRequest *)request completionHandler:(void (^)(QLThumbnailReply * _Nullable, NSError * _Nullable))handler {
    
    // There are three ways to provide a thumbnail through a QLThumbnailReply. Only one of them should be used.
    
    // First way: Draw the thumbnail into the current context, set up with UIKit's coordinate system.
    handler([QLThumbnailReply replyWithContextSize:request.maximumSize currentContextDrawingBlock:^BOOL {
        // Draw the thumbnail here.
		
		[[UIColor redColor] set];
		
		UIRectFill(CGRectMake(0, 0, request.maximumSize.width, request.maximumSize.height));
        
        // Return YES if the thumbnail was successfully drawn inside this block.
        return YES;
    }], nil);
    
    /*
    
    // Second way: Draw the thumbnail into a context passed to your block, set up with Core Graphics's coordinate system.
    handler([QLThumbnailReply replyWithContextSize:request.maximumSize drawingBlock:^BOOL(CGContextRef  _Nonnull context) {
        // Draw the thumbnail here.
     
        // Return YES if the thumbnail was successfully drawn inside this block.
        return YES;
    }], nil);
     
    // Third way: Set an image file URL.
    handler([QLThumbnailReply replyWithImageFileURL:[NSBundle.mainBundle URLForResource:@"fileThumbnail" withExtension:@"jpg"]], nil);
    
    */
}

@end

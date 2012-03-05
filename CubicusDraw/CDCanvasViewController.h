//
//  CDCanvasViewController.h
//  CubicusDraw
//
//  Created by James Potter on 05/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface CDCanvasViewController : NSViewController {
    @private
    WebView *_webView;
}

@end

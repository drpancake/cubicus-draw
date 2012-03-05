//
//  CDCanvasViewController.m
//  CubicusDraw
//
//  Created by James Potter on 05/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CDCanvasViewController.h"

@interface CDCanvasViewController ()

@end

@implementation CDCanvasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)loadView
{
    // Load nib
    [super loadView];
    
    _webView = [[WebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
    WebFrame *webFrame = [_webView mainFrame];
    
    NSString *html = @"<html><body>"
    "<canvas style='width: 100%; height=100%; background: blue' id='canvas'></canvas>"
    "<script type='text/javascript'>"
    "window.canvas = document.getElementById('canvas');"
    "window.context = window.canvas.getContext('2d');"
    "window.context.fillRect(50, 50, 100, 100);"
    "</script>"
    "</body></html>";
    
    [webFrame loadHTMLString:html baseURL:[NSURL URLWithString:@""]];
}

@end

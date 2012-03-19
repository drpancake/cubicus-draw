//
//  CDDrawingViewController.h
//  CubicusDraw
//
//  Created by James Potter on 26/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CBShared.h"
#import "JPCanvasViewController.h"

@interface CDDrawingViewController : NSViewController <CBContextManagerDelegate, JPCanvasViewControllerDelegate, CBAppClientDelegate>

@property (nonatomic, strong, readonly) CBAppClient *client;
@property (weak) IBOutlet NSView *canvasView;
@property (weak) IBOutlet NSView *toolsView;
@property (nonatomic, strong, readonly) JPCanvasViewController *canvasViewController;

@end

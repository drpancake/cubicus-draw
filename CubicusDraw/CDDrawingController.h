//
//  CDDrawingController.h
//  CubicusDraw
//
//  Created by James Potter on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CBShared.h"
#import "JPCanvasViewController.h"

@interface CDDrawingController : NSWindowController <CBContextManagerDelegate, JPCanvasViewControllerDelegate>

- (id)initWithClient:(CBAppClient *)client;

// Create context manager
- (void)createCubicusContext;

@property (nonatomic, strong, readonly) CBAppClient *client;
@property (nonatomic, strong, readonly) JPCanvasViewController *canvasViewController;

@end

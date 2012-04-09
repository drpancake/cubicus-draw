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
#import "CDToolsViewController.h"

/*
  Creates/owns a JPCanvasViewController and displays its view as a
  subview of the main NIB view.
 
  Creates/owns a CDToolsViewController.
 */

@interface CDDrawingViewController : NSViewController <CBContextManagerDelegate, JPCanvasViewControllerDelegate, CBAppClientDelegate>

@property (nonatomic, strong, readonly) CBAppClient *client;
@property (nonatomic, strong, readonly) JPCanvasViewController *canvasViewController;
@property (nonatomic, strong, readonly) CDToolsViewController *toolsViewController;

@end

//
//  CDDrawingViewController.h
//  CubicusDraw
//
//  Created by James Potter on 26/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CBShared.h"

@interface CDDrawingViewController : NSViewController<CBContextManagerDelegate>

@property (nonatomic, strong, readonly) CBAppClient *client;
@property (weak) IBOutlet NSView *canvasView;
@property (weak) IBOutlet NSView *toolsView;

@end

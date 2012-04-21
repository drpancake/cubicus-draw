//
//  CDToolsController.h
//  CubicusDraw
//
//  Created by James Potter on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBShared.h"

/*
  Must match TAG for NSButton items in IB
*/
enum {
    CDToolsControllerButtonRed = 1,
    CDToolsControllerButtonBlue = 2
} CDToolsControllerButton;

@interface CDToolsController : NSWindowController <CBContextManagerDelegate> {
@private
    // Models for the Cubicus representation of context's buttons
    NSMutableArray *_cubicusButtons;
}

- (id)initWithClient:(CBAppClient *)client;

// Sync NSButton views with Cubicus models
- (void)syncWithModels;

// Create context manager
- (void)createCubicusContext;

- (IBAction)didClickColor:(id)sender;

@property (nonatomic, strong, readonly) CBAppClient *client;

@end

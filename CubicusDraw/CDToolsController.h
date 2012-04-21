//
//  CDToolsController.h
//  CubicusDraw
//
//  Created by James Potter on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBShared.h"

enum {
    CDToolsControllerRed,
    CDToolsControllerBlue
} CBToolsControllerElement;

@interface CDToolsController : NSWindowController <CBContextManagerDelegate>

- (id)initWithClient:(CBAppClient *)client;

// Load context managers
- (void)loadCubicusContexts;

- (IBAction)didClickColor:(id)sender;

@property (nonatomic, strong, readonly) CBAppClient *client;
@property (nonatomic, readwrite) int selectedColor;

@end

//
//  CDAppDelegate.h
//  CubicusDraw
//
//  Created by James Potter on 26/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CBShared.h"
#import "CDDrawingController.h"
#import "CDToolsController.h"

@interface CDAppDelegate : NSObject <NSApplicationDelegate, CBAppClientDelegate>

@property (nonatomic, strong) CDDrawingController *drawingController;
@property (nonatomic, strong) CDToolsController *toolsController;
@property (nonatomic, strong) CBAppClient *client;

@end

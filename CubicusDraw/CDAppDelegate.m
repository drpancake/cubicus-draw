//
//  CDAppDelegate.m
//  CubicusDraw
//
//  Created by James Potter on 26/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CDAppDelegate.h"

@implementation CDAppDelegate

@synthesize window = _window;
@synthesize drawingViewController = _drawingViewController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.drawingViewController = [[CDDrawingViewController alloc] initWithNibName:nil bundle:nil];
    [self.window setContentView:self.drawingViewController.view];
}

@end

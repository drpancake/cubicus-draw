//
//  CDAppDelegate.m
//  CubicusDraw
//
//  Created by James Potter on 26/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CDAppDelegate.h"

@implementation CDAppDelegate

@synthesize drawingController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Usually MainMenu NIB does this bit magically
    self.drawingController = [[CDDrawingController alloc] initWithWindowNibName:@"CDDrawingController"];
    [self.drawingController showWindow:nil];
    
}

@end

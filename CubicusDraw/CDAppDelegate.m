//
//  CDAppDelegate.m
//  CubicusDraw
//
//  Created by James Potter on 26/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CDAppDelegate.h"
#import "CubicusDraw.h"

@implementation CDAppDelegate

@synthesize drawingController;
@synthesize toolsController;
@synthesize client;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Create a client but don't connect yet
    CBHost *host = [[CBHost alloc] initWithAddress:CD_DAEMON_HOST port:[NSNumber numberWithInt:CD_DAEMON_PORT]];
    self.client = [[CBAppClient alloc] initWithHost:host applicationName:CD_APP_NAME];
    
    // NSPanel, so won't become key window
    self.toolsController = [[CDToolsController alloc] initWithClient:self.client];
    [self.toolsController showWindow:nil];
    
    // Usually MainMenu NIB does this bit magically
    self.drawingController = [[CDDrawingController alloc] initWithClient:self.client];
    [self.drawingController showWindow:nil];
    
    // By this point controllers have provided client with a set of
    // CBContextManager objects ready to send to daemon on connecting
    [self.client connect];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    if (self.client.connected)
        [self.client sendBecameActive];
}

@end

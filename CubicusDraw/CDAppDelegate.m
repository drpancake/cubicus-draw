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
    self.client.delegate = self;
    
    // Usually MainMenu NIB does this bit magically
    self.drawingController = [[CDDrawingController alloc] initWithClient:self.client];
    [self.drawingController showWindow:nil];

    self.toolsController = [[CDToolsController alloc] initWithClient:self.client];
    [self.toolsController showWindow:nil]; // NSPanel, so won't become key window
    
    // By this point controllers have provided client with a
    // set of CBContextManager objects ready to connect to daemon
    [self.client connect];
}

#pragma mark -
#pragma mark CBAppClientDelegate

- (void)client:(CBAppClient *)client didReceiveEvent:(CBEvent *)event
{
    NSLog(@"App delegate got event: %@", event);
    
    // For now forward to drawing controller
    [self.drawingController sender:self didFireEvent:event];
}

@end

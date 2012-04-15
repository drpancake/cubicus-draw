//
//  CDDrawingController.m
//  CubicusDraw
//
//  Created by James Potter on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CDDrawingController.h"
#import "CubicusDraw.h"

@implementation CDDrawingController

@synthesize client;
@synthesize canvasViewController;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create a client but don't connect yet
        CBHost *host = [[CBHost alloc] initWithAddress:CD_DAEMON_HOST port:[NSNumber numberWithInt:CD_DAEMON_PORT]];
        client = [[CBAppClient alloc] initWithHost:host applicationName:CD_APP_NAME];
        client.delegate = self;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Create canvas and use it as our window's view
    canvasViewController = [[JPCanvasViewController alloc] init];
    [self.window setContentView:canvasViewController.view];

    [self loadCubicusContexts];
}

- (void)loadCubicusContexts
{
    NSString *buttonString = @"{\"id\": 2, \"type\": \"button\", \"label\": \"Button\", \"ratio\": 0.3}";
    NSString *canvasString = @"{\"id\": 3, \"type\": \"canvas\", \"ratio\": 0.7}";
    NSString *hboxString = [NSString stringWithFormat:
                            @"{\"id\": 1, \"type\": \"hbox\", \"ratio\": 1, \"items\": [%@, %@]}",
                            buttonString, canvasString];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    CBLayout *canvasLayout = [CBLayout fromJSON:(NSDictionary *)[parser objectWithString:hboxString]];
    CBContext *context = [[CBContext alloc] initWithID:1 layout:canvasLayout];
    
    CBContextManager *canvasManager = [[CBContextManager alloc] initWithContext:context client:self.client];
    //    [canvasManager wrapView:self.view];
    [client addContextManager:canvasManager defaultContext:YES];
    
    // Tools context manager
    
    NSString *button1 = @"{\"id\": 2, \"type\": \"button\", \"label\": \"Button 1\", \"ratio\": 0.33}";
    NSString *button2 = @"{\"id\": 3, \"type\": \"button\", \"label\": \"Button 2\", \"ratio\": 0.33}";
    NSString *button3 = @"{\"id\": 4, \"type\": \"button\", \"label\": \"Button 3\", \"ratio\": 0.33}";
    hboxString = [NSString stringWithFormat:
                  @"{\"id\": 1, \"type\": \"hbox\", \"ratio\": 1, \"items\": [%@, %@, %@]}",
                  button1, button2, button3];
    CBLayout *toolsLayout = [CBLayout fromJSON:(NSDictionary *)[parser objectWithString:hboxString]];
    context = [[CBContext alloc] initWithID:2 layout:toolsLayout];
    
    CBContextManager *toolsManager = [[CBContextManager alloc] initWithContext:context client:self.client];
    //    [toolsManager wrapView:self.toolsViewController.view];
    [client addContextManager:toolsManager];
    
    // Connect to daemon
    [client connect];
}

#pragma mark -
#pragma mark CBAppClientDelegate

- (void)client:(CBAppClient *)client didReceiveEvent:(CBEvent *)event
{
    //    daemon sending wrong values
    NSLog(@"got event: %lu %lu", event.contextID, event.elementID);
    if (event.contextID == 1 && event.elementID == 3) {
        NSArray *points = [event.content objectForKey:@"points"];
        [self.canvasViewController drawPoints:points];
    }
}

#pragma mark -
#pragma mark JPCanvasViewControllerDelegate

- (void)canvas:(JPCanvasViewController *)canvas didDrawPoints:(NSArray *)points
{
    // Points hard-coded for now
    NSDictionary *content = [NSDictionary dictionaryWithObjectsAndKeys:points, @"points", nil];
    CBEvent *event = [[CBEvent alloc] initWithID:3 content:content];
    event.contextID = 1;
    [client sendEvent:event];
}

@end

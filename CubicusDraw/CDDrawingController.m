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

- (id)initWithClient:(CBAppClient *)theClient
{
    self = [super initWithWindowNibName:NSStringFromClass([self class])];
    if (self) {
        client = theClient;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Create canvas and use it as our window's view
    canvasViewController = [[JPCanvasViewController alloc] init];
    canvasViewController.delegate = self;
    [self.window setContentView:canvasViewController.view];

    [self createCubicusContext];
}

- (void)createCubicusContext
{
    NSString *buttonString = @"{\"id\": 2, \"type\": \"button\", \"label\": \"Button\", \"ratio\": 0.3}";
    NSString *canvasString = @"{\"id\": 3, \"type\": \"canvas\", \"ratio\": 0.7}";
    NSString *hboxString = [NSString stringWithFormat:
                            @"{\"id\": 1, \"type\": \"hbox\", \"ratio\": 1, \"items\": [%@, %@]}",
                            buttonString, canvasString];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    CBLayout *canvasLayout = [CBLayout fromJSON:(NSDictionary *)[parser objectWithString:hboxString]];
    CBContext *context = [[CBContext alloc] initWithID:CD_DRAWING_CONTEXT layout:canvasLayout];
    
    CBContextManager *manager = [[CBContextManager alloc] initWithContext:context];
    manager.delegate = self;
    //    [manager wrapView:self.view];
    [client addContextManager:manager defaultContext:YES];
}

#pragma mark -
#pragma mark JPCanvasViewControllerDelegate

- (void)canvas:(JPCanvasViewController *)canvas didDrawPoints:(NSArray *)points
{
    // Points hard-coded for now
    NSDictionary *content = [NSDictionary dictionaryWithObjectsAndKeys:points, @"points", nil];
    CBEvent *event = [[CBEvent alloc] initWithID:3 content:content];
    event.contextID = CD_DRAWING_CONTEXT;
    [client sendEvent:event];
}

#pragma mark -
#pragma mark CBContextManagerDelegate

- (void)manager:(CBContextManager *)manager didReceiveEvent:(CBEvent *)event
{
    if (event.elementID == 3) {
        // Event is intended for canvas
        NSArray *points = [event.content objectForKey:@"points"];
        [self.canvasViewController drawPoints:points];
    }
}

@end

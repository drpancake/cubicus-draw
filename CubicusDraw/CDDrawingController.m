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
}

#pragma mark -
#pragma mark CBEventReceiver

- (void)sender:(id)sender didFireEvent:(CBEvent *)event
{
    NSLog(@"drawing controller got event: %lu %lu", event.contextID, event.elementID);
    if (event.contextID == 1 && event.elementID == 3) {
        // Event is intended for canvas
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

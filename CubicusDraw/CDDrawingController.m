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
    
    // Cubicus
    [self createCubicusContext];
    
    // Set canvas color according to notifications from tools window
    [[NSNotificationCenter defaultCenter] addObserverForName:CD_COLOR_NOTIFICATION
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:
     ^(NSNotification *note) {
         NSString *color = [note.userInfo objectForKey:@"color"];
         self.canvasViewController.strokeColor = color;
         
         // Fire an event so remote client is aware of the new colour
         NSDictionary *content = [NSDictionary dictionaryWithObjectsAndKeys:color, @"color", nil];
         CBEvent *event = [[CBEvent alloc] initWithID:1 content:content];
         event.contextID = CD_DRAWING_CONTEXT;
         [self.client sendEvent:event];
    }];
}

- (void)createCubicusContext
{
    // Canvas
    CBCanvas *canvas = [[CBCanvas alloc] init];
    canvas.elementID = 1;
    canvas.ratio = 1;
    
    // Container
    CBHorizontalBox *box = [[CBHorizontalBox alloc] init];
    box.elementID = 2;
    box.ratio = 1;
    box.items = [NSArray arrayWithObject:canvas];
    
    // Context model
    CBLayout *layout = [[CBLayout alloc] initWithRoot:box];
    CBContext *context = [[CBContext alloc] initWithID:CD_DRAWING_CONTEXT layout:layout];
    
    // Create context manager and register it
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
    CBEvent *event = [[CBEvent alloc] initWithID:1 content:content];
    event.contextID = CD_DRAWING_CONTEXT;
    [client sendEvent:event];
}

#pragma mark -
#pragma mark CBContextManagerDelegate

- (void)manager:(CBContextManager *)manager didReceiveEvent:(CBEvent *)event
{
    if (event.elementID == 1) {
        // Event is intended for canvas
        NSArray *points = [event.content objectForKey:@"points"];
        [self.canvasViewController drawPoints:points];
    }
}

@end

//
//  CDDrawingViewController.m
//  CubicusDraw
//
//  Created by James Potter on 26/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CDDrawingViewController.h"
#import "CubicusDraw.h"
#import "CBContextManager.h"
#import "SBJson.h"

@implementation CDDrawingViewController

@synthesize client;
@synthesize canvasView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Create a client but don't connect yet
        CBHost *host = [[CBHost alloc] initWithAddress:CD_DAEMON_HOST port:[NSNumber numberWithInt:CD_DAEMON_PORT]];
        client = [[CBAppClient alloc] initWithHost:host];
    }
    
    return self;
}

- (void)awakeFromNib
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    // Create context manager(s) to wrap views
    NSString *s = @"{\"id\": 1, \"type\": \"hbox\", \"items\": []}";
    CBLayout *canvasLayout = [CBLayout fromJSON:(NSDictionary *)[parser objectWithString:s]];
    CBContext *context = [[CBContext alloc] initWithID:1 layout:canvasLayout];
    
    CBContextManager *canvasManager = [[CBContextManager alloc] initWithContext:context];
    [canvasManager wrapView:self.canvasView];
    [client addContextManager:canvasManager];
    
    // Connect to daemon
    [client connect];
}

@end

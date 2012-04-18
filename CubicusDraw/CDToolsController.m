//
//  CDToolsController.m
//  CubicusDraw
//
//  Created by James Potter on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CDToolsController.h"

@implementation CDToolsController

@synthesize client;

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
    [self loadCubicusContexts];
}

- (void)loadCubicusContexts
{    
    NSString *button1 = @"{\"id\": 2, \"type\": \"button\", \"label\": \"Button 1\", \"ratio\": 0.33}";
    NSString *button2 = @"{\"id\": 3, \"type\": \"button\", \"label\": \"Button 2\", \"ratio\": 0.33}";
    NSString *button3 = @"{\"id\": 4, \"type\": \"button\", \"label\": \"Button 3\", \"ratio\": 0.33}";
    NSString *hboxString = [NSString stringWithFormat:
                  @"{\"id\": 1, \"type\": \"hbox\", \"ratio\": 1, \"items\": [%@, %@, %@]}",
                  button1, button2, button3];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    CBLayout *toolsLayout = [CBLayout fromJSON:(NSDictionary *)[parser objectWithString:hboxString]];
    CBContext *context = [[CBContext alloc] initWithID:2 layout:toolsLayout];
    
    CBContextManager *manager = [[CBContextManager alloc] initWithContext:context];
//    [manager wrapView:self.window.contentView];
    [client addContextManager:manager];
}

@end

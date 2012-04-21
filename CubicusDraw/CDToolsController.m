//
//  CDToolsController.m
//  CubicusDraw
//
//  Created by James Potter on 15/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CDToolsController.h"
#import "CubicusDraw.h"

@implementation CDToolsController

@synthesize client;
@synthesize selectedColor;

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
    
    // Blue by default
    self.selectedColor = CDToolsControllerBlue;
}

- (void)loadCubicusContexts
{    
    NSString *red = [NSString stringWithFormat:
                     @"{\"id\": %i, \"type\": \"button\", \"label\": \"Red\", \"ratio\": 0.5, \"selected\": true, \"group\": 1}", CDToolsControllerRed];
    NSString *blue = [NSString stringWithFormat:
                     @"{\"id\": %i, \"type\": \"button\", \"label\": \"Blue\", \"ratio\": 0.5, \"group\": 1}", CDToolsControllerBlue];
    
    NSString *hbox = [NSString stringWithFormat:
                      @"{\"id\": 1, \"type\": \"hbox\", \"ratio\": 1, \"items\": [%@, %@]}",
                      red, blue];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    CBLayout *layout = [CBLayout fromJSON:(NSDictionary *)[parser objectWithString:hbox]];
    CBContext *context = [[CBContext alloc] initWithID:CD_TOOLS_CONTEXT layout:layout];
    
    CBContextManager *manager = [[CBContextManager alloc] initWithContext:context];
    manager.delegate = self;
//    [manager wrapView:self.window.contentView];
    [client addContextManager:manager];
}

#pragma mark -
#pragma mark Buttons

- (IBAction)didClickColor:(id)sender {
    NSLog(@"clicked color - b = %@", sender);
    
    NSButton *button = (NSButton *)sender;
    NSUInteger elementID;
    if ([button.title isEqualToString:@"Red"]) {
        elementID = CDToolsControllerRed;
    } else if ([button.title isEqualToString:@"Blue"]) {
        elementID = CDToolsControllerBlue;
    }
    
    BOOL selected = (button.state == NSOnState);
    NSDictionary *content = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithBool:selected], @"selected", nil];
    CBEvent *event = [[CBEvent alloc] initWithID:elementID content:content];
    event.contextID = CD_TOOLS_CONTEXT;
    [self.client sendEvent:event];
    
//    [button highlight:YES];
    [button setState:NSOffState];
}

#pragma mark -
#pragma mark CBContextManagerDelegate

- (void)manager:(CBContextManager *)manager didReceiveEvent:(CBEvent *)event
{   
    if (event.elementID == CDToolsControllerRed) {
        NSLog(@"got event for red button");
    } else if (event.elementID == CDToolsControllerBlue) {
        NSLog(@"got event for blue button");
    }
}

@end

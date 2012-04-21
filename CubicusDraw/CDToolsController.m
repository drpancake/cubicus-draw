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

- (id)initWithClient:(CBAppClient *)theClient
{
    self = [super initWithWindowNibName:NSStringFromClass([self class])];
    if (self) {
        client = theClient;
        _cubicusButtons = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self createCubicusContext];
}

- (void)createCubicusContext
{
    // Create color buttons
    CBButton *button;
    
    button = [[CBButton alloc] init];
    button.elementID = CDToolsControllerButtonRed;
    button.ratio = 0.5;
    button.label = @"Red";
    button.group = 1;
    button.selected = YES;
    [_cubicusButtons addObject:button];
    
    button = [[CBButton alloc] init];
    button.elementID = CDToolsControllerButtonBlue;
    button.ratio = 0.5;
    button.label = @"Blue";
    button.group = 1;
    button.selected = NO;
    [_cubicusButtons addObject:button];
    
    // Lay them out horizontally
    CBHorizontalBox *box = [[CBHorizontalBox alloc] init];
    box.elementID = 3;
    box.ratio = 1;
    box.items = [NSArray arrayWithArray:_cubicusButtons];
    
    // Context model
    CBLayout *layout = [[CBLayout alloc] initWithRoot:box];
    CBContext *context = [[CBContext alloc] initWithID:CD_TOOLS_CONTEXT layout:layout];
    
    // Create context manager and register it
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
        elementID = CDToolsControllerButtonRed;
    } else if ([button.title isEqualToString:@"Blue"]) {
        elementID = CDToolsControllerButtonBlue;
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
    if (event.elementID == CDToolsControllerButtonRed) {
        NSLog(@"got event for red button");
    } else if (event.elementID == CDToolsControllerButtonBlue) {
        NSLog(@"got event for blue button");
    }
}

@end

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
    
    // KVO to observe selection state for all buttons
    for (CBButton *b in _cubicusButtons) {
        [b addObserver:self
            forKeyPath:@"selected"
               options:NSKeyValueObservingOptionNew
               context:NULL];
    }
    
    // Lay out buttons horizontally
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
    
    // Initial visual sync of NSButtons with models
    [self syncWithModels];
}

#pragma mark -
#pragma mark KVO

- (void)dealloc
{
    // Tidy up KVO
    for (CBButton *b in _cubicusButtons) {
        [b removeObserver:self forKeyPath:@"selected"];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"selected"]) {
        [self syncWithModels];
    }
}

#pragma mark -
#pragma mark Buttons

- (void)syncWithModels
{
    for (CBButton *button in _cubicusButtons) {
        // Fetch the corresponding NSButton view
        NSButton *buttonView = [self.window.contentView viewWithTag:button.elementID];
        [buttonView highlight:button.selected];
        buttonView.state = button.selected ? NSOnState : NSOffState;
        
        // For the color selected, fire a notification so drawing window knows the current color
        if (button.selected) {
            // Decide on RGBA colour string
            NSString *color;
            if (button.elementID == CDToolsControllerButtonRed) {
                color = @"rgba(255, 0, 0, 0.1)";
            } else if (button.elementID == CDToolsControllerButtonBlue) {
                color = @"rgba(0, 0, 255, 0.1)";
            }
            
            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:color, @"color", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:CD_COLOR_NOTIFICATION object:self userInfo:info];
        }
    }
}

- (IBAction)didClickColor:(id)sender {
    // Set the corresponding model's selected state to YES
    // and all others to NO
    NSButton *buttonView = (NSButton *)sender;
    NSInteger elementID = buttonView.tag;
    for (CBButton *button in _cubicusButtons) {
        // TODO: this triggers needless calls to syncWithModels
        button.selected = (button.elementID == elementID);
    }
    
    // Fire an event to daemon
    NSDictionary *content = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], @"selected", nil];
    CBEvent *event = [[CBEvent alloc] initWithID:elementID content:content];
    event.contextID = CD_TOOLS_CONTEXT;
    [self.client sendEvent:event];
}

#pragma mark -
#pragma mark CBContextManagerDelegate

- (void)manager:(CBContextManager *)manager didReceiveEvent:(CBEvent *)event
{   
    // Assume this is a 'selected' event
    BOOL selected = [[event.content objectForKey:@"selected"] boolValue];
    
    // Work out button group for the recipient
    NSUInteger group;
    for (CBButton *button in _cubicusButtons) {
        if (button.elementID == event.elementID) {
            group = button.group;
            if (group == -1) {
                // Not in a group so just select/deselect and we're done
                button.selected = selected;
            }
            break;
        }
    }
    
    if (group != -1) {
        // Select the recipient, deselect all others in the group
        for (CBButton *button in _cubicusButtons) {
            if (button.group == group) {
                button.selected = (button.elementID == event.elementID);
            }
        }
    }
}

@end

//
//  CDDrawingViewController.h
//  CubicusDraw
//
//  Created by James Potter on 26/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CBHost.h"
#import "CBAppClient.h"

@interface CDDrawingViewController : NSViewController

@property (nonatomic, strong, readonly) CBAppClient *client;

@end

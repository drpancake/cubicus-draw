//
//  CDAppDelegate.h
//  CubicusDraw
//
//  Created by James Potter on 26/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CDDrawingController.h"

@interface CDAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) CDDrawingController *drawingController;

@end

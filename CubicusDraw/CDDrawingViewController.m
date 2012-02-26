//
//  CDDrawingViewController.m
//  CubicusDraw
//
//  Created by James Potter on 26/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CDDrawingViewController.h"

@implementation CDDrawingViewController

@synthesize client;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        CBHost *host = [[CBHost alloc] initWithAddress:@"localhost" port:[NSNumber numberWithInt:28739]];
        client = [[CBAppClient alloc] initWithHost:host];

    }
    
    return self;
}

- (void)awakeFromNib
{
    [client connect];
}

@end

//
//  GraphView.m
//  Calculator
//
//  Created by Chris D'Angelo on 12/31/12.
//  Copyright (c) 2012 Chris D'Angelo. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // self.contentMode = UIViewContentModeRedraw has been set in Interface Builder for iPhone
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
#define SCALE 10.0
    
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midPoint scale:SCALE];
    
    // calc left x value
    
    // calc right x value
    // draw poitns in between
}


@end

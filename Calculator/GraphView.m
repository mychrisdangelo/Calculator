//
//  GraphView.m
//  Calculator
//
//  Created by Chris D'Angelo on 12/31/12.
//  Copyright (c) 2012 Chris D'Angelo. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView()
@property (nonatomic) CGFloat scale;
@end

@implementation GraphView

@synthesize scale = _scale;

#define DEFAULT_SCALE 1

- (CGFloat)scale
{
    if (!_scale) return DEFAULT_SCALE;
    else return _scale;
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // call whenever scale changes
    }
}

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
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midPoint scale:self.scale];
    // calc left x value
    // calc right x value
    // draw poitns in between
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *=gesture.scale;
        gesture.scale = 1;
    }
}


@end

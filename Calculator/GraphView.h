//
//  GraphView.h
//  Calculator
//
//  Created by Chris D'Angelo on 12/31/12.
//  Copyright (c) 2012 Chris D'Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView; // forward declaration

@protocol GraphViewDataSource
- (float)yValue:(float)xValue sender:(GraphView *)sender;
@end;

@interface GraphView : UIView

@property (nonatomic, weak) id <GraphViewDataSource> dataSource; // ok for weak ptr, held strong by implementor of protocol

@end

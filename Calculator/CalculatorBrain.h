//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Chris D'Angelo on 12/29/12.
//  Copyright (c) 2012 Chris D'Angelo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)makeEmpty;

@end

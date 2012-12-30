//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Chris D'Angelo on 12/29/12.
//  Copyright (c) 2012 Chris D'Angelo. All rights reserved.
//

#import "CalculatorBrain.h"

// private functions exclusive to implementation file
@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    // empty NSMutableArray will return nil (0)
    // only setters and getter shoud access the instance variable directly
    if(!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    // again operandObject is a pointer to a NSNumber
    // it will be nil and the condition will be false
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (void)makeEmpty
{
    [self.operandStack removeAllObjects];
}

- (double)performOperation:(NSString *)operation
{
    double result = 0;
 
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        // on stack will be 3 4
        // but order of operation should be 3 - 4 not 4 - 3
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
        else result = 0;
    } else if ([operation isEqualToString:@"sin"]) {
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]) {
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt"]) {
        result = tan([self popOperand]);
    } else if ([operation isEqualToString:@"π"]) {
        result = M_PI;
    }
    
    [self pushOperand:result];
    
    return result;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"stack = %@", self.operandStack]; 
}

@end

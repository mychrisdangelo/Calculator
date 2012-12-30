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
@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    // empty NSMutableArray will return nil (0)
    // only setters and getter shoud access the instance variable directly
    if(!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;;
}

- (id)program
{
    return [self.programStack copy];
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

/*
 * This is public API which we are keeping for backwards compatibility
 * instead this function now calls the new private function
 * runProgram
 */
- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
                     [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
                     [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            // on stack will be 3 4
            // but order of operation should be 3 - 4 not 4 - 3
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
            else result = 0;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = tan([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"π"]) {
            result = M_PI;
        }
    }
    
    return result;
}

- (void)makeEmpty
{
    [self.programStack removeAllObjects];
}

+ (NSString *) descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}

/*
 * NSMutableArray *stack is a local variable that will be destroyed after return
 * This is ok because program mutableCopy is allocated on the heap
 * when the pointer is handed to the calling function the memory will still be intact but the pointer will have died
 * popOperandOffProgramStack will "eat" the operands/operators off the stack until the mutableCopy of the array
 * has been popped clean leaving no memory.  It returns the double
 */
+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"stack = %@", self.programStack]; 
}

@end

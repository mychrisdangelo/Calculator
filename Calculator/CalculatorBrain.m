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

//TODO: this should highlight
// HW instructions: "editing this implementation will be unecessary"
- (id)program
{
    return [self.programStack copy];
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

// if NSNumber is presented to isOperation then it will be converted implicitly to NSString
// it is obviously an operand and will not pass the test
+ (BOOL) isOperation:(NSString *)operation
{
    NSSet *operations = [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"sin", @"cos",
                         @"tan", @"sqrt", nil];
    return [operations containsObject:operation];
}

+ (BOOL) isSingleOperator:(NSString *)operation
{
    NSSet *operations = [NSSet setWithObjects:@"sin", @"cos", @"tan", @"sqrt", nil];
    return [operations containsObject:operation];
}

+ (BOOL) isNoOperandOperator:(NSString *)operation
{
    NSSet *operations = [NSSet setWithObjects:@"π", nil];
    return [operations containsObject:operation];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    if (![program isKindOfClass:[NSArray class]])
        return nil;
    
    // strings that are not operations must be variable names
    // return nil if none are found
    NSMutableSet *variablesUsed = [[NSMutableSet alloc] init];
    for (id each in program) {
        if (![each isKindOfClass:[NSNumber class]] && ![self isOperation:each] && ![self isNoOperandOperator:each]) {
            // not an operand, not an operator: so it must be a variable
            [variablesUsed addObject:each];
        }
    }

    // return NSMutableSet to return value NSSet should autocast the pointer id
    // i think
    return variablesUsed;
}

/*
 * This is public API which we are keeping for backwards compatibility
 * instead this function now calls the new private function
 * runProgram.  assumes that NO variable names are used. otherwise result is undefined
 */
- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (BOOL)isHighPrecedence:(NSString *)operator
{
    NSSet *operators = [NSSet setWithObjects:@"*", @"/", nil];
    return [operators containsObject:operator];
}

+ (NSString *)removeParens:(NSString *)expression
{
    if(expression.length <= 1 || !([expression characterAtIndex:0] == '(' &&
       [expression characterAtIndex:expression.length-1] == ')'))
        return expression;
    
    NSRange range = NSMakeRange(1, expression.length-2);
    return [expression substringWithRange:range];
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    NSString *result = @"";
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if (![self isOperation:topOfStack]) {
        result = [NSString stringWithString:[topOfStack description]];
    } else if ([self isSingleOperator:topOfStack]) {
        NSString *rhs = [self descriptionOfTopOfStack:stack];
        rhs = [self removeParens:rhs];
        result = [NSString stringWithFormat:@"%@(%@)", topOfStack, rhs];
    } else {
        // is multi-operand operation
        NSString *rhs = [self descriptionOfTopOfStack:stack];
        NSString *lhs = [self descriptionOfTopOfStack:stack];
        result = [NSString stringWithFormat:@"(%@ %@ %@)", lhs, topOfStack, rhs];
        if ([self isHighPrecedence:topOfStack]) result = [self removeParens:result];
    }

    // NSLog(@"returning from result: %@", result);
    return result;
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
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSString *result = [self descriptionOfTopOfStack:stack];
    result = [self removeParens:result];
    // NSLog(@"stack count %@", stack.count);
    while (stack.count) {
        NSString *rhs = [self descriptionOfTopOfStack:stack];
        rhs = [self removeParens:rhs];
        result = [result stringByAppendingFormat:@", %@", rhs];
    }
    return result;
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

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    // iterate through the stack replacing variable names
    for(int i = 0; i < stack.count; i++) {
        id key = stack[i];
        // if no value is in the dictionary then no value will be replaced and
        // objectAtIndex:i will remain
        NSNumber *value = [variableValues objectForKey:key];
        if (value)
            [stack replaceObjectAtIndex:i withObject:value];
    }
    
    return [self popOperandOffProgramStack:stack];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"stack = %@", self.programStack]; 
}

@end

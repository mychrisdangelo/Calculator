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

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
// returns all names of the variables used in given program, returns nil otherwise
+ (NSSet *)variablesUsedInProgram:(id)program;

@end

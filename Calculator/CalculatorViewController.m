//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Chris D'Angelo on 12/29/12.
//  Copyright (c) 2012 Chris D'Angelo. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

// this is where private functions can go
// these functions are not accessible outside of this file but they are still classified
// as "interface" (aka prototype for the functions)
// this is called "Class Extension" in Objective-C
@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize displayTape = _displayTape;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    // alloc and init run correct size memory allocation and initiliazation
    // "initialization" is the "constructor" call
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

// note: id is not an object is is a POINTER to an object
- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)clearPressed
{
    [self.brain makeEmpty];
    self.displayTape.text = @"";
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}


- (IBAction)decimalPressed:(UIButton *)sender
{
    BOOL decimalAlreadyEntered = [self.display.text rangeOfString:@"."].location == NSNotFound ? NO : YES;
    
    if (self.userIsInTheMiddleOfEnteringANumber && !decimalAlreadyEntered) {
        self.display.text = [self.display.text stringByAppendingString:@"."];
    } else if (self.userIsInTheMiddleOfEnteringANumber && decimalAlreadyEntered) {
        // do nothing
    } else if (!self.userIsInTheMiddleOfEnteringANumber) {
        // if no numbers have been entered leave the zero before the deimal
        self.display.text = [self.display.text stringByAppendingString:@"."];
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    self.displayTape.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)operationPressed:(UIButton *)sender
{
    // when operation is pressed implicitly hit enter
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    // could use dot notation here because sender is statically typed
    // ie. sender.currentTitle
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    self.displayTape.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

@end

















//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Chris D'Angelo on 12/29/12.
//  Copyright (c) 2012 Chris D'Angelo. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

// this is where private functions can go
// these functions are not accessible outside of this file but they are still classified
// as "interface" (aka prototype for the functions)
// this is called "Class Extension" in Objective-C
@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (strong, nonatomic) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize displayTape = _displayTape;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

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

- (void)updateAllDisplays
{
    double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    [self updateDisplayTape];
    [self updateDisplayVariables];
}

- (void)updateDisplayTape
{
    self.displayTape.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (void)updateDisplayVariables
{
    NSSet *variablesInProgram = [CalculatorBrain variablesUsedInProgram:self.brain.program];
    NSString *variablesToDisplay = @"";
    for (NSString *key in variablesInProgram) {
        variablesToDisplay = [variablesToDisplay stringByAppendingFormat:@"%@ = %@ ", key,
         [self.testVariableValues objectForKey:key]];
    }
    self.displayVariables.text = variablesToDisplay;
    self.userIsInTheMiddleOfEnteringANumber = NO;
}


- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    [self updateAllDisplays];
}

- (IBAction)testValues:(UIButton *)sender
{
    NSString *test = [sender currentTitle];
    if ([test isEqualToString:@"test 1"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:4.33], @"x",
                                   [NSNumber numberWithDouble:-44.1], @"y",
                                   [NSNumber numberWithDouble:99.33], @"z",
                                   nil];
    }
    
    if ([test isEqualToString:@"test 2"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:9.33], @"x",
                                   [NSNumber numberWithDouble:0], @"y",
                                   [NSNumber numberWithDouble:4.0], @"z",
                                   nil];
    }
    
    if ([test isEqualToString:@"test 3"]) {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   nil, @"x",
                                   nil, @"y",
                                   nil, @"z",
                                   nil];
    }
    
    [self updateAllDisplays];
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
    // performOperation with variables is undefined
    [self.brain performOperation:operation]; // will be undefined but pushes operator

    [self updateAllDisplays];
}

- (IBAction)undoPressed {
    if (self.display.text.length >= 1)
        self.display.text = [self.display.text substringToIndex:self.display.text.length-1];
    if (self.display.text.length == 0) {
        self.userIsInTheMiddleOfEnteringANumber = NO;
        [self.brain pop];
        [self updateAllDisplays];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowGraph"]) {
        [segue.destinationViewController setProgramStack:self.brain.program];
    }
}

- (GraphViewController *)splitViewGraphViewController
{
    id gvc = [self.splitViewController.viewControllers lastObject];
    if (![gvc isKindOfClass:[GraphViewController class]]) {
        gvc = nil;
    }
    return gvc;
}

- (IBAction)updateGraph:(id)sender
{
    [[self splitViewGraphViewController] setProgramStack:self.brain.program];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end

















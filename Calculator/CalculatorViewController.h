//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Chris D'Angelo on 12/29/12.
//  Copyright (c) 2012 Chris D'Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *displayTape;
// currently unused. previously a display for the variables used in the program stack and their values
@property (weak, nonatomic) IBOutlet UILabel *displayVariables;
@end

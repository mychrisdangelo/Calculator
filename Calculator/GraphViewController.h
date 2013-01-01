//
//  GraphViewController.h
//  Calculator
//
//  Created by Chris D'Angelo on 12/31/12.
//  Copyright (c) 2012 Chris D'Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorViewController.h"

@interface GraphViewController : UIViewController

@property (nonatomic, strong) NSArray *programStack; // this pointer must be held when we jump to view

@end

//
//  RotatableNavigationControllerViewController.m
//  Calculator
//
//  Created by Chris D'Angelo on 1/1/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import "RotatableNavigationControllerViewController.h"

@interface RotatableNavigationControllerViewController ()

@end

@implementation RotatableNavigationControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// thanks to http://www.roostersoftstudios.com/2012/09/21/ios6-autorotation-changes/ for this code.  These methods are new to iOS6
- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate; //you are asking your current controller what it should do
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end

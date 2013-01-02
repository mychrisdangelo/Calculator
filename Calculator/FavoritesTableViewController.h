//
//  FavoritesTableViewController.h
//  Calculator
//
//  Created by Chris D'Angelo on 1/2/13.
//  Copyright (c) 2013 Chris D'Angelo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FavoritesTableViewController;

@protocol FavoritesTableViewControllerDelegate
@optional
- (void)favoritesTableViewController:(FavoritesTableViewController *)sender choseProgram:(id)program;

@end

@interface FavoritesTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *programs; // of CalculatorBrain
@property (nonatomic, weak) id <FavoritesTableViewControllerDelegate> delegate;

@end

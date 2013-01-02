//
//  GraphViewController.m
//  Calculator
//
//  Created by Chris D'Angelo on 12/31/12.
//  Copyright (c) 2012 Chris D'Angelo. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"


@interface GraphViewController () <GraphViewDataSource, UISplitViewControllerDelegate>
// We can hold onto this pointer strongly.  We will drop it when controller dies
@property (strong, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) UIBarButtonItem *splitViewBarButtonItem;
@end

@implementation GraphViewController

@synthesize programStack = _programStack;
@synthesize graphView = _graphView;
@synthesize toolbar = _toolbar;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

- (float)yValue:(float)xValue sender:(GraphView *)sender
{
    return [CalculatorBrain runProgram:self.programStack usingVariableValues:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:xValue], @"x", nil]];
}

- (void)setOriginAndScaleFromPresets
{
    NSDictionary *presets = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"presets"];
    self.graphView.scale = [[presets objectForKey:@"scale"] floatValue];
    self.graphView.origin = CGPointMake([[presets objectForKey:@"origin.x"] floatValue], [[presets objectForKey:@"origin.y"] floatValue]);
    NSLog(@"setting origin and scale from presets");
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tap:)];
    tapRecognizer.numberOfTapsRequired = 3;
    [self.graphView addGestureRecognizer:tapRecognizer];
    self.graphView.dataSource = self;
    [self setOriginAndScaleFromPresets];
}

// when the formula is updated refresh screen
- (void)setProgramStack:(NSArray *)programStack
{
    _programStack = programStack;
    self.title = [CalculatorBrain descriptionOfProgram:self.programStack];
    [self.graphView setNeedsDisplay];
}

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
    // required by UISplitViewControllerDelegate.  Now UISpliveViewController will look to this controller for implemented functions
    self.splitViewController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSDictionary *presets = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithFloat:self.graphView.origin.x], @"origin.x", [NSNumber numberWithFloat:self.graphView.origin.y], @"origin.y", [NSNumber numberWithFloat:self.graphView.scale], @"scale", nil];
    [[NSUserDefaults standardUserDefaults] setObject:presets forKey:@"presets"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"STORING origin and scale to presets");
}

/* 
 * handler setting/removing barButton Item
 * make copy of toolbar first
 * if the splitViewBarButtonItem is currently showing remove it from the toolbar
 * if the barButtonItem passed is in is valid that is the barItem we want to display
 * set the toolbar with that item
 * store the barButtonItem we used for reference later
 * 
 * if user passes in nil then
 * the bar button item in the toolbar will be removed and nothing will be added
 * we will store in splitViewBarButtonItem nil to show that nothing is there.
 */
- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (barButtonItem) [toolbarItems insertObject:barButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Calculator";
    [self setSplitViewBarButtonItem:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self setSplitViewBarButtonItem:nil];
}

// this delegate method exists by default. I've included for clarity
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end

//
//  EATableViewController.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "EATableViewController.h"

@implementation EATableViewController

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        [self initInstance];
    }
    
    return self;
}

/** Initialize controller instance
 *
* Manages iOS 7 layout properties, like edges for extended layout, scroll offset adjustments and extended layout
 */
-(instancetype)init
{
    if (self = [super init])
    {
        [self initInstance];
    }
    
    return self;
}

-(void)initInstance
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
}

/** Manages back button title (actually remove it) and navigation bar properties */
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Replace text on back button to empty
    /*UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:nil
                                                                  action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];*/
    
    // Set non transparent navigation bar
    [self.navigationController.navigationBar setTranslucent:NO];
}

#pragma mark - iOS SDK Overrides

/** Specify default preferred status bar style for active controller
 *
 * @warning This method called only when 'View controller-based status bar appearance' is set to YES. Default is UIStatusBarStyleDefault
 * @see UIStatusBarStyle
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

/** Specify default preferred status bar hidden state
 *
 * @warning This method called only when 'View controller-based status bar appearance' is set to YES. Default is NO
 */
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

/** Specify default preferred status bar update animation
 *
 * @warning This method called only when 'View controller-based status bar appearance' is set to YES. Default is UIStatusBarAnimationFade
 * @see UIStatusBarAnimation
 */
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

/** Specify supported autorotate options
 *
 * @warning Default set to Portrait only
 * @see UIInterfaceOrientation
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

/** Support autorotation
 *
 * @warning Default set to NO
 */
- (BOOL)shouldAutorotate
{
    return YES;
}

/** Specify supported orientations as mask
 *
 * @warning Default set to UIInterfaceOrientationMaskLandscape
 * @see UIInterfaceOrientationMask
 */
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

/** Specify preferred orientation
 *
 * @warning Default set to UIInterfaceOrientationLandscapeLeft
 * @see UIInterfaceOrientationMask
 */
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

@end

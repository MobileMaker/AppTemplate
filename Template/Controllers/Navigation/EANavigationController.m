//
//  EANavigationViewController.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "EANavigationController.h"

@implementation EANavigationController

/** As a container must return view controller for active tab to use this contoller configuration for status bar */
- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.visibleViewController;
}

/** As a container must return view controller for active tab to use this contoller configuration for status bar */
- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.visibleViewController;
}

/** Specify default preferred status bar style for active controller
 *
 * @warning This method called only when 'View controller-based status bar appearance' is set to YES
 * @warning Never called at the moment because WWTabViewController redirects childViewControllerForStatusBarStyle and childViewControllerForStatusBarHidden to visible view controller
 * @see childViewControllerForStatusBarHidden
 * @see childViewControllerForStatusBarStyle
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

/** Specify default preferred status bar hidden state
 *
 * @warning This method called only when 'View controller-based status bar appearance' is set to YES
 * @warning Never called at the moment because WWTabViewController redirects childViewControllerForStatusBarStyle and childViewControllerForStatusBarHidden to visible view controller
 * @see childViewControllerForStatusBarHidden
 * @see childViewControllerForStatusBarStyle
 */
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

/** Specify default preferred status bar update animation
 *
 * @warning This method called only when 'View controller-based status bar appearance' is set to YES
 * @warning Never called at the moment because WWTabViewController redirects childViewControllerForStatusBarStyle and childViewControllerForStatusBarHidden to visible view controller
 * @see childViewControllerForStatusBarHidden
 * @see childViewControllerForStatusBarStyle
 */
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

#pragma mark - Scroll up

/** Searches for UIScrollView over view subviews */
-(id)searchForScrollView:(UIView*)rootView
{
    if ([rootView isKindOfClass:[UIScrollView class]])
    {
        return rootView;
    }
    
    UIScrollView* firstScroolView = nil;
    
    for (id subview in [rootView subviews])
    {
        firstScroolView = [self searchForScrollView:subview];
        if (firstScroolView) break;
    }
    
    return firstScroolView;
}

#pragma mark - Actions

/** Handles tap on navigation bar to scroll up */
-(void)onNavigationBarTap
{
    UIScrollView* viewToScrollUp = [self searchForScrollView:self.view];
    
    if (viewToScrollUp)
    {
        DLog(@"Scroll to top");
        [viewToScrollUp setContentOffset:CGPointZero animated:YES];
    }
}

@end

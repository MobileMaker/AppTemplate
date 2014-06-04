//
//  EAMainViewController.h
//  Template
//
//  Created by Maker
//  (email:maker@gmail.com, maker@mail.ru; skype:maker)
//  Copyright (c) 2014. All rights reserved.
//

#import "EAMainViewController.h"
#import "Booking/EABookingMainViewController.h"
#import "Floor/EAFloorMainViewController.h"
#import "Book/EABookMainViewController.h"
#import "Contacts/EAContactsMainViewController.h"


@implementation EAMainViewController

- (id)initController
{
    if (self = [super init])
    {
        EABookingMainViewController* viewController1 = [[EABookingMainViewController alloc] initController];
        UINavigationController* navController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
        
        EAFloorMainViewController* viewController2 = [[EAFloorMainViewController alloc] initController];
        UINavigationController* navController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
        
        EABookMainViewController* viewController3 = [[EABookMainViewController alloc] initController];
        UINavigationController* navController3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
        
        EAContactsMainViewController* viewController4 = [[EAContactsMainViewController alloc] initController];
        UINavigationController* navController4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
        
        [self initNavigationController:navController1];
        [self initNavigationController:navController2];
        [self initNavigationController:navController3];
        [self initNavigationController:navController4];
        
        [self setViewControllers:@[navController1, navController2, navController3, navController4]];
        [self setSelectedIndex:0];
    }
    return self;
}

-(void)initNavigationController:(UINavigationController*)navC
{
    [navC.navigationBar setTranslucent:YES];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]])
        [(UINavigationController*)viewController popToRootViewControllerAnimated:NO];
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

@end

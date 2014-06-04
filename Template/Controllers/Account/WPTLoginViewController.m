//
//  WPTLoginViewController.m
//  Wellpepper PT
//
//  Created by Sergii Aniskin on 19.12.12.
//  Copyright 2013 Wellpepper Inc. All rights reserved.
//

#import "WPTLoginViewController.h"
#import "WPTRegistrationViewController.h"
#import "WPTDashboardViewController.h"
#import "Controllers/Views/WPTLoginView.h"
#import "Controllers/Views/WPTLoginHeaderView.h"
#import "Controllers/Views/WPTLoginFooterView.h"
#import "Controllers/Views/WPTMirrorGradientView.h"
#import "Utils/WPTUIUtils.h"
#import "Utils/WPTUtils.h"
#import "WPTAccountUtils.h"
#import "WPTEulaViewController.h"
#import "WPTDataFetcher.h"


typedef enum
{
    ViewTagResetPassword = 1000,
    ViewTagResetPasswordWrongEmail
} ViewTag;


@interface WPTLoginViewController ()<WPTLoginViewDelegate, WPTEulaViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) WPTLoginView* loginView;
@property (nonatomic, strong) WPTLoginHeaderView* headerView;
@property (nonatomic, strong) WPTLoginFooterView* footerView;
@property (nonatomic, strong) WPTMirrorGradientView* gradientView;
@property (nonatomic, strong) UIActivityIndicatorView* activityView;

@end

@implementation WPTLoginViewController

@synthesize loginView;
@synthesize headerView;
@synthesize footerView;
@synthesize gradientView;
@synthesize activityView;

- (id)initController
{
    self = [super init];
    if (self)
    {
        NSNotificationCenter* notCenter = [NSNotificationCenter defaultCenter];
        
        [notCenter addObserver:self selector:@selector(onKeyboardShown:) name:UIKeyboardWillShowNotification object:nil];
        [notCenter addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    NSNotificationCenter* notCenter = [NSNotificationCenter defaultCenter];
    
    [notCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [notCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Wellpepper Login", @"Login view navigation title");
    
    // ios7
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view setBackgroundColor:[WPTUIUtils backgroundColor]];
    [self.view setOpaque:YES];
    
    self.headerView = [[WPTLoginHeaderView alloc] initWithFrame:CGRectNull];
    [self.headerView setHeaderTitle:NSLocalizedString(@"Welcome to Wellpepper", @"Login header title")];
    [self.view addSubview:self.headerView];
    
    self.footerView = [[WPTLoginFooterView alloc] initWithFrame:CGRectNull];
    [self.footerView setFooterTitle:NSLocalizedString(@"Don’t have an account?", @"Login footer view title")];
    [self.footerView.btn setTitle:NSLocalizedString(@"Create One Now!", @"Login footer view button title") forState:UIControlStateNormal];
    [self.footerView.btn addTarget:self action:@selector(onCreateAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.footerView];
    
    self.gradientView = [[WPTMirrorGradientView alloc] initWithTopBottomColor:nil middleColor:nil];
    [self.view addSubview:self.gradientView];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityView setHidesWhenStopped:YES];
    [self.view addSubview:self.activityView];
    
    // Get last logged in user
    NSString* lastLoggedInUsername = [WPTUtils lastLoggedInUserName];
    NSString* lastLoggedInUserPassword = [WPTUtils lastLoggedInUserPassword];
    
    self.loginView = [[WPTLoginView alloc] initViewWithEmail:lastLoggedInUsername andPasssword:lastLoggedInUserPassword];
    [self.loginView setBackgroundColor:[UIColor clearColor]];
    [self.loginView setDelegate:self];
    [self.view addSubview:self.loginView];
    
    self.navigationItem.titleView = [WPTUIUtils navigationTitleViewWithTitle:self.title];
    self.navigationItem.backBarButtonItem = [WPTUIUtils barButtonWithTitle:self.title
                                                                   target:nil
                                                                   action:nil];
}

-(void)viewWillLayoutSubviews
{
    CGRect paper = self.view.bounds;

    [super viewWillLayoutSubviews];
    
    [self.headerView setFrame:CGRectMake(0.0, 0.0, paper.size.width, 80.0)];
    [self.loginView setCenter:CGPointMake(paper.size.width/2.0, paper.size.height/2.0)];
    [self.activityView setCenter:CGPointMake(paper.size.width/2.0,
                                             (self.loginView.frame.origin.y + self.headerView.frame.origin.y + self.headerView.bounds.size.height)/2.0)];
    [self.footerView setFrame:CGRectMake(0.0, paper.size.height - 80.0, paper.size.width, 80.0)];
    [self.gradientView setFrame:CGRectMake(0.0, self.headerView.bounds.size.height,
                                           paper.size.width,
                                           paper.size.height - self.headerView.bounds.size.height - self.footerView.bounds.size.height)];
}

#pragma mark - Rotation logic

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - Actions

-(void)onCreateAccount
{
    WPTRegistrationViewController* vc = [[WPTRegistrationViewController alloc] initController];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goToDashboard
{
    WPTDashboardViewController* startPage = [[WPTDashboardViewController alloc] initController];
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:startPage];
    
    [UIApplication sharedApplication].delegate.window.rootViewController = navController;
}

#pragma mark - WPTLoginViewDelegate

-(void)loginWithEmail:(NSString*)email andPassword:(NSString*)password
{
    email = [email lowercaseString]; // NUD-303: NUD-182 port
    
    [self.activityView startAnimating];
    [self.view setUserInteractionEnabled:NO];
    
    [PFUser logInWithUsernameInBackground:email password:password
                                    block:^(PFUser *user, NSError *error)
    {
        [self.activityView stopAnimating];
        [self.view setUserInteractionEnabled:YES];
        
        if (user)
        {
            
            [WPTAccountUtils checkForAppUpdate];
            
            if ([WPTAccountUtils isAllowedToViewDashboard])
            {
                DLog(@"User logged in");

                if ([user objectForKey:kObjUserPropAutoLogoff] == nil || ![[user objectForKey:kObjUserPropAutoLogoff] boolValue])
                {
                    [WPTUtils updateLastLoggedInUserName:email withPassword:password];
                }
                else
                {
                    [WPTUtils clearPasswordForUserName:email];
                }
                
                [WPTAccountUtils setUrlCredentialsForCurrentUser];
                
                // Update settings with user information
                NSTimeZone* currentTimeZone = [NSTimeZone localTimeZone];
                [[WPTSettings sharedSettings] setCurrentTimeZoneOffset:[currentTimeZone secondsFromGMT]];
                
                
                if ([WPTAccountUtils needsToSignEula])
                {
                    WPTEulaViewController *eulaVC = [[WPTEulaViewController alloc] init];
                    [eulaVC setDelegate:self];
                    [self.navigationController pushViewController:eulaVC animated:YES];
                }
                else
                {
                    [self goToDashboard];
                }
                
            }
            else
            {
                DLog(@"Login succeeded, but user type not permitted.");
                NSString *errMessage = [WPTAccountUtils noDashboardReason];
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Wrong User Account Type", @"login wrong user type alert title")
                                                                message:errMessage
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        else
        {
            DLog(@"Failed to login: %@", error);
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Wellpepper Login", @"Login alert view title")
                                                            message:NSLocalizedString(@"Login failed! Check your username and password", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}


-(void)recoverUserCredentials
{
    // get current entered email if any
    NSString* email = [self.loginView enteredEmail];
    
    // Show alert view to user befire password reset
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Password Reset", @"Alert view title")
                                                    message:NSLocalizedString(@"Enter your email address:", @"Reset password alert view message")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Button title")
                                          otherButtonTitles:NSLocalizedString(@"Reset", @"Button title"), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = ViewTagResetPassword;
    // Set entered user email
    [[alert textFieldAtIndex:0] setText:email];
    [alert show];
}

#pragma mark - WPTEulaViewControllerDelegate

-(void)eulaViewControllerAgreedToEula:(WPTEulaViewController *)eulaViewController
{
    [self goToDashboard];
}


#pragma mark - Notifications

-(void)onKeyboardShown:(NSNotification*)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        CGRect paper = self.view.bounds;
        
        [UIView animateWithDuration:0.3 animations:^(){
            [self.loginView setCenter:CGPointMake(paper.size.width/2.0,
                                                  65.0 + self.headerView.frame.origin.y + self.headerView.bounds.size.height + self.loginView.bounds.size.height / 2.0)];
        }
                         completion:^(BOOL finished){
             
        }];
    }
}

-(void)onKeyboardHide:(NSNotification*)notification
{
    CGRect paper = self.view.bounds;
    
    [UIView animateWithDuration:0.3 animations:^(){
        [self.loginView setCenter:CGPointMake(paper.size.width/2.0,
                                              paper.size.height/2.0)];
    }
                     completion:^(BOOL finished){
                         
    }];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(alertView.tag)
    {
        case ViewTagResetPasswordWrongEmail:
            [self recoverUserCredentials];
            break;
            
        case ViewTagResetPassword:
        {
            // Do it only for 'Reset' button
            if (buttonIndex == 1)
            {
                NSString* userName = [[alertView textFieldAtIndex:0].text lowercaseString];
                
                if (userName == nil || userName.length == 0)
                {
                    DLog(@"Empty user name to reset password");
                    
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Password Reset", @"Alert view title")
                                                                    message:NSLocalizedString(@"Empty user name", nil)
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                          otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
                if (![WPTUtils validateEmail:userName])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Password Reset", @"Alert view title")
                                                                        message:NSLocalizedString(@"Invalid email", nil)
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                              otherButtonTitles:nil];
                        [alert setTag:ViewTagResetPasswordWrongEmail];
                        [alert show];
                    });
                    
                    return;
                }
                
                [PFUser requestPasswordResetForEmailInBackground:userName block:^(BOOL succeeded, NSError *error)
                {
                    if (!error)
                    {
                        MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
                        [self.navigationController.view addSubview:HUD];
                        
                        HUD.customView = nil;
                        HUD.mode = MBProgressHUDModeText;
                        HUD.opacity = 0.7f;
                        HUD.removeFromSuperViewOnHide = YES;
                        HUD.progress = 0.0;
                        HUD.dimBackground = YES;
                        HUD.labelText = NSLocalizedString(@"Please check your email for instructions on how to reset your password.", nil);
                        
                        [HUD show:YES];
                        
                        // Show for enough time, anyway user don't know the password and have to check email
                        [HUD hide:YES afterDelay:10.0];
                    }
                    else
                    {
                        DLog(@"Failed to reset password: %@", error);
                        
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Password Reset", @"Alert view title")
                                                                        message:NSLocalizedString(@"Failed to reset your password. Try again later", nil)
                                                                       delegate:nil
                                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                }];
            }
        }
        break;
    }
}

@end

//
//  EALoginViewController.h
//  Template
//
//  Created by Maker
//  (email:maker@gmail.com, maker@mail.ru; skype:maker)
//  Copyright (c) 2014. All rights reserved.
//

#import "EALoginViewController.h"
#import "EAAppDelegate.h"
#import "Controllers/EAMainViewController.h"
#import "EALoginView.h"


@interface EALoginViewController()

@property (nonatomic, strong) EALoginView* loginView;
@property (nonatomic, strong) UIActivityIndicatorView* activityView;

@end

@implementation EALoginViewController

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
    
    self.title = NSLocalizedString(@"Template Login", @"Login view navigation title");
    
    [self.view setBackgroundColor:[UIColor colorWithRed:126.0/255.0
                                                  green:195.0/255.0
                                                   blue:77.0/255.0
                                                  alpha:1.0]];
    [self.view setOpaque:YES];
    
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityView setHidesWhenStopped:YES];
    [self.view addSubview:self.activityView];
    
    // Get last logged in user

    self.loginView = [[EALoginView alloc] initWithEmail:[Template shared].loggedInUserName
                                               password:nil
                                             completion:^(NSString *email, NSString *password)
    {
        // Store user email
        [[Template shared] setLoggedInUserName:email];
        
        EAMainViewController* mainVC = [[EAMainViewController alloc] initController];
        EAAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
            UIGraphicsBeginImageContextWithOptions(appDelegate.window.bounds.size, NO, [UIScreen mainScreen].scale);
        else
            UIGraphicsBeginImageContext(appDelegate.window.bounds.size);
        
        // Draw current window to screen
        [appDelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage* screeshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Add screenshot to main window as subview to simulate smooth transition between root view controllers
        __block UIImageView* imgView = [[UIImageView alloc] initWithFrame:appDelegate.window.bounds];
        [imgView setImage:screeshot];
        [appDelegate.window addSubview:imgView];
        
        [mainVC.view setAlpha:0.0];
        [imgView setAlpha:1.0];
        
        // Add screenshot to the top and animate it
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        
        // Additional step that is needed to replace root controller is to recreate window
        // otherwise new controller will not receive initial layouting events
        appDelegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        appDelegate.window.backgroundColor = [UIColor whiteColor];
        [appDelegate.window setRootViewController:mainVC];
        [appDelegate.window addSubview:imgView];
        [appDelegate.window makeKeyAndVisible];
        [UIView setAnimationsEnabled:oldState];
        
        [UIView animateWithDuration:1.0
                         animations:^
         {
             [mainVC.view setAlpha:1.0];
             [imgView setAlpha:0.0];
         }
                         completion:^(BOOL finished)
         {
             REMOVE_AND_NULLIFY_VIEW(imgView);
             
             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
         }];
    }];
    [self.loginView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.loginView];
}

-(void)viewWillLayoutSubviews
{
    CGRect paper = self.view.bounds;
    
    [super viewWillLayoutSubviews];
    
    static BOOL layouted = NO;
    
    if (!layouted)
    {
        [self.loginView setCenter:CGPointMake(paper.size.width/2.0, paper.size.height/2.0)];
        layouted = YES;
    }
    [self.activityView setCenter:CGPointMake(paper.size.width/2.0, self.loginView.frame.origin.y/2.0)];
}

#pragma mark - Notifications

-(void)onKeyboardShown:(NSNotification*)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        CGRect paper = self.view.bounds;
        CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        [UIView animateWithDuration:0.3 animations:^()
        {
            [self.loginView setCenter:CGPointMake(paper.size.width/2.0,
                                                  (paper.size.height - MIN(keyboardSize.height, keyboardSize.width))/2.0)];
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

@end

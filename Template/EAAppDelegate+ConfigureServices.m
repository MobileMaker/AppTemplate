//
//  EAAppDelegate+ConfigureServices.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "EAAppDelegate.h"
#import <RestKit/RestKit.h>
#import "Protocols/EAProtocolConstants.h"
#import "Model/EAMappingsManager.h"
#import "Analytics/EAFlurryAnalytics.h"
#import "Analytics/EAGoogleAnalytics.h"
#import "Logging/EACrashlyticsLogger.h"
#import "Logging/EADefaultLogger.h"
#import "Logging/EATestFlightLogger.h"


@implementation EAAppDelegate(ConfigureServices)

-(void)initApplication
{
    [self configureApplicationAppearence];
    [self configureRestKit];
    [self configureHTTPSessionAndWebKit];
    [self configureCrashlytics];
    [self configureAnalytics];
    [self configureLoggers];
    
    // Instantiate all managers
    [EAResourceManager shared];
    [EAFontManager shared];
    [EAMappingsManager shared];
    [Template shared];

    // Reset badge for application, it will be updated with first request
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

-(void)shutdownApplication
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground
    [[EAResourceManager shared] cleanup];
    [[EAFontManager shared] cleanup];
    [[EAMappingsManager shared] cleanup];
    [[Template shared] cleanup];
}

/** Configure UIAppearence for whole application */
-(void)configureApplicationAppearence
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithWhite:1.0 alpha:0.2]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:105.0/255.0 alpha:1.0]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    // Set transparent status bar with black text for all application
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

/** Configures Analytics */
-(void)configureAnalytics
{
    [[EAAnalytics shared] addTracker:[EAFlurryAnalytics new]];
    [[EAAnalytics shared] addTracker:[EAGoogleAnalytics new]];
}

/** Configures Loggers */
-(void)configureLoggers
{
    [[EALogs shared] addLogger:[EACrashlyticsLogger new]];
    [[EALogs shared] addLogger:[EADefaultLogger new]];
    [[EALogs shared] addLogger:[EATestFlightLogger new]];
}

-(void)configureCrashlytics
{
    NSString* apiKey = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CRASHLYTICS_API_KEY"];
    NSAssert(apiKey, @"CRASHLYTICS_API_KEY not defined. Define CRASHLYTICS_API_KEY as project user settings");
    [Crashlytics startWithAPIKey:apiKey];
}

/*
 * RestKit Network service/protocols
 */
-(void)configureRestKit
{
#warning RestKit could print user sensitive data so minimize debug information for distribution
#ifdef APPSTORE
    // Configure logging severity level
    RKLogConfigureByName("RestKit/Network", RKLogLevelWarning);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelError);
#else
    // Configure logging severity level
    RKLogConfigureByName("RestKit/Network", RKLogLevelWarning);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelWarning);
#endif
}

/** Configures HTTP protocol and WebKit parameters */
-(void)configureHTTPSessionAndWebKit
{
    // Configure cookies policy to accept any cookie
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    // Disable WebKit disk image cache for application
    //[userDefs setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];

    // Remove and disable all URL Cache, but doesn't seem to affect the memory
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

/** Removes cookies for active server */
-(void)resetHTTPSessionAndWebKit
{
    DLog(@"Reset HTTP session");
    
    // Remove and disable all URL Cache, but doesn't seem to affect the memory
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:kServerAPI]];
    for (NSHTTPCookie *cookie in cookies)
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

@end

//
//  EAAppDelegate.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "EAAppDelegate.h"
#import "Model/EAMappingsManager.h"
#import "Controllers/Account/EALoginViewController.h"
#import "Utils/EAUIUtils.h"


@interface EAAppDelegate()

@end


@implementation EAAppDelegate

@synthesize window;

#pragma mark - Application flow

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    [self applyLaunchOptions:launchOptions];
    
    // Configuration for whole application from born to die. Configure external frameworks and services (Google Analytics is set up AFTER country has been selected)
    [self initApplication];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Dump application fonts
    {
        NSArray* applicationFontNames = @[@"Helvetica Neue LT Std",
                                          @"Avenir LT 55 Roman",
                                          @"Avenir LT 65 Medium",
                                          @"Avenir LT 45 Book"];
        
        DLog(@"------------------------ Application Fonts ------------------------");
        
        // Print available fonts from family
        for (NSString* fontFamily in applicationFontNames)
        {
            DLog(@"Font family: %@", fontFamily);
            NSArray* fonts = [UIFont fontNamesForFamilyName:fontFamily];
            DLog(@"%@: %@", fontFamily, fonts);
        }
        
        DLog(@"------------------------------------------------------------------");
    }
    
    [self subscribeOnNotifications];
    
    EALoginViewController* authVC = [[EALoginViewController alloc] initController];
    [self.window setRootViewController:authVC];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)subscribeOnNotifications
{

}

-(void)unsubscribeFromNotifications
{

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions
    // (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[Template shared] flush];
    
    // applicationWillResignActive: does not always mean that you are going to the background. You will for example also receive that delegate call and
    // notification (you get both) when the user gets a phone call or receives and SMS. So you have to decide what should happen if the user gets an SMS
    // and presses cancel to stay in your app.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Save changes in case user changed settins in settings bundle otherwise they are not applied
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Refresh application settings in case it's changed from Settings app
    [[Template shared] update];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self unsubscribeFromNotifications];
    
    [self shutdownApplication];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    DLog(@"Deep linking with %@ via %@", [url absoluteString], sourceApplication);
    
    if (url)
    {
        // Handle deep linking scheme
        if ([[url scheme] isEqualToString:kApplicationScheme])
        {
            NSString* strURL = [url absoluteString];
            
            // Skip deep linking parsing if already set with launch options and equal
            EADeepLinking* deepLinking = [Template shared].applicationDeepLinking;
            if (deepLinking && [deepLinking.URL isEqualToString:strURL])
                return YES;
            
            // Store deep linking options to use later. The reason - application main interface may not be instantiated at this time, for example, welcome tour is shown
            // so to react have to store information and process when ready
            deepLinking = [[EADeepLinking new] initWithURL:strURL sourceApplication:sourceApplication asLaunchRequest:NO];
            [[Template shared] setApplicationDeepLinking:deepLinking];
            
            // Do deep linking
            
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Helpers

-(void)applyLaunchOptions:(NSDictionary*)launchOptions
{
    DLog(@"Launch option: %@", launchOptions);
    
    [[Template shared] setApplicationLaunchOptions:launchOptions];
    
    // Parse application launch options for deeep linking information. Actually deep linking params will be passed
    if (launchOptions)
    {
        NSURL* url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
        NSString* sourceApplication = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
        
        if (url)
        {
            DLog(@"Deep linking %@ via %@", [url absoluteString], sourceApplication);
            
            // Handle deep linking scheme
            if ([[url scheme] isEqualToString:kApplicationScheme])
            {
                // Store deep linking options to use later. The reason - application main interface may not be instantiated at this time, for example, welcome tour is shown
                // so to react have to store information and process when ready
                EADeepLinking* deepLinking = [[EADeepLinking new] initWithURL:[url absoluteString] sourceApplication:sourceApplication asLaunchRequest:YES];
                [[Template shared] setApplicationDeepLinking:deepLinking];
            }
        }
    }
}

#pragma mark - Check for newer app version

-(void)checkForNewerAppVersion
{
    // Request app store information for app
    NSString *strAppUrl = [NSString stringWithFormat: @"http://itunes.apple.com/lookup?id=%@", kAppleID];
    
    NSURL *url = [NSURL URLWithString:strAppUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
         if ([data length] > 0 && error == nil)
         {
             NSError *jsonError = nil;
             NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &jsonError];
             // Get the version numbers
             NSString *appStoreVersion = [[[jsonDict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"version"];
             NSString *versionString = [Template shared].applicationVersion;
             
             NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
             [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
             [numberFormatter setDecimalSeparator:@"."];
             NSNumber *appStoreVersionNumber = [numberFormatter numberFromString:appStoreVersion];
             NSNumber *currentVersionNumber = [numberFormatter numberFromString:versionString];
             
             // Check if there is a version with a higher version number
             if ([appStoreVersionNumber compare:currentVersionNumber] == NSOrderedDescending)
             {
                 
             }
         }
         else if ([data length] == 0 && error == nil)
         {
             DLog(@"No data received with App Store request.");
         }
         else if (error)
         {
             DLog(@"%@", error.description);
         }
    }];
}


@end

//
//  Template.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "Template.h"
#import "Protocols/EAProtocolConstants.h"
#import <UIDeviceAddition/UIDevice+IdentifierAddition.h>
#import <Reachability/Reachability.h>

@interface Template()

@property (nonatomic, strong) Reachability* reach;

@property (nonatomic, assign, readwrite) BOOL firstStart;
@property (nonatomic, strong, readwrite) NSDate* firstStartDate;
@property (nonatomic, assign, readwrite) BOOL isOnline;
@property (nonatomic, copy, readwrite) NSString* deviceUID;
@property (nonatomic, copy, readwrite) NSString* applicationVersion;
@property (nonatomic, strong, readwrite) NSNumber* applicationBuild;
@property (nonatomic, assign, readwrite) BOOL isApplicationUpdated;
@property (nonatomic, strong, readwrite) NSNumber* syncTime;

@end


@implementation Template

+(Template*)shared
{
    static dispatch_once_t pred;
    static Template* sharedInstance = nil;
    
    // Instantiate singleton on first request
    dispatch_once(&pred, ^{
        sharedInstance = [[Template alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype)init
{
    if (self = [super init])
    {
        [self load];
        
        self.deviceUID = [[UIDevice currentDevice] uniqueDeviceIdentifier];
        
        // Start Internet reachability notifier
        self.reach = [Reachability reachabilityForInternetConnection];
        [self.reach startNotifier];
        
        self.isOnline = self.reach.isReachable;
        
        [self subscribeOnNotifications];
    }
    
    return self;
}

-(void)dealloc
{
    NSAssert(NO, @"This function must not be called");
}

-(void)subscribeOnNotifications
{
    NSNotificationCenter* notC = [NSNotificationCenter defaultCenter];
    [notC addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [notC addObserver:self selector:@selector(handleMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

-(void)unsubscribeFromNotifications
{
    NSNotificationCenter* notC = [NSNotificationCenter defaultCenter];
    [notC removeObserver:self name:kReachabilityChangedNotification object:nil];
    [notC removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

/** Loads data from user defaults */
-(void)load
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Load settings from defaults
    self.firstStartDate = (NSDate*)[userDefaults objectForKey:kPropInitDate];
    BOOL firstStart = (self.firstStartDate == nil);
    
    // App first run: set up user defaults
    if (firstStart)
    {
        self.firstStartDate = [NSDate date];
        
        NSDictionary* appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:
                                      kPropAppServer, kServerAPI,
                                      kPropSyncTime, [NSNumber numberWithUnsignedInteger:kServerSyncTime],
                                      nil];
        
        // Registered defaults are not written to disk and have to be set each application start
        [userDefaults registerDefaults:appDefaults];
        // Mark settings initialization date
        [userDefaults setObject:self.firstStartDate forKey:kPropInitDate];
    }
    
    NSString* previousVersion = [userDefaults objectForKey:kPropAppVersion];
    self.applicationVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.applicationBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    // Have to save to properties because Settings app uses it
    [userDefaults setObject:self.applicationVersion forKey:kPropAppVersion];
    [userDefaults setObject:self.applicationBuild forKey:kPropAppBuild];
    
    self.isApplicationUpdated = ((previousVersion == nil) || ![previousVersion isEqualToString:self.applicationVersion]);
    
    self.syncTime = (NSNumber*)[userDefaults objectForKey:kPropSyncTime];
    self.loggedInUserName = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:kPropUserName];
    
    // Sync the defaults to disk
    [userDefaults synchronize];
}

-(void)update
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.syncTime = (NSNumber*)[userDefaults objectForKey:kPropSyncTime];
}

-(void)flush
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Prepare server name for application settings
    NSString* serverURL = kServerAPI;
    serverURL = [serverURL stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    serverURL = [serverURL stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    [userDefaults setObject:serverURL forKey:kPropAppServer];
    
    [userDefaults setObject:(self.loggedInUserName ? self.loggedInUserName : nil) forKey:kPropUserName];
    
    // Sync the defaults to disk
    [userDefaults synchronize];
}

-(void)cleanup
{
    [self unsubscribeFromNotifications];
    
    [self flush];
    
    [self.reach stopNotifier];
    self.reach = nil;
}

#pragma mark - Notififcations

-(void)handleMemoryWarning:(NSNotification *)notification
{
    
}

/** Notification handler on changing network status */
-(void)reachabilityChanged:(NSNotification*)notification
{
    DLog(@"Internet status changed to %d (via %d)", self.reach.isReachable, [self.reach currentReachabilityStatus]);
    self.isOnline = self.reach.isReachable;
}

@end

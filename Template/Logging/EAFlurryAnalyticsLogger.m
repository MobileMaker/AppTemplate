//
//  EAFlurryAnalyticsLogger.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EAFlurryAnalyticsLogger.h"
#import <FlurrySDK/Flurry.h>

NSString* const kFlurryKey      = @"2ZBMBBS36JZSVJTJVXR4";


@implementation EAFlurryAnalyticsLogger

+(instancetype)shared
{
    static dispatch_once_t pred;
    static EAFlurryAnalyticsLogger* sharedInstance = nil;
    
    // Instantiate singleton on first request
    dispatch_once(&pred, ^
    {
        NSLog(@"Initialize '%@' logger", kTestFlightLoggerName);
        sharedInstance = [EAFlurryAnalyticsLogger alloc];
    });
    
    return sharedInstance;
}

+(instancetype)startWithParameters:(NSDictionary*)params
{
    static dispatch_once_t pred;
    
    EAFlurryAnalyticsLogger* logger = [EAFlurryAnalyticsLogger shared];
    
    dispatch_once(&pred, ^
    {
        // Note: iOS only allows one crash reporting tool per app; if using another, set to: NO
        [Flurry setCrashReportingEnabled:NO];

        // Default is NO, crashreporting must be enabled for Flurry in order to make this feature work
        [Flurry setShowErrorInLogEnabled:NO];
    
#ifdef DEBUG
        // Automatically sets debug log level to FlurryLogLevelDebug
        [Flurry setDebugLogEnabled:YES];
        [Flurry setLogLevel:FlurryLogLevelAll];
#else
        // Automatically sets debug log level to FlurryLogLevelCriticalOnly
        [Flurry setDebugLogEnabled:NO];
        [Flurry setLogLevel:FlurryLogLevelCriticalOnly];
#endif
                      
        [Flurry setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];

        if (params)
        {
            [logger addLoggerParameters:params];
        }

        [Flurry startSession:kFlurryKey];
    });
    
    return logger;
}

-(NSString*)name
{
    return kFlurryAnalyticsLoggerName;
}

-(EALogCapabilities)capabilities
{
    return EALogCapabilityCanReportCrashes;
}

#pragma mark - Event Tracking

-(void)addLoggerParameters:(NSDictionary*)params
{
    NSString* userId = (NSString*)[params objectForKey:kPropLoggerUserId];
    if (userId && [userId isKindOfClass:[NSString class]])
        [Flurry setUserID:userId];
    
    NSNumber* age = (NSNumber*)[params objectForKey:kPropLoggerAge];
    if (age && [age isKindOfClass:[NSNumber class]])
        [Flurry setAge:age.intValue];
    
    NSString* gender = (NSString*)[params objectForKey:kPropLoggerGender];
    if (gender && [gender isKindOfClass:[NSString class]])
        [Flurry setGender:gender];
    
    NSNumber* latitude = (NSNumber*)[params objectForKey:kPropLoggerLatitude];
    NSNumber* longitude = (NSNumber*)[params objectForKey:kPropLoggerLongitude];
    NSNumber* horizontalAccuracy = (NSNumber*)[params objectForKey:kPropLoggerHorizontalAccuracy];
    NSNumber* verticalAccuracy = (NSNumber*)[params objectForKey:kPropLoggerVerticalAccuracy];
    if (latitude && [latitude isKindOfClass:[NSNumber class]] &&
        longitude && [longitude isKindOfClass:[NSNumber class]] &&
        horizontalAccuracy && [horizontalAccuracy isKindOfClass:[NSNumber class]] &&
        verticalAccuracy && [verticalAccuracy isKindOfClass:[NSNumber class]])
    {
        [Flurry setLatitude:latitude.doubleValue longitude:longitude.doubleValue horizontalAccuracy:horizontalAccuracy.floatValue verticalAccuracy:verticalAccuracy.floatValue];
    }
}

-(void)removeLoggerParameters:(NSArray *)params
{
    for (NSString* param in params)
    {
        if ([param isEqualToString:kPropLoggerUserId])
            [Flurry setUserID:nil];
        else if ([param isEqualToString:kPropLoggerGender])
            [Flurry setGender:nil];
        else if ([param isEqualToString:kPropLoggerLatitude] || [param isEqualToString:kPropLoggerLongitude])
            [Flurry setLatitude:0.0 longitude:0.0 horizontalAccuracy:0.0 verticalAccuracy:0.0];
    }
}

-(void)resetLoggerParameters
{
    [Flurry setUserID:nil];
    [Flurry setGender:nil];
    [Flurry setLatitude:0.0 longitude:0.0 horizontalAccuracy:0.0 verticalAccuracy:0.0];
}

-(void)logEvent:(NSString*)event category:(NSString*)category withParameters:(NSDictionary*)params
{
    if (params)
        [Flurry logEvent:event withParameters:params];
    else
        [Flurry logEvent:event];
}

-(void)logError:(NSError*)error message:(NSString*)message withParameters:(NSDictionary*)params
{
    [Flurry logError:[NSString stringWithFormat:@"%@:%d", error.domain, error.code] message:message error:error];
}

-(void)logException:(NSException*)exception message:(NSString*)message withParameters:(NSDictionary*)params
{
    [Flurry logError:exception.name message:message exception:exception];
}

-(void)logTimedEvent:(NSString*)event category:(NSString*)category withParameters:(NSDictionary*)params timed:(BOOL)timed
{
    [Flurry logEvent:event withParameters:params timed:timed];
}

-(void)endTimedEvent:(NSString*)event withParameters:(NSDictionary*)params
{
    [Flurry endTimedEvent:event withParameters:params];
}

@end

//
//  EAFlurryAnalytics.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EAFlurryAnalytics.h"
#import <FlurrySDK/Flurry.h>

NSString* const kFlurryKey      = @"2ZBMBBS36JZSVJTJVXR4";


@implementation EAFlurryAnalytics

-(instancetype)init
{
    return [self initWithParameters:nil];
}

-(instancetype)initWithParameters:(NSDictionary*)params
{
    if (self = [super init])
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
            [self bindParametersToTracker:params];
        }
        
        [Flurry startSession:kFlurryKey];
    }
    
    return self;
}

-(NSString*)trackerName
{
    return kFlurryAnalyticsTrackerName;
}

#pragma mark - Event Tracking

-(void)bindParametersToTracker:(NSDictionary*)params
{
    NSAssert(params, @"Nil tracker bind params");
    
    NSString* userId = (NSString*)[params objectForKey:kPropTrackerUserId];
    if (userId && [userId isKindOfClass:[NSString class]])
        [Flurry setUserID:userId];
    
    NSNumber* age = (NSNumber*)[params objectForKey:kPropTrackerAge];
    if (age && [age isKindOfClass:[NSNumber class]])
        [Flurry setAge:age.intValue];
    
    NSString* gender = (NSString*)[params objectForKey:kPropTrackerGender];
    if (gender && [gender isKindOfClass:[NSString class]])
        [Flurry setGender:gender];
    
    NSNumber* latitude = (NSNumber*)[params objectForKey:kPropTrackerLatitude];
    NSNumber* longitude = (NSNumber*)[params objectForKey:kPropTrackerLongitude];
    NSNumber* horizontalAccuracy = (NSNumber*)[params objectForKey:kPropTrackerHorizontalAccuracy];
    NSNumber* verticalAccuracy = (NSNumber*)[params objectForKey:kPropTrackerVerticalAccuracy];
    if (latitude && [latitude isKindOfClass:[NSNumber class]] &&
        longitude && [longitude isKindOfClass:[NSNumber class]] &&
        horizontalAccuracy && [horizontalAccuracy isKindOfClass:[NSNumber class]] &&
        verticalAccuracy && [verticalAccuracy isKindOfClass:[NSNumber class]])
    {
        [Flurry setLatitude:latitude.doubleValue longitude:longitude.doubleValue horizontalAccuracy:horizontalAccuracy.floatValue verticalAccuracy:verticalAccuracy.floatValue];
    }
}

-(void)logEvent:(NSString*)event category:(NSString*)category withParameters:(NSDictionary*)params
{
    NSAssert(event, @"Nil event name");
    
    if (params)
        [Flurry logEvent:event withParameters:params];
    else
        [Flurry logEvent:event];
}

-(void)logError:(NSString*)errorDescr message:(NSString*)message exception:(NSException*)exception withParameters:(NSDictionary*)params
{
    NSAssert(exception, @"Nil exception");
    NSAssert(errorDescr, @"Nil error description");
    
    [Flurry logError:errorDescr message:message exception:exception];
}

-(void)logError:(NSString*)errorDescr message:(NSString*)message error:(NSError*)error withParameters:(NSDictionary*)params
{
    NSAssert(error, @"Nil error");
    NSAssert(errorDescr, @"Nil error description");
    
    [Flurry logError:errorDescr message:message error:error];
}

-(void)logTimedEvent:(NSString*)event category:(NSString*)category withParameters:(NSDictionary*)params timed:(BOOL)timed
{
    NSAssert(event, @"Nil event name");
    
    [Flurry logEvent:event withParameters:params timed:timed];
}

-(void)endTimedEvent:(NSString*)event withParameters:(NSDictionary*)params
{
    NSAssert(event, @"Nil event name");
    
    [Flurry endTimedEvent:event withParameters:params];
}

@end

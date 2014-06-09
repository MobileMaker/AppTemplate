//
//  EAGoogleAnalyticsLogger.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EAGoogleAnalyticsLogger.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

NSString* const kGoogleAnalyticsTrackerId      = @"2ZBMBBS36JZSVJTJVXR4";


@interface EAGoogleAnalyticsLogger()

@property (nonatomic, copy) NSString* gaScreenName;

@end

@implementation EAGoogleAnalyticsLogger

+(instancetype)shared
{
    static dispatch_once_t pred;
    static EAGoogleAnalyticsLogger* sharedInstance = nil;
    
    // Instantiate singleton on first request
    dispatch_once(&pred, ^
    {
        NSLog(@"Initialize '%@' logger", kGoogleAnalyticsLoggerName);
        sharedInstance = [EAGoogleAnalyticsLogger alloc];
    });
    
    return sharedInstance;
}

+(instancetype)startWithLogLevel:(EALogLevel)logLevel parameters:(NSDictionary*)params
{
    static dispatch_once_t pred;
    
    EAGoogleAnalyticsLogger* logger = [EAGoogleAnalyticsLogger shared];
    
    dispatch_once(&pred, ^
    {
        // Note: iOS only allows one crash reporting tool per app; if using another, set to: NO
        [GAI sharedInstance].trackUncaughtExceptions = NO;
        // Optional: Set Google Analytics dispatch interval to e.g. 20 seconds.
        [GAI sharedInstance].dispatchInterval = 40;
        
        // Automatically sets as defualt tracker
        [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsTrackerId];
        
        [logger setLogLevel:logLevel];
        
        if (params)
        {
            [logger addLoggerParameters:params];
        }
        
        // Send a single hit with session control to start the new session.
        [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                                                           action:@"appstart"
                                                                                            label:nil
                                                                                            value:nil] set:@"start" forKey:kGAISessionControl] build]];
    });
    
    return logger;
}

-(NSString*)name
{
    return kGoogleAnalyticsLoggerName;
}

-(EALogCapabilities)capabilities
{
    return EALogCapabilityCanReportCrashes;
}

-(void)setLogLevel:(EALogLevel)logLevel
{
    [super setLogLevel:logLevel];
    
    GAILogLevel gaiLogLevel = kGAILogLevelNone;
    switch (logLevel)
    {
        case EALogLevelTrace:
            gaiLogLevel = kGAILogLevelVerbose;
            break;
            
        case EALogLevelDebug:
        case EALogLevelInfo:
            gaiLogLevel = kGAILogLevelInfo;
            break;
            
        case EALogLevelWarning:
            gaiLogLevel = kGAILogLevelWarning;
            break;
            
        case EALogLevelError:
        case EALogLevelCritical:
            gaiLogLevel = kGAILogLevelError;
            break;
            
        default:
            break;
    }
    
    [[GAI sharedInstance].logger setLogLevel:gaiLogLevel];
}

#pragma mark - Event Tracking

-(void)setScreenName:(NSString*)screenName
{
    self.gaScreenName = screenName;
    
    if (self.gaScreenName)
    {
        [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createAppView] set:screenName forKey:kGAIScreenName] build]];
    }
    
    // If you want to set screen name for all events
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:screenName];
}

-(void)addLoggerParameters:(NSDictionary*)params
{
    NSString* userId = (NSString*)[params objectForKey:kPropLoggerUserId];
    if (userId && [userId isKindOfClass:[NSString class]])
        [[[GAI sharedInstance] defaultTracker] set:@"&uid" value:userId];
}

-(void)removeLoggerParameters:(NSArray *)params
{
    for (NSString* param in params)
    {
        if ([param isEqualToString:kPropLoggerUserId])
            [[[GAI sharedInstance] defaultTracker] set:@"&uid" value:nil];
    }
}

-(void)resetLoggerParameters
{
    [[[GAI sharedInstance] defaultTracker] set:@"&uid" value:nil];
}

#pragma mark - Message logger

-(void)log:(NSString*)message logLevel:(EALogLevel)logLevel
{
    switch (logLevel)
    {
        case EALogLevelTrace:
            [[GAI sharedInstance].logger verbose:message];
            break;
            
        case EALogLevelDebug:
        case EALogLevelInfo:
            [[GAI sharedInstance].logger info:message];
            break;
            
        case EALogLevelWarning:
            [[GAI sharedInstance].logger warning:message];
            break;
            
        case EALogLevelError:
        case EALogLevelCritical:
            [[GAI sharedInstance].logger error:message];
            break;
            
        default:
            break;
    }
}

-(void)logWithFormat:(NSString*)format logLevel:(EALogLevel)logLevel arguments:(va_list)argList NS_FORMAT_FUNCTION(1,0)
{
    NSString* message = [[NSString alloc] initWithFormat:format arguments:argList];
    [self log:message logLevel:logLevel];
}

#pragma mark - Event tracking

-(void)logEvent:(NSString*)event category:(NSString*)category withParameters:(NSDictionary*)params
{
    NSAssert(event, @"Nil event name");
    NSAssert (category, @"Nil category name");
    
    id label = [params objectForKey:kPropLoggerLabel];
    id labelValue = [params objectForKey:kPropLoggerLabelValue];
    
    GAIDictionaryBuilder* db = [GAIDictionaryBuilder createEventWithCategory:category
                                                                      action:event
                                                                       label:label
                                                                       value:labelValue];
    if (params)
    {
        // Translate params to custom dimensions
        NSMutableDictionary* dict = [params mutableCopy];
        [dict removeObjectForKey:kPropLoggerLabel];
        [dict removeObjectForKey:kPropLoggerLabelValue];
        
        for (NSInteger index = 0; index < dict.count; index++)
        {
            id paramValue = [dict.allValues objectAtIndex:index];
            [db set:[GAIFields customDimensionForIndex:index] forKey:paramValue];
        }
    }
    
    [[[GAI sharedInstance] defaultTracker] send:[db build]];
}

-(void)logError:(NSError*)error message:(NSString*)message withParameters:(NSDictionary*)params
{
    [[GAI sharedInstance].logger error:[NSString stringWithFormat:@"message:%@, error:%@", message, error]];
}

-(void)logException:(NSException*)exception message:(NSString*)message withParameters:(NSDictionary*)params
{
    [[GAI sharedInstance].logger error:[NSString stringWithFormat:@"message:%@, exception:%@", message, exception]];
}

@end

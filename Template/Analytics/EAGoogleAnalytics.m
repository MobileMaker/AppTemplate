//
//  EAGoogleAnalytics.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EAGoogleAnalytics.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

NSString* const kGoogleAnalyticsTrackerId      = @"2ZBMBBS36JZSVJTJVXR4";


@interface EAGoogleAnalytics()

@property (nonatomic, copy) NSString* gaScreenName;

@end

@implementation EAGoogleAnalytics

-(instancetype)init
{
    if (self = [super init])
    {
        // Note: iOS only allows one crash reporting tool per app; if using another, set to: NO
        [GAI sharedInstance].trackUncaughtExceptions = NO;
        // Optional: Set Google Analytics dispatch interval to e.g. 20 seconds.
        [GAI sharedInstance].dispatchInterval = 40;
        
#ifdef DEBUG
        [[GAI sharedInstance].logger setLogLevel:kGAILogLevelWarning];
#else
        [[GAI sharedInstance].logger setLogLevel:kGAILogLevelError];
#endif
        // Automatically sets as defualt tracker
        [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsTrackerId];
        
        // Send a single hit with session control to start the new session.
        [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                                                             action:@"appstart"
                                                                                              label:nil
                                                                                              value:nil] set:@"start" forKey:kGAISessionControl] build]];
    }
    
    return self;
}

-(NSString*)trackerName
{
    return kGoogleAnalyticsTrackerName;
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

-(void)bindParametersToTracker:(NSDictionary*)params
{
    NSAssert(params, @"Nil tracker bind params");
}

-(void)logEvent:(NSString*)event category:(NSString*)category withParameters:(NSDictionary*)params
{
    NSAssert(event, @"Nil event name");
    NSAssert (category, @"Nil category name");
    
    id label = [params objectForKey:kPropTrackerLabel];
    id labelValue = [params objectForKey:kPropTrackerLabelValue];
    
    GAIDictionaryBuilder* db = [GAIDictionaryBuilder createEventWithCategory:category
                                                                      action:event
                                                                       label:label
                                                                       value:labelValue];
    if (params)
    {
        // Translate params to custom dimensions
        NSMutableDictionary* dict = [params mutableCopy];
        [dict removeObjectForKey:kPropTrackerLabel];
        [dict removeObjectForKey:kPropTrackerLabelValue];
        
        for (NSInteger index = 0; index < dict.count; index++)
        {
            id paramValue = [dict.allValues objectAtIndex:index];
            [db set:[GAIFields customDimensionForIndex:index] forKey:paramValue];
        }
    }
    
    [[[GAI sharedInstance] defaultTracker] send:[db build]];
}

@end

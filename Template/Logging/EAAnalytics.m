//
//  EAAnalytics.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EAAnalytics.h"


@interface EAAnalytics()

@property (nonatomic, strong) NSMutableDictionary* trackers;

@end


@implementation EAAnalytics

+(EAAnalytics*)shared
{
    static dispatch_once_t pred;
    static EAAnalytics* sharedInstance = nil;
    
    // Instantiate singleton on first request
    dispatch_once(&pred, ^{
        sharedInstance = [[EAAnalytics alloc] init];
    });
    
    return sharedInstance;
}

-(NSString*)trackerName
{
    return kApplicationTrackerName;
}

-(instancetype)init
{
    if (self = [super init])
    {
        self.trackers = [NSMutableDictionary dictionary];
    }
    
    return self;
}

-(void)addTracker:(id<EAAnalyticsTracker>)tracker
{
    NSAssert(tracker, @"Nil tracker");
    NSAssert([tracker trackerName], @"Nil tracker name");
    
    id obj = [self.trackers objectForKey:[tracker trackerName]];
    if (!obj)
    {
        DLog(@"Add tracking for: %@", [tracker trackerName]);
        [self.trackers setObject:tracker forKey:[tracker trackerName]];
    }
    else
    {
        DLog(@"Tracker already registered");
    }
}

-(void)removeTracker:(NSString*)trackerName
{
    NSAssert(trackerName, @"Nil tracker name");
    
    [self.trackers removeObjectForKey:trackerName];
}

#pragma mark - Event Tracking

-(void)setScreenName:(NSString*)screenName
{
    for (id<EAAnalyticsTracker> tracker in self.trackers)
    {
        if ([tracker respondsToSelector:@selector(setScreenName:)])
            [tracker setScreenName:screenName];
    }
}

-(void)bindParametersToTracker:(NSDictionary*)params
{
    NSAssert(params, @"Nil tracker bind params");
    
    for (id<EAAnalyticsTracker> tracker in self.trackers.allValues)
    {
        if ([tracker respondsToSelector:@selector(bindParametersToTracker:)])
            [tracker bindParametersToTracker:params];
    }
}

-(void)logEvent:(NSString*)event category:(NSString*)category withParameters:(NSDictionary*)params
{
    NSAssert(event, @"Nil event name");
    
    for (id<EAAnalyticsTracker> tracker in self.trackers.allValues)
    {
        if ([tracker respondsToSelector:@selector(logEvent:category:withParameters:)])
            [tracker logEvent:event category:category withParameters:params];
    }
}

-(void)logError:(NSString*)errorDescr message:(NSString*)message exception:(NSException*)exception withParameters:(NSDictionary*)params
{
    NSAssert(exception, @"Nil exception");
    NSAssert(errorDescr, @"Nil error description");
    
    for (id<EAAnalyticsTracker> tracker in self.trackers.allValues)
    {
        if ([tracker respondsToSelector:@selector(logError:message:exception:withParameters:)])
            [tracker logError:errorDescr message:message exception:exception withParameters:params];
    }
}

-(void)logError:(NSString*)errorDescr message:(NSString*)message error:(NSError*)error withParameters:(NSDictionary*)params
{
    NSAssert(error, @"Nil error");
    NSAssert(errorDescr, @"Nil error description");
    
    for (id<EAAnalyticsTracker> tracker in self.trackers.allValues)
    {
        if ([tracker respondsToSelector:@selector(logError:message:error:withParameters:)])
            [tracker logError:errorDescr message:message error:error withParameters:params];
    }
}

-(void)logTimedEvent:(NSString*)event category:(NSString*)category withParameters:(NSDictionary*)params timed:(BOOL)timed
{
    NSAssert(event, @"Nil event name");
    
    for (id<EAAnalyticsTracker> tracker in self.trackers.allValues)
    {
        if ([tracker respondsToSelector:@selector(logTimedEvent:category:withParameters:timed:)])
            [tracker logTimedEvent:event category:category withParameters:params timed:timed];
    }
}

-(void)endTimedEvent:(NSString*)event withParameters:(NSDictionary*)params
{
    NSAssert(event, @"Nil event name");
    
    for (id<EAAnalyticsTracker> tracker in self.trackers.allValues)
    {
        if ([tracker respondsToSelector:@selector(endTimedEvent:withParameters:)])
            [tracker endTimedEvent:event withParameters:params];
    }
}

@end

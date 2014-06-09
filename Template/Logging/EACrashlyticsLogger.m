//
//  EACrashlyticsLogger.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EACrashlyticsLogger.h"
#import <Crashlytics/Crashlytics.h>

NSString* const kCrashlyticsKey      = @"f70a373c1fd4603a71ef861ec7ccc2b82284af1e";

@implementation EACrashlyticsLogger

+(instancetype)shared
{
    static dispatch_once_t pred;
    static EACrashlyticsLogger* sharedInstance = nil;
    
    // Instantiate singleton on first request
    dispatch_once(&pred, ^
    {
        NSLog(@"Initialize '%@' logger", kCrashlyticsLoggerName);
        sharedInstance = [EACrashlyticsLogger new];
    });
    
    return sharedInstance;
}

-(instancetype)init
{
    if (self = [super init])
    {
        self.logLevelCheckingPolicy = EALogLevelCheckingPolicyYESNO;
        self.logLevel = EALogLevelTrace;
    }
    
    return self;
}

+(instancetype)startWithLogLevel:(EALogLevel)logLevel parameters:(NSDictionary*)params
{
    static dispatch_once_t pred;
    
    EACrashlyticsLogger* logger = [EACrashlyticsLogger shared];
    
    dispatch_once(&pred, ^
    {
        [Crashlytics startWithAPIKey:kCrashlyticsKey];
        
        [logger setLogLevel:logLevel];
        if (params)
        {
            [logger addLoggerParameters:params];
        }
    });
    
    return logger;
}

-(NSString*)name
{
    return kCrashlyticsLoggerName;
}

-(EALogCapabilities)capabilities
{
    return EALogCapabilityCanReportCrashes | EALogCapabilityReportsCrashes;
}

#pragma mark - Logging

-(void)addLoggerParameters:(NSDictionary*)params
{
    NSString* userId = (NSString*)[params objectForKey:kPropLoggerUserId];
    if (userId && [userId isKindOfClass:[NSString class]])
        [Crashlytics setUserIdentifier:userId];
    
    NSString* userName = (NSString*)[params objectForKey:kPropLoggerUserName];
    if (userName && [userName isKindOfClass:[NSString class]])
        [Crashlytics setUserName:userName];
    
    NSString* userEmail = (NSString*)[params objectForKey:kPropLoggerEmail];
    if (userEmail && [userEmail isKindOfClass:[NSString class]])
        [Crashlytics setUserEmail:userEmail];
    
    // Remove already used params and add other as cusotm
    NSMutableDictionary* otherParams = [params mutableCopy];
    [otherParams removeObjectForKey:kPropLoggerUserId];
    [otherParams removeObjectForKey:kPropLoggerUserName];
    [otherParams removeObjectForKey:kPropLoggerEmail];
    
    // Add rest params as custom
    for (NSString* key in otherParams.allKeys)
    {
        id value = [otherParams objectForKey:key];
        [Crashlytics setObjectValue:value forKey:key];
    }
}

-(void)removeLoggerParameters:(NSArray *)params
{
    for (NSString* param in params)
    {
        if ([param isEqualToString:kPropLoggerUserId])
            [Crashlytics setUserIdentifier:nil];
        else if ([param isEqualToString:kPropLoggerUserName])
            [Crashlytics setUserName:nil];
        else if ([param isEqualToString:kPropLoggerEmail])
            [Crashlytics setUserEmail:nil];
        else
            [Crashlytics setObjectValue:nil forKey:param];
    }
}

-(void)resetLoggerParameters
{
    [Crashlytics setUserIdentifier:nil];
    [Crashlytics setUserName:nil];
    [Crashlytics setUserEmail:nil];
}

-(void)log:(NSString*)message
{
    CLSLog(message, nil);
}

-(void)logException:(NSException*)exception message:(NSString*)message withParameters:(NSDictionary*)params
{
    NSString* logMessage = [NSString stringWithFormat:@"message:%@, exception:%@", message ? message : @"<none>", exception];
    [self log:logMessage logLevel:EALogLevelCritical];
}

-(void)logError:(NSError*)error message:(NSString*)message withParameters:(NSDictionary*)params
{
    NSString* logMessage = [NSString stringWithFormat:@"message:%@, exception:%@", message ? message : @"<none>", error];
    [self log:logMessage logLevel:EALogLevelError];
}

@end

//
//  EACrashlyticsLogger.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EACrashlyticsLogger.h"
#import <Crashlytics/Crashlytics.h>


@implementation EACrashlyticsLogger

-(instancetype)init
{
    return [self initWithParameters:nil];
}

-(instancetype)initWithParameters:(NSDictionary*)params
{
    if (self = [super init])
    {
        if (params)
        {
            [self addLoggerParameters:params];
        }
    }
    
    return self;
}

-(NSString*)loggerName
{
    return kCrashlyticsLoggerName;
}

#pragma mark - Logging

-(void)addLoggerParameters:(NSDictionary*)params
{
    NSAssert(params, @"Nil logger add params");
    
    NSString* userId = (NSString*)[params objectForKey:kPropTrackerUserId];
    if (userId && [userId isKindOfClass:[NSString class]])
        [Crashlytics setUserIdentifier:userId];
    
    NSString* userName = (NSString*)[params objectForKey:kPropTrackerUserName];
    if (userName && [userName isKindOfClass:[NSString class]])
        [Crashlytics setUserName:userName];
    
    NSString* userEmail = (NSString*)[params objectForKey:kPropTrackerEmail];
    if (userEmail && [userEmail isKindOfClass:[NSString class]])
        [Crashlytics setUserEmail:userEmail];
    
    // Remove already used params and add other as cusotm
    NSMutableDictionary* otherParams = [params mutableCopy];
    [otherParams removeObjectForKey:kPropTrackerUserId];
    [otherParams removeObjectForKey:kPropTrackerUserName];
    [otherParams removeObjectForKey:kPropTrackerEmail];
    
    // Add rest params as custom
    for (NSString* key in otherParams.allKeys)
    {
        id value = [otherParams objectForKey:key];
        [Crashlytics setObjectValue:value forKey:key];
    }
}

-(void)removeLoggerParameters:(NSArray *)params
{
    NSAssert(params, @"Nil logger remove params");
    
    for (NSString* param in params)
    {
        if ([param isEqualToString:kPropTrackerUserId])
            [Crashlytics setUserIdentifier:nil];
        else if ([param isEqualToString:kPropTrackerUserName])
            [Crashlytics setUserName:nil];
        else if ([param isEqualToString:kPropTrackerEmail])
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
    NSAssert(message, @"Nil message");
    
    CLSLog(message, nil);
}

-(void)logWithFormat:(NSString*)format arguments:(va_list)argList
{
    NSAssert(format, @"Nil format");
    
    NSString* message = [[NSString alloc] initWithFormat:format arguments:argList];
    CLSLog(message, nil);
}

@end

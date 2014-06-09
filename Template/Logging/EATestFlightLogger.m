//
//  EATestFlightLogger.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EATestFlightLogger.h"
#import <TestFlightSDK/TestFlight.h>


NSString* const kTestFlightKey      = @"fb102e41-aac5-4632-94e3-85b22c1cb81f";

@implementation EATestFlightLogger

+(instancetype)shared
{
    static dispatch_once_t pred;
    static EATestFlightLogger* sharedInstance = nil;
    
    // Instantiate singleton on first request
    dispatch_once(&pred, ^
    {
        NSLog(@"Initialize '%@' logger", kTestFlightLoggerName);
        sharedInstance = [EATestFlightLogger alloc];
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
    
    EATestFlightLogger* logger = [EATestFlightLogger shared];
    
    dispatch_once(&pred, ^
    {
        [logger setLogLevel:logLevel];
        
        if (params)
        {
            for (NSString* key in params.allKeys)
            {
                id value = [params objectForKey:key];
                NSString* strValue = [value isKindOfClass:[NSString class]] ? (NSString*)value : ([value respondsToSelector:@selector(stringValue)] ? [value stringValue] : nil);
                if (strValue)
                    [TestFlight addCustomEnvironmentInformation:strValue forKey:key];
            };
        }
        
        [TestFlight setOptions:@{TFOptionDisableInAppUpdates:@YES,
                                 TFOptionFlushSecondsInterval:@120,
                                 TFOptionLogOnCheckpoint:@NO,
                                 TFOptionLogToConsole:@NO,
                                 TFOptionLogToSTDERR:@NO,
                                 TFOptionReinstallCrashHandlers:@NO,
                                 TFOptionReportCrashes:@NO,
                                 TFOptionSendLogOnlyOnCrash:@NO,
                                 TFOptionSessionKeepAliveTimeout:@0}];
        
        [TestFlight takeOff:kTestFlightKey];
    });
    
    return logger;
}

-(NSString*)name
{
    return kTestFlightLoggerName;
}

-(EALogCapabilities)capabilities
{
    return EALogCapabilityCanReportCrashes;
}

#pragma mark - Logging

-(void)log:(NSString*)message
{
    TFLogPreFormatted(message);
}

-(void)passCheckpoint:(NSString*)checkpointName
{
    [TestFlight passCheckpoint:checkpointName];
}

-(void)submitFeedback:(NSString*)feedback
{
    [TestFlight submitFeedback:feedback];
}

@end

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
   }
    
    return self;
}

-(NSString*)loggerName
{
    return kTestFlightLoggerName;
}

#pragma mark - Logging

-(void)addLoggerParameters:(NSDictionary*)params
{
    NSAssert(params, @"Nil logger bind params");
    
    // For TestFlight information can be added only before takeOff
    static BOOL bind = NO;
    
    if (!bind)
    {
        for (NSString* key in params.allKeys)
        {
            id value = [params objectForKey:key];
            NSString* strValue = [value isKindOfClass:[NSString class]] ? (NSString*)value : ([value respondsToSelector:@selector(stringValue)] ? [value stringValue] : nil);
            if (strValue)
                [TestFlight addCustomEnvironmentInformation:strValue forKey:key];
        }
    }
    
    bind = YES;
}

-(void)log:(NSString*)message
{
    NSAssert(message, @"Nil message");
    
    TFLogPreFormatted(message);
}

-(void)logWithFormat:(NSString*)format arguments:(va_list)argList
{
    NSAssert(format, @"Nil format");
    
    NSString* message = [[NSString alloc] initWithFormat:format arguments:argList];
    TFLogPreFormatted(message);
}

@end

//
//  EADefaultLogger.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EADefaultLogger.h"


@implementation EADefaultLogger

+(instancetype)shared
{
    static dispatch_once_t pred;
    static EADefaultLogger* sharedInstance = nil;
    
    // Instantiate singleton on first request
    dispatch_once(&pred, ^
    {
        NSLog(@"Initialize '%@' logger", kDefaultLoggerName);
        sharedInstance = [EADefaultLogger new];
    });
    
    return sharedInstance;
}

-(instancetype)init
{
    if (self = [super init])
    {
        self.logLevelCheckingPolicy = EALogLevelCheckingPolicyYESNO;
    }
    
    return self;
}

+(instancetype)startWithLogLevel:(EALogLevel)logLevel parameters:(NSDictionary*) __unused params
{
    static dispatch_once_t pred;
    
    EADefaultLogger* logger = [EADefaultLogger shared];
    
    dispatch_once(&pred, ^
    {
        [logger setLogLevel:logLevel];
    });
    
    return logger;
}

-(NSString*)name
{
    return kDefaultLoggerName;
}

-(EALogCapabilities)capabilities
{
    return EALogCapabilityMirrorsToSTDOUT;
}

#pragma mark - Logging

-(void)log:(NSString*)message
{
    NSLog(message, nil);
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

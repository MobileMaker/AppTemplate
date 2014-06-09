//
//  EALevelLogger.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EALevelLogger.h"


@implementation EALevelLogger

-(instancetype)init
{
    if (self = [super init])
    {
        _logLevel = EALogLevelNone;
        _logLevelCheckingPolicy = EALogLevelCheckingPolicyLeveled;
    }
    
    return self;
}

-(NSString*)name
{
    return nil;
}

-(EALogCapabilities)capabilities
{
    return EALogCapabilityNone;
}

-(instancetype)initWithLogLevel:(EALogLevel)logLevel logLevelCheckingPolicy:(EALogLevelCheckingPolicy)logLevelCheckingPolicy
{
    if (self = [super init])
    {
        _logLevel = (logLevel != EALogLevelNotSet) ? logLevel : EALogLevelNone;
        _logLevelCheckingPolicy = logLevelCheckingPolicy;
    }
    
    return self;
}

-(BOOL)shouldLogWithLogLevel:(EALogLevel)logLevel
{
    NSAssert(logLevel >= EALogLevelCritical, @"Invalid log level for message");
    
    // Ignore any logging if level not set
    if (_logLevel == EALogLevelNotSet)
    {
        NSLog(@"Attempt to log via '%@' with not configured logging level", [self name]);
        return NO;
    }
    
    BOOL logMessage = NO;
    
    switch (_logLevelCheckingPolicy)
    {
        case EALogLevelCheckingPolicyNone: logMessage = YES; break;
        case EALogLevelCheckingPolicyYESNO: logMessage = (_logLevel != EALogLevelNone); break;
        case EALogLevelCheckingPolicyLeveled: logMessage = (logLevel <= _logLevel) && (_logLevel != EALogLevelNone); break;
    }
    
    return logMessage;
}

@end

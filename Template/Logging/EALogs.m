//
//  EALogs.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EALogs.h"
#import "Utils/EAPair.h"


typedef NS_OPTIONS(NSUInteger, EALoggerAvailableFunctionFlags)
{
    fAddLoggerParameters                = 0,
    fRemoveLoggerParameters             = 1 << 0,
    fResetLoggerParameters              = 1 << 1,
    fLand                               = 1 << 2,
    fLogExceptionMessageParameters      = 1 << 3,
    fLogErrorMessageParameters          = 1 << 4,
    fLogScreen                          = 1 << 5,
    fLogEventCategoryParameters         = 1 << 6,
    fLogTimedEventParameters            = 1 << 7,
    fEndTimedEventParameters            = 1 << 8,
    fPassCheckpoint                     = 1 << 9,
    fSubmitFeedback                     = 1 << 10,
    fLogWithLogLevel                    = 1 << 11,
    fLogFormatWithLogLevelArguments     = 1 << 12,
    fLogLevelGetter                     = 1 << 13,
    fLogLevelSetter                     = 1 << 14,
};

@interface EALogs()

@property (nonatomic, strong) NSMutableDictionary* loggers;

/** The logic is simple - Logging always restricted to the level of application logger and only then
 concrete loggers level taken into account */

@end


@implementation EALogs

+(EALogs*)shared
{
    static dispatch_once_t pred;
    static EALogs* sharedInstance = nil;
    
    // Instantiate singleton on first request
    dispatch_once(&pred, ^{
        sharedInstance = [[EALogs alloc] init];
    });
    
    return sharedInstance;
}

-(NSString*)name
{
    return kApplicationLoggerName;
}

-(EALogCapabilities)capabilities
{
    return EALogCapabilityNone;
}

-(EALogLevelCheckingPolicy)logLevelCheckingPolicy
{
    return EALogLevelCheckingPolicyLeveled;
}

-(instancetype)init
{
    if (self = [super init])
    {
        _loggers = [NSMutableDictionary dictionary];
        
        // Set maximum level for main logger to allow concrete levels 
        [self setLogLevel:EALogLevelTrace];
        
        NSLog(@"Initialize '%@' logger", kApplicationLoggerName);
        NSLog(@"Add logging to '%@' with logging level %d", kApplicationLoggerName, self.logLevel);
    }
    
    return self;
}

/* Sets loggin level for ALL existing loggers. If you want to provide different logging leveles for each logger
 then manage logging level of concrete logger */
-(void)setLogLevel:(EALogLevel)logLevel
{
    if (logLevel == EALogLevelNotSet)
    {
        NSLog(@"Invalid logging level specified. Setting to 'None'");
        logLevel = EALogLevelNone;
    }
    
    [super setLogLevel:logLevel];
    
    for (id<EALogger> logger in self.loggers.allValues)
    {
        if ([logger isKindOfClass:[EALevelLogger class]])
            [(EALevelLogger*)logger setLogLevel:logLevel];
    }
}

#pragma mark - Loggers

-(void)addLogger:(id<EALogger>)logger
{
    NSAssert(logger, @"Nil logger");
    NSAssert([logger name], @"Nil logger name");
    
    @synchronized(self)
    {
        id obj = [self.loggers objectForKey:[logger name]];
        if (!obj)
        {
            EALoggerAvailableFunctionFlags loggerAvailableFunctionFlags = 0;
            if ([logger respondsToSelector:@selector(addLoggerParameters:)])
                loggerAvailableFunctionFlags |= fAddLoggerParameters;
            if ([logger respondsToSelector:@selector(removeLoggerParameters:)])
                loggerAvailableFunctionFlags |= fRemoveLoggerParameters;
            if ([logger respondsToSelector:@selector(resetLoggerParameters)])
                loggerAvailableFunctionFlags |= fResetLoggerParameters;
            if ([logger respondsToSelector:@selector(land)])
                loggerAvailableFunctionFlags |= fLand;
            if ([logger respondsToSelector:@selector(logException:message:withParameters:)])
                loggerAvailableFunctionFlags |= fLogExceptionMessageParameters;
            if ([logger respondsToSelector:@selector(logError:message:withParameters:)])
                loggerAvailableFunctionFlags |= fLogErrorMessageParameters;
            if ([logger respondsToSelector:@selector(logScreen:)])
                loggerAvailableFunctionFlags |= fLogScreen;
            if ([logger respondsToSelector:@selector(logEvent:category:withParameters:)])
                loggerAvailableFunctionFlags |= fLogEventCategoryParameters;
            if ([logger respondsToSelector:@selector(logTimedEvent:category:withParameters:timed:)])
                loggerAvailableFunctionFlags |= fLogTimedEventParameters;
            if ([logger respondsToSelector:@selector(endTimedEvent:withParameters:)])
                loggerAvailableFunctionFlags |= fEndTimedEventParameters;
            if ([logger respondsToSelector:@selector(passCheckpoint:)])
                loggerAvailableFunctionFlags |= fPassCheckpoint;
            if ([logger respondsToSelector:@selector(submitFeedback:)])
                loggerAvailableFunctionFlags |= fSubmitFeedback;
            if ([logger respondsToSelector:@selector(logWithLogLevel:format:)])
                loggerAvailableFunctionFlags |= fLogWithLogLevel;
            if ([logger respondsToSelector:@selector(logWithFormat:logLevel:arguments:)])
                loggerAvailableFunctionFlags |= fLogFormatWithLogLevelArguments;
            if ([logger respondsToSelector:@selector(logLevel)])
                loggerAvailableFunctionFlags |= fLogLevelGetter;
            if ([logger respondsToSelector:@selector(setLogLevel:)])
                loggerAvailableFunctionFlags |= fLogLevelSetter;
            
            [self.loggers setObject:[EAPair pairWithFirstObj:logger andSecondObj:[NSNumber numberWithUnsignedInteger:loggerAvailableFunctionFlags]] forKey:[logger name]];
            
            // If logging level not set for logger
            if ([logger isKindOfClass:[EALevelLogger class]])
            {
                EALogLevel activeLogLevel = (self.logLevel != EALogLevelNotSet) ? self.logLevel : EALogLevelNone;
                
                // Log level for concrete logger must be defined. If not it will be turned off
                if ([((EALevelLogger*)logger) logLevel] == EALogLevelNotSet)
                {
                    NSLog(@"Add '%@' logger with not configured logging level. Setting to %d", [self name], activeLogLevel);
                    [(EALevelLogger*)logger setLogLevel:activeLogLevel];
                }
                
                NSLog(@"Add logging to '%@' with logging level %d", [logger name], [((EALevelLogger*)logger) logLevel]);
            }
            else
            {
                NSLog(@"Add logging to '%@'", [logger name]);
            }
        }
        else
        {
            NSLog(@"Logger already registered");
        }
    }
}

-(void)removeLogger:(NSString*)loggerName
{
    NSAssert(loggerName, @"Nil logger name");
    
    @synchronized(self)
    {
        [self.loggers removeObjectForKey:loggerName];
    }
}

-(id)loggerWithName:(NSString*)loggerName
{
    NSAssert(loggerName, @"Nil logger name");
    
    @synchronized(self)
    {
        EAPair* pair = (EAPair*)[self.loggers objectForKey:loggerName];
        if (pair) return pair.first;
    }
    
    return nil;
}

#pragma mark - Logging

-(void)addLoggerParameters:(NSDictionary*)params
{
    NSAssert(params, @"Nil logger bind params");
    
    for (EAPair* pair in self.loggers.allValues)
    {
        if (((NSNumber*)pair.second).unsignedIntegerValue & fAddLoggerParameters)
            [(id<EALogger>)pair.first addLoggerParameters:params];
    }
}

-(void)removeLoggerParameters:(NSArray*)params
{
    NSAssert(params, @"Nil logger bind params");
    
    for (EAPair* pair in self.loggers.allValues)
    {
        if (((NSNumber*)pair.second).unsignedIntegerValue & fRemoveLoggerParameters)
            [(id<EALogger>)pair.first removeLoggerParameters:params];
    }
}

-(void)resetLoggerParameters
{
    for (EAPair* pair in self.loggers.allValues)
    {
        if (((NSNumber*)pair.second).unsignedIntegerValue & fResetLoggerParameters)
            [(id<EALogger>)pair.first resetLoggerParameters];
    }
}

-(void)land
{
    for (EAPair* pair in self.loggers.allValues)
    {
        if (((NSNumber*)pair.second).unsignedIntegerValue & fLand)
            [(id<EALogger>)pair.first land];
    }
}

#pragma mark - Message logger

-(void)log:(NSString*)message logLevel:(EALogLevel)level
{
    NSAssert(message, @"Nil message");
    
    if (![self shouldLogWithLogLevel:level]) return;
    
    @synchronized(self)
    {
        for (EAPair* pair in self.loggers.allValues)
        {
            if (((NSNumber*)pair.second).unsignedIntegerValue & fLogWithLogLevel)
                [(id<EAMessageLogger>)pair.first log:message logLevel:level];
        }
    }
}

-(void)logWithFormat:(NSString*)format logLevel:(EALogLevel)logLevel arguments:(va_list)argList
{
    NSAssert(format, @"Nil format");
    
    if (![self shouldLogWithLogLevel:logLevel]) return;
    
    @synchronized(self)
    {
        NSString* message = [[NSString alloc] initWithFormat:format arguments:argList];
        
        for (EAPair* pair in self.loggers.allValues)
        {
            if (((NSNumber*)pair.second).unsignedIntegerValue & fLogWithLogLevel)
                [(id<EAMessageLogger>)pair.first log:message logLevel:logLevel];
        }
    }
}

-(void)logWithFormat:(NSString*)format, ...
{
    NSAssert(format, @"Nil message");
    
    if (![self shouldLogWithLogLevel:EALogLevelTrace]) return;
    
    @synchronized(self)
    {
        va_list args;
        va_start(args, format);
        for (EAPair* pair in self.loggers.allValues)
        {
            if (((NSNumber*)pair.second).unsignedIntegerValue & fLogFormatWithLogLevelArguments)
                [(id<EAMessageLogger>)pair.first logWithFormat:format logLevel:EALogLevelTrace arguments:args];
        }
        va_end(args);
    }
}

-(void)logWithLogLevel:(EALogLevel)level format:(NSString*)format, ...
{
    NSAssert(format, @"Nil message");
    
    if (![self shouldLogWithLogLevel:level]) return;
    
    @synchronized(self)
    {
        va_list args;
        va_start(args, format);
        for (EAPair* pair in self.loggers.allValues)
        {
            if (((NSNumber*)pair.second).unsignedIntegerValue & fLogFormatWithLogLevelArguments)
                [(id<EAMessageLogger>)pair.first logWithFormat:format logLevel:level arguments:args];
        }
        va_end(args);
    }
}

#pragma mark - Error logger

-(void)logException:(NSException*)exception message:(NSString*)message withParameters:(NSDictionary*)params
{
    NSAssert(exception, @"Nil error description");
    NSAssert(message, @"Nil error message");
    
    if (![self shouldLogWithLogLevel:EALogLevelCritical]) return;
    
    @synchronized(self)
    {
        for (EAPair* pair in self.loggers.allValues)
        {
            if (((NSNumber*)pair.second).unsignedIntegerValue & fLogExceptionMessageParameters)
                [(id<EAErrorLogger>)pair.first logException:exception message:message withParameters:params];
        }
    }
}

-(void)logError:(NSError*)error message:(NSString*)message withParameters:(NSDictionary*)params
{
    NSAssert(error, @"Nil error description");
    NSAssert(message, @"Nil error message");
    
    if (![self shouldLogWithLogLevel:EALogLevelError]) return;
    
    @synchronized(self)
    {
        for (EAPair* pair in self.loggers.allValues)
        {
            if (((NSNumber*)pair.second).unsignedIntegerValue & fLogErrorMessageParameters)
                [(id<EAErrorLogger>)pair.first logError:error message:message withParameters:params];
        }
    }
}

#pragma mark - Event tracker

-(void)logScreen:(NSString*)screenName
{
    NSAssert(screenName, @"Nil screen name");
    
    @synchronized(self)
    {
        for (EAPair* pair in self.loggers.allValues)
        {
            if (((NSNumber*)pair.second).unsignedIntegerValue & fLogScreen)
                [(id<EAEventLogger>)pair.first logScreen:screenName];
        }
    }
}

-(void)logEvent:(NSString*)event category:(NSString*)category withParameters:(NSDictionary*)params
{
    NSAssert(event, @"Nil event name");
    NSAssert(category, @"Nil category name");
    
    @synchronized(self)
    {
        for (EAPair* pair in self.loggers.allValues)
        {
            if (((NSNumber*)pair.second).unsignedIntegerValue & fLogEventCategoryParameters)
                [(id<EAEventLogger>)pair.first logEvent:event category:category withParameters:params];
        }
    }
}

-(void)logTimedEvent:(NSString*)event category:(NSString*)category withParameters:(NSDictionary*)params timed:(BOOL)timed
{
    NSAssert(event, @"Nil event name");
    NSAssert(category, @"Nil category name");
    
    @synchronized(self)
    {
        for (EAPair* pair in self.loggers.allValues)
        {
            if (((NSNumber*)pair.second).unsignedIntegerValue & fLogTimedEventParameters)
                [(id<EAEventLogger>)pair.first logTimedEvent:event category:category withParameters:params timed:timed];
        }
    }
}

-(void)endTimedEvent:(NSString*)event withParameters:(NSDictionary*)params
{
    NSAssert(event, @"Nil event name");
    
    @synchronized(self)
    {
        for (EAPair* pair in self.loggers.allValues)
        {
            if (((NSNumber*)pair.second).unsignedIntegerValue & fEndTimedEventParameters)
                [(id<EAEventLogger>)pair.first endTimedEvent:event withParameters:params];
        }
    }
}

-(void)passCheckpoint:(NSString*)checkpointName
{
    NSAssert(checkpointName, @"Nil checkpoint name");
    
    @synchronized(self)
    {
        for (EAPair* pair in self.loggers.allValues)
        {
            if (((NSNumber*)pair.second).unsignedIntegerValue & fPassCheckpoint)
                [(id<EAEventLogger>)pair.first passCheckpoint:checkpointName];
        }
    }
}

-(void)submitFeedback:(NSString *)feedback
{
    NSAssert(feedback, @"Nil feedback");
    
    @synchronized(self)
    {
        for (EAPair* pair in self.loggers.allValues)
        {
            if (((NSNumber*)pair.second).unsignedIntegerValue & fSubmitFeedback)
                [(id<EAEventLogger>)pair.first submitFeedback:feedback];
        }
    }
}

@end

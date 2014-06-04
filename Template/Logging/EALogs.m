//
//  EALogs.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EALogs.h"


@interface EALogs()

@property (nonatomic, strong) NSMutableDictionary* loggers;

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

-(NSString*)loggerName
{
    return kApplicationLoggerName;
}

-(instancetype)init
{
    if (self = [super init])
    {
        self.loggers = [NSMutableDictionary dictionary];
    }
    
    return self;
}

-(void)addLogger:(id<EALogger>)logger
{
    NSAssert(logger, @"Nil logger");
    NSAssert([logger loggerName], @"Nil logger name");
    
    id obj = [self.loggers objectForKey:[logger loggerName]];
    if (!obj)
    {
        DLog(@"Add logging to: %@", [logger loggerName]);
        [self.loggers setObject:logger forKey:[logger loggerName]];
    }
    else
    {
        DLog(@"Logger already registered");
    }
}

#pragma mark - Logging

-(void)addLoggerParameters:(NSDictionary*)params
{
    NSAssert(params, @"Nil logger bind params");
    
    for (id<EALogger> logger in self.loggers)
    {
        if ([logger respondsToSelector:@selector(addLoggerParameters:)])
            [logger addLoggerParameters:params];
    }
}

-(void)removeLoggerParameters:(NSArray*)params
{
    NSAssert(params, @"Nil logger bind params");
    
    for (id<EALogger> logger in self.loggers)
    {
        if ([logger respondsToSelector:@selector(removeLoggerParameters:)])
            [logger removeLoggerParameters:params];
    }
}

-(void)resetLoggerParameters
{
    for (id<EALogger> logger in self.loggers)
    {
        if ([logger respondsToSelector:@selector(resetLoggerParameters)])
            [logger resetLoggerParameters];
    }
}

-(void)log:(NSString*)message
{
    NSAssert(message, @"Nil message");
    
    @synchronized(self)
    {
        for (id<EALogger> logger in self.loggers.allValues)
        {
            if ([logger respondsToSelector:@selector(log:)])
                [logger log:message];
        }
    }
}

-(void)logWithFormat:(NSString*)format, ...
{
    NSAssert(format, @"Nil message");
    
    @synchronized(self)
    {
        va_list args;
        va_start(args, format);
        for (id<EALogger> logger in self.loggers.allValues)
        {
            if ([logger respondsToSelector:@selector(logWithFormat:arguments:)])
                [logger logWithFormat:format arguments:args];
        }
        va_end(args);
    }
}

@end

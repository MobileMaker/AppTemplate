//
//  EADefaultLogger.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EADefaultLogger.h"


@implementation EADefaultLogger

-(instancetype)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

-(NSString*)loggerName
{
    return kDefaultLoggerName;
}

#pragma mark - Logging

-(void)log:(NSString*)message
{
    NSAssert(message, @"Nil message");
    
    NSLog(message, nil);
}

-(void)logWithFormat:(NSString*)format arguments:(va_list)argList
{
    NSAssert(format, @"Nil format");
    
    NSString* message = [[NSString alloc] initWithFormat:format arguments:argList];
    NSLog(message, nil);
}

@end

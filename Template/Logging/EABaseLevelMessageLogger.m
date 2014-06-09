//
//  EABaseLevelMessageLogger.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EABaseLevelMessageLogger.h"


@implementation EABaseLevelMessageLogger

#pragma mark - Loggin

-(void)log:(NSString*)message
{
    @throw([NSException exceptionWithName:NSInternalInconsistencyException reason:@"Function not implemented" userInfo:nil]);
}

-(void)log:(NSString*)message logLevel:(EALogLevel)logLevel
{
    BOOL shouldLog = [self shouldLogWithLogLevel:logLevel];
    
    if (shouldLog)
        [self log:message];
}

-(void)logWithFormat:(NSString*)format logLevel:(EALogLevel)logLevel arguments:(va_list)argList
{
    NSString* message = [[NSString alloc] initWithFormat:format arguments:argList];
    [self log:message logLevel:logLevel];
}

@end

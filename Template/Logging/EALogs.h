//
//  EALogs.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EALoggingConstants.h"
#import "EALevelLogger.h"
#import "Interfaces/EAErrorLogger.h"
#import "Interfaces/EAEventLogger.h"
#import "Interfaces/EAMessageLogger.h"

/** Loggers manager with default logging level EALogLevelTrace  */
@interface EALogs : EALevelLogger<EAEventLogger, EAErrorLogger, EAMessageLogger>

+(EALogs*)shared;

/** Register logger */
-(void)addLogger:(id<EALogger>)logger;
/** Remove logger by name */
-(void)removeLogger:(NSString*)loggerName;
/** Get logger by name */
-(id)loggerWithName:(NSString*)loggerName;

/** Log message with EALogLevelTrace level */
-(void)logWithFormat:(NSString*)format, ... NS_FORMAT_FUNCTION(1,2);
/** Log message with specified logging level */
-(void)logWithLogLevel:(EALogLevel)level format:(NSString*)format, ... NS_FORMAT_FUNCTION(2,3);

@end



#define Log(level, fmt, ...) [[EALogs shared] logWithLogLevel:level format:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__];

#define LogTrace(fmt, ...) Log(EALogLevelTrace, fmt, ##__VA_ARGS__);
#define LogDebug(fmt, ...) Log(EALogLevelDebug, fmt, ##__VA_ARGS__);
#define LogInfo(fmt, ...) Log(EALogLevelInfo, fmt, ##__VA_ARGS__);
#define LogWarning(fmt, ...) Log(EALogLevelWarning, fmt, ##__VA_ARGS__);
#define LogError(fmt, ...) Log(EALogLevelError, fmt, ##__VA_ARGS__);
#define LogCritical(fmt, ...) Log(EALogLevelCritical, fmt, ##__VA_ARGS__);
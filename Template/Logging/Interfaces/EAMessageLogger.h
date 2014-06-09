//
//  EAAnalytics.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Application logger interface. Takes into account logging level */
@protocol EAMessageLogger <NSObject>

@optional

/** Log message with logging level. Message processed if message logging level less then
 * @param message   Message to log
 * @param level     Logging level
 * @warning To make logging centralized all functions should log messages via log:
 */
-(void)log:(NSString*)message logLevel:(EALogLevel)logLevel;

/** Log message with format  EALogLevelTrace
 * @param format    Message format
 * @param level     Logging level
 * @param argList   Message arguments
 */
-(void)logWithFormat:(NSString*)format logLevel:(EALogLevel)logLevel arguments:(va_list)argList NS_FORMAT_FUNCTION(1,0);

@end

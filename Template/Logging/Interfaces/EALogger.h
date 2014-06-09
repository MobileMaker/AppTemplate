//
//  EALogger.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger, EALogCapabilities)
{
    EALogCapabilityNone                         = 0,
    EALogCapabilityCanReportCrashes             = 1 << 0,   // Can be set as crashreporter
    EALogCapabilityReportsCrashes               = 1 << 1,   // Acts as crashreporter
    EALogCapabilityMirrorsToSTDERR              = 1 << 2,
    EALogCapabilityMirrorsToSTDOUT              = 1 << 3,
    EALogCapabilityCanGroupLogs                 = 1 << 4
};

/** General logger protocol. By default log level EALogLevelError used. Manages logging according to logging level
 * @warning To implement different behaviour for logging levels please implement logWithFormat: and log:
 */
@protocol EALogger <NSObject>

@required

/** Get loger name */
-(NSString*)name __attribute__((pure));

/** Check logger capabilities */
-(EALogCapabilities)capabilities __attribute__((pure));

@optional

/** Set additional logger parameters to attach to logs 
 @param Check if concrete logger supports additional parameters
 */
-(void)addLoggerParameters:(NSDictionary*)params;
/** Remove attached additional logger parameters 
 @param Check if concrete logger supports additional parameters and removing parameters seperately
 */
-(void)removeLoggerParameters:(NSArray *)params;
/** Remove attached additional logger parameters
 @param Check if concrete logger supports additional parameters and removing parameters
 */
-(void)resetLoggerParameters;

/** Terminates logger activity and cleanup
 @warning Check if concrete logger supports termination
 */
-(void)land;

@end

//
//  EAAnalytics.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EALogsConstants.h"

/** Application logger interface
 @warning Be aware that some loggers are shared among whole systems, So instantiating new logger may not create additional logger, they
 will just share the same instanca that may lead to bugs. Some loggers act as crash reportes and you can install only one crash reposrter for application, so
 please check configuration of each logger to not collide and replace handlers.
 */
/*
 Next improvements:
 - Make every logger as shared instance, because actually all loggers are singletons
 - Make singleton instance to be possibly initialized with params
 - Distinguish between crashreported/logger and just logger
 - Try to figure out how to manage crashreporters due to only one must be available in system
 - Try to figure out hot to reset crash handler when changing crash reporter
 - Implement passCheckpoint methods
 - Implement remove logger from loggers manager
 - Implement add/remove logger to be singlethreaded
 */
@protocol EALogger <NSObject>

@required

/** Get loger name */
-(NSString*)loggerName;

@optional

/** Bind parameters to tracker to distinguish users */
-(void)addLoggerParameters:(NSDictionary*)params;
/** Remove logger params 
 * params       List of param names to remove
 */
-(void)removeLoggerParameters:(NSArray*)params;
/** Reset logger params */
-(void)resetLoggerParameters;

/** Log message 
 * @param message   Message to log
 */
-(void)log:(NSString*)message;
/** Log message with format 
 @param format      Message format
 */
-(void)logWithFormat:(NSString*)format arguments:(va_list)argList NS_FORMAT_FUNCTION(1,0);

/**
 * Track when a user has passed a checkpoint
 * @param checkpointName The name of the checkpoint, this should be a static string
 */
-(void)passCheckpoint:(NSString*)checkpointName;

/**
 * Submits custom feedback to the site. Sends the data in feedback to the site. This is to be used as the method to submit
 * feedback from custom feedback forms.
 * @param feedback Your users feedback, method does nothing if feedback is nil
 */
-(void)submitFeedback:(NSString*)feedback;

@end

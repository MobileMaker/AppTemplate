//
//  EAEventTracker.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Events logger protocol. Events have no logging level and go directly to event loggers */
@protocol EAEventLogger <NSObject>

@optional

/** Manage logging screen for instance */
-(void)logScreen:(NSString*)screenName;

/** Log event
 @param event       Event name
 @param category    Event category
 @param params      Event addtitional params
 */
-(void)logEvent:(NSString*)event category:(NSString*)category withParameters:(NSDictionary*)params;
/** Log timed event
 @param event       Event name
 @param category    Event category
 @param params      Event addtitional params
 @param timed       Is event timed
 */
-(void)logTimedEvent:(NSString*)event category:(NSString*)category withParameters:(NSDictionary*)params timed:(BOOL)timed;
/** Ends an existing timed event 
 * @param event     Event name
 @ @param params    Event addtitional params. Should update previous set event params, but depends on tracker
 */
-(void)endTimedEvent:(NSString*)event withParameters:(NSDictionary*)params;


/**
 * Track when a user has passed a checkpoint. If is not supported by logger then simulated as log message with EALogLevelInfo
 * @param checkpointName The name of the checkpoint, this should be a static string
 */
-(void)passCheckpoint:(NSString*)checkpointName;

/**
 * Submits custom feedback to the site. Sends the data in feedback to the site. This is to be used as the method to submit
 * If is not supported by logger then simulated as log message with EALogLevelInfo
 * feedback from custom feedback forms.
 * @param feedback Your users feedback, method does nothing if feedback is nil
 */
-(void)submitFeedback:(NSString*)feedback;

@end

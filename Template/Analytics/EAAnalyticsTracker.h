//
//  EAAnalytics.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAAnalyticsConstants.h"


@protocol EAAnalyticsTracker <NSObject>

@required

/** Get tracker name */
-(NSString*)trackerName;

@optional

/** Bind parameters to tracker to distinguish users */
-(void)bindParametersToTracker:(NSDictionary*)params;

/** Set active screen name for all events */
-(void)setScreenName:(NSString*)screenName;

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
/** Log error
 @param errorDescr  Error description
 @param message     Error message
 @param exception   Error exception
 @param params      Error addtitional params
 */
-(void)logError:(NSString*)errorDescr message:(NSString*)message exception:(NSException*)exception withParameters:(NSDictionary*)params;
/** Log error
 @param errorDescr  Error description
 @param message     Error message
 @param error       Error
 @param params      Error addtitional params
 */
-(void)logError:(NSString*)errorDescr message:(NSString*)message error:(NSError*)error withParameters:(NSDictionary*)params;

@end

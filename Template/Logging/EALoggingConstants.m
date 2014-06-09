//
//  EALoggingConstants.m
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "EALoggingConstants.h"

NSString* const kApplicationLoggerName                      = @"Main";
NSString* const kDefaultLoggerName                          = @"Console";
NSString* const kCrashlyticsLoggerName                      = @"Crashlytics";
NSString* const kTestFlightLoggerName                       = @"TestFlight";
NSString* const kGoogleAnalyticsLoggerName                  = @"Google Analytics";
NSString* const kFlurryAnalyticsLoggerName                  = @"Flurry";

// tracker properties
NSString* const kPropLoggerUserId                          = @"analytics_logger.property.user_id";
NSString* const kPropLoggerUserName                        = @"analytics_logger.property.user_name";
NSString* const kPropLoggerAge                             = @"analytics_logger.property.age";
NSString* const kPropLoggerGender                          = @"analytics_logger.property.gender";
NSString* const kPropLoggerEmail                           = @"analytics_logger.property.email";
NSString* const kPropLoggerLatitude                        = @"analytics_logger.property.gps.latitude";
NSString* const kPropLoggerLongitude                       = @"analytics_logger.property.gps.longitude";
NSString* const kPropLoggerHorizontalAccuracy              = @"analytics_logger.property.gps.horizontal_accuracy";
NSString* const kPropLoggerVerticalAccuracy                = @"analytics_logger.property.gps.vertical_accuracy";
NSString* const kPropLoggerLabel                           = @"analytics_logger.property.label";
NSString* const kPropLoggerLabelValue                      = @"analytics_logger.property.label_value";
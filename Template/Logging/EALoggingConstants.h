//
//  EALoggingConstants.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXPORT NSString* const kApplicationLoggerName;
OBJC_EXPORT NSString* const kDefaultLoggerName;
OBJC_EXPORT NSString* const kCrashlyticsLoggerName;
OBJC_EXPORT NSString* const kTestFlightLoggerName;
OBJC_EXPORT NSString* const kGoogleAnalyticsLoggerName;
OBJC_EXPORT NSString* const kFlurryAnalyticsLoggerName;

// Tracker properties
OBJC_EXPORT NSString* const kPropLoggerUserId;              // NSString
OBJC_EXPORT NSString* const kPropLoggerUserName;            // NSString
OBJC_EXPORT NSString* const kPropLoggerAge;                 // NSNumber with NSUInteger
OBJC_EXPORT NSString* const kPropLoggerGender;              // NSSTring "m" or "f"
OBJC_EXPORT NSString* const kPropLoggerEmail;
OBJC_EXPORT NSString* const kPropLoggerLatitude;            // NSNumber with double
OBJC_EXPORT NSString* const kPropLoggerLongitude;           // NSNumber with double
OBJC_EXPORT NSString* const kPropLoggerHorizontalAccuracy;  // NSNumber with float
OBJC_EXPORT NSString* const kPropLoggerVerticalAccuracy;    // NSNumber with float
OBJC_EXPORT NSString* const kPropLoggerLabel;
OBJC_EXPORT NSString* const kPropLoggerLabelValue;


//
//  EAAnalyticsConstants.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXPORT NSString* const kApplicationTrackerName;
OBJC_EXPORT NSString* const kGoogleAnalyticsTrackerName;
OBJC_EXPORT NSString* const kFlurryAnalyticsTrackerName;

// Tracker properties
OBJC_EXPORT NSString* const kPropTrackerUserId;         // NSString
OBJC_EXPORT NSString* const kPropTrackerUserName;       // NSString
OBJC_EXPORT NSString* const kPropTrackerAge;            // NSNumber with NSUInteger
OBJC_EXPORT NSString* const kPropTrackerGender;         // NSSTring "m" or "f"
OBJC_EXPORT NSString* const kPropTrackerEmail;
OBJC_EXPORT NSString* const kPropTrackerLatitude;       // NSNumber with double
OBJC_EXPORT NSString* const kPropTrackerLongitude;      // NSNumber with double
OBJC_EXPORT NSString* const kPropTrackerHorizontalAccuracy; // NSNumber with float
OBJC_EXPORT NSString* const kPropTrackerVerticalAccuracy;   // NSNumber with float
OBJC_EXPORT NSString* const kPropTrackerLabel;
OBJC_EXPORT NSString* const kPropTrackerLabelValue;
OBJC_EXPORT NSString* const kPropTrackerCustomObject;
OBJC_EXPORT NSString* const kPropTrackerCustomBOOL;
OBJC_EXPORT NSString* const kPropTrackerCustomInteger;


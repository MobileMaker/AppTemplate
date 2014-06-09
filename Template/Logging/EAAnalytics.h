//
//  EAAnalytics.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAAnalyticsTracker.h"

@interface EAAnalytics : NSObject<EAAnalyticsTracker>

+(EAAnalytics*)shared;

/** Register analytics tracker */
-(void)addTracker:(id<EAAnalyticsTracker>)tracker;
/** Remove analytics by name */
-(void)removeTracker:(NSString*)trackerName;

@end

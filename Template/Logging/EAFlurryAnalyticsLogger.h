//
//  EAFlurryAnalyticsLogger.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interfaces/EALogger.h"
#import "Interfaces/EAErrorLogger.h"
#import "Interfaces/EAEventLogger.h"

@interface EAFlurryAnalyticsLogger : NSObject<EALogger, EAEventLogger, EAErrorLogger>

/** Get logger shared instance */
+(instancetype)shared;

/** Initialize instance and start logging
 @warning Logger can be initialized only once
 @param params              Additional logger params to bind to
 @return Logger instance
 */
+(instancetype)startWithParameters:(NSDictionary*)params;

@end

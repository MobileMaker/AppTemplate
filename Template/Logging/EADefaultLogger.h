//
//  EADefaultLogger.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EABaseLevelMessageLogger.h"
#import "Interfaces/EAErrorLogger.h"


@interface EADefaultLogger : EABaseLevelMessageLogger<EAErrorLogger>

/** Get logger shared instance */
+(instancetype)shared;

/** Initialize instance and start logging
 @warning Logger can be initialized only once
 @param logLevel            Logging level
 @param params              Additional logger params to bind to
 @return Logger instance
 */
+(instancetype)startWithLogLevel:(EALogLevel)logLevel parameters:(NSDictionary*)params;

@end

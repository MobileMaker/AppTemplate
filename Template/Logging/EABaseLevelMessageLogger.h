//
//  EABaseLevelMessageLogger.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interfaces/EAMessageLogger.h"
#import "EALevelLogger.h"

/** Basic class for any message logger
 * @warning To implement different behaviour for logging levels please implement logWithFormat: and log:
 */
@interface EABaseLevelMessageLogger : EALevelLogger<EAMessageLogger>

/** Log message
 * @param message   Message to log
 * @warning To make logging centralized all functions should log messages via log:
 */
-(void)log:(NSString*)message;

@end

//
//  EALogs.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EALogger.h"

@interface EALogs : NSObject<EALogger>

+(EALogs*)shared;

/** Register logger */
-(void)addLogger:(id<EALogger>)logger;

-(void)logWithFormat:(NSString*)format, ... NS_REQUIRES_NIL_TERMINATION;

@end

//#define DLog(fmt, ...) [[EALogs shared] log:[[NSString stringWithFormat:@"%s [Line %d] ", __PRETTY_FUNCTION__, __LINE__] stringByAppendingFormat:fmt, ##__VA_ARGS__, nil]];
#define DLog(fmt, ...) [[EALogs shared] logWithFormat:(@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__, nil];

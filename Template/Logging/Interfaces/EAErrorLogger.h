//
//  EAErrorLogger.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Error logging protocol */
@protocol EAErrorLogger <NSObject>

@optional

/** Log exception. Treated as critical level
 @param exception   Error exception
 @param message     Error message
 @param params      Error addtitional params
 */
-(void)logException:(NSException*)exception message:(NSString*)message withParameters:(NSDictionary*)params;
/** Log error. Treated as error level
 @param error       Error
 @param message     Error message
 @param params      Error addtitional params
 */
-(void)logError:(NSError*)error message:(NSString*)message withParameters:(NSDictionary*)params;

@end

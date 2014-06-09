//
//  EALevelLogger.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interfaces/EALogger.h"


typedef NS_ENUM(NSUInteger, EALogLevel)
{
    /** The logging level not set and should be ignored for now */
    EALogLevelNotSet = -1,
    /* Logging turned off */
    EALogLevelNone = 0,
    /** Critical messages/events that mostly lead to app crash, data inconsistency, etc. Application can handle it, but must be fixed ASAP */
    EALogLevelCritical,
    /** Error events/mesages that don't lead to app crash and can be handled by application. */
    EALogLevelError,
    /** Warnings about data inconsystency, wrong flow that is safely handled or ignored by application */
    EALogLevelWarning,
    /** Debug messages without debug information attached */
    EALogLevelInfo,
    /** Debug messages with some debug information attached. Debug could print user sensitive information, so Info level restricts this */
    EALogLevelDebug,
    /** Trace application flow, routines, etc*/
    EALogLevelTrace
};

typedef NS_ENUM(NSUInteger, EALogLevelCheckingPolicy)
{
    EALogLevelCheckingPolicyNone,           // Ignores log level
    EALogLevelCheckingPolicyYESNO,          // EALogLevelNone turns logging off, other values on
    EALogLevelCheckingPolicyLeveled         // Takes into account logging level
};


/** Level logging base class by default initialized with EALogLevelNone and EALogLevelCheckingPolicyLeveled */
@interface EALevelLogger : NSObject<EALogger>

@property (nonatomic, assign) EALogLevel logLevel;
@property (nonatomic, assign) EALogLevelCheckingPolicy logLevelCheckingPolicy;

-(instancetype)initWithLogLevel:(EALogLevel)logLevel logLevelCheckingPolicy:(EALogLevelCheckingPolicy)logLevelCheckingPolicy;

/** According to logging level and checking policy decides if message with logLevel should be logged */
-(BOOL)shouldLogWithLogLevel:(EALogLevel)logLevel;

@end

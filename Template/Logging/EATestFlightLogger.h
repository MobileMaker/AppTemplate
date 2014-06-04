//
//  EATestFlightLogger.h
//  Template
//
//  Created by Maker on 01/06/14.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EALogger.h"

@interface EATestFlightLogger : NSObject<EALogger>

-(instancetype)initWithParameters:(NSDictionary*)params;

@end

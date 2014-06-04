//
//  EAUtils.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EAUtils: NSObject

+(BOOL)validateEmail:(NSString*)candidate;
+(BOOL)validateNameField:(NSString*)candidate;
+(BOOL)isiPhone5;
+(NSString*)timeToString:(NSTimeInterval)time;
+(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
+(UIImage*)imageWithView:(UIView *)view;

@end

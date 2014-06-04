//
//  EAUtils.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "EAUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation EAUtils

+(BOOL)validateEmail:(NSString*)candidate
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+(BOOL)validateNameField:(NSString*)candidate
{
    NSString* nameFieldRegex = @"^([a-zA-ZА-Яа-я ]+)$";
    NSPredicate* nameFieldTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameFieldRegex];
    
    return [nameFieldTest evaluateWithObject:candidate];
}

+(BOOL)isiPhone5
{
    return ([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO;
}

+(NSString*)timeToString:(NSTimeInterval)time
{
    // Round to NSInteger for modulo operation
    NSInteger remainingTime = round(time);
    return [NSString stringWithFormat:@"%02li:%02li",
                               (long)(remainingTime / 60), // Minutes
                               (long)(remainingTime % 60)]; // Seconds
}

+(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate* fromDate = nil;
    NSDate* toDate = nil;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate:toDateTime];
    
    NSDateComponents* difference = [calendar components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

/** Takes a screenshot of a UIView into a UIImage and returns it */
+(UIImage*)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end

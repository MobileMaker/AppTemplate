//
//  UIColor+EAAddition.h
//  Template
//
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (EAAddition)

+(UIColor*)colorWithRGBA:(NSUInteger)rgbaColorValue;
+(UIColor*)colorWithRGB:(NSUInteger)rgbColorValue;
+(UIColor*)randomColor;
+(UIColor*)colorWithHexString:(NSString*)hexString;

@end

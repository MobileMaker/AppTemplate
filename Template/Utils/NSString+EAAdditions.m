//
//  NSString+EAAdditions.h
//  Template
//
//  Created by Maker on 12.05.13.
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "NSString+EAAdditions.h"

@implementation NSString (WWAdditions)

- (NSDictionary *)parseAsQueryString
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:16];
    NSArray* pairs = [self componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs)
    {
        NSArray* elements = [pair componentsSeparatedByString:@"="];
        NSString* key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [dict setObject:val forKey:key];
    }
    return dict;
}

@end

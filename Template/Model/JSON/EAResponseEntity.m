//
//  EAResponseEntity.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "EAResponseEntity.h"

static NSString* kResponseSuccessKey            = @"response.success";
static NSString* kResponseMessageKey            = @"response.message";


@implementation EAResponseEntity

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.success forKey:kResponseSuccessKey];
    [aCoder encodeObject:self.message forKey:kResponseMessageKey];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.success = [aDecoder decodeObjectForKey:kResponseSuccessKey];
        self.message = [aDecoder decodeObjectForKey:kResponseMessageKey];
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    EAResponseEntity* copy = [[[self class] allocWithZone:zone] init];
    
    if (copy)
    {
        [copy setSuccess:self.success];
        [copy setMessage:self.message];
    }
    
    return copy;
}

- (BOOL)isEqual:(id)anObject
{
    if (![anObject isKindOfClass:[EAResponseEntity class]]) return NO;
    
    EAResponseEntity* otherObj = (EAResponseEntity*)anObject;
    return [self.success isEqualToString:otherObj.success] && [self.message isEqualToString:otherObj.message];
}

@end

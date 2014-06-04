//
//  EAPair.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "EAPair.h"

@implementation EAPair

+(instancetype)pairWithFirstObj:(id)firstObj andSecondObj:(id)secondObj
{
    return [[EAPair alloc] initWithFirstObj:firstObj andSecondObj:secondObj];
}

-(instancetype)initWithFirstObj:(id)firstObj andSecondObj:(id)secondObj
{
    if (self = [super init])
    {
        self.first = firstObj;
        self.second = secondObj;
    }
    return self;
}

@end

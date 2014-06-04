//
//  EATriple.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "EATriple.h"

@implementation EATriple

+(instancetype)tripleWithFirstObj:(id)firstObj andSecondObj:(id)secondObj andThirdObj:(id)thirdObj
{
    return [[EATriple alloc] initWithFirstObj:firstObj andSecondObj:secondObj andThirdObj:thirdObj];
}

-(instancetype)initWithFirstObj:(id)firstObj andSecondObj:(id)secondObj andThirdObj:(id)thirdObj
{
    if (self = [super init])
    {
        self.first = firstObj;
        self.second = secondObj;
        self.third = thirdObj;
    }
    return self;
}

@end

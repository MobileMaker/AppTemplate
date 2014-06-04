//
//  EATriple.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Holds triple of objects */
@interface EATriple : NSObject

@property (nonatomic, strong) id first;
@property (nonatomic, strong) id second;
@property (nonatomic, strong) id third;

/** Constructor for triple of objects
 @param firstObj        First object
 @param secondObj       Second object
 @param thirdObj        Third object
 */
+(instancetype)tripleWithFirstObj:(id)firstObj andSecondObj:(id)secondObj andThirdObj:(id)thirdObj;

/** Constructor for triple of objects
 @param firstObj        First object
 @param secondObj       Second object
 @param thirdObj        Third object
 */
-(instancetype)initWithFirstObj:(id)firstObj andSecondObj:(id)secondObj andThirdObj:(id)thirdObj;

@end

//
//  EAPair.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Holds pair of objects */
@interface EAPair : NSObject

@property (nonatomic, strong) id first;
@property (nonatomic, strong) id second;

/** Constructor for pair of objects
 @param firstObj        First object
 @param secondObj       Second object
 */
+(instancetype)pairWithFirstObj:(id)firstObj andSecondObj:(id)secondObj;

/** Constructor for pair of objects 
 @param firstObj        First object
 @param secondObj       Second object
 */
-(instancetype)initWithFirstObj:(id)firstObj andSecondObj:(id)secondObj;

@end

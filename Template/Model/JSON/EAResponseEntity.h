//
//  EAResponseEntity.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAResponseEntity : NSObject <NSCopying, NSCoding>

@property (nonatomic, copy) NSString* message;
@property (nonatomic, copy) NSString* success;

@end
//
//  EAProtocolUtils.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.

/** Protocol helpers */
@interface EAProtocolUtils : NSObject

/** Translate protocol error code to readable name */
+(NSString*)protocolErrorToString:(NSInteger)error;

@end
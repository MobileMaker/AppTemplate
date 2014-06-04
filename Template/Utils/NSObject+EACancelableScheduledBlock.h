//
//  NSObject+EACancelableScheduledBlock.h
//  Template
//
//  Created by Maker.
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (EACancelableScheduledBlock)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay cancelPreviousRequest:(BOOL)cancel;
- (void)performBlockInMainThread:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
- (void)performBlockInMainThread:(void (^)(void))block afterDelay:(NSTimeInterval)delay cancelPreviousRequest:(BOOL)cancel;
- (void)cancelScheduledBlocks;

@end

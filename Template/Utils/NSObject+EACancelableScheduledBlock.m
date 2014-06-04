//
//  NSObject+EACancelableScheduledBlock.h
//  Template
//
//  Created by Maker.
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "NSObject+EACancelableScheduledBlock.h"

@implementation NSObject (EACancelableScheduledBlock)

- (void)delayedAddOperation:(NSOperation *)operation
{
    [[NSOperationQueue currentQueue] addOperation:operation];
}

- (void)delayedAddMainQueueOperation:(NSOperation *)operation
{
    [[NSOperationQueue mainQueue] addOperation:operation];
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(delayedAddOperation:)
               withObject:[NSBlockOperation blockOperationWithBlock:block]
               afterDelay:delay];
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay cancelPreviousRequest:(BOOL)cancel
{
    if (cancel)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    [self performBlock:block afterDelay:delay];
}

- (void)performBlockInMainThread:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    [self performSelector:@selector(delayedAddMainQueueOperation:)
               withObject:[NSBlockOperation blockOperationWithBlock:block]
               afterDelay:delay];
}

- (void)performBlockInMainThread:(void (^)(void))block afterDelay:(NSTimeInterval)delay cancelPreviousRequest:(BOOL)cancel
{
    if (cancel)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
    [self performBlockInMainThread:block afterDelay:delay];
}

- (void)cancelScheduledBlocks
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end

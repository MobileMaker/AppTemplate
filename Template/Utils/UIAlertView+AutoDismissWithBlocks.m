//
//  UIAlertView+AutoDismissWithBlocks.m
//  Template
//
//  Created by Maker.
//  Copyright (c) 2014. All rights reserved.
//

#import "UIAlertView+AutoDismissWithBlocks.h"
#import <objc/runtime.h>


static char const UIAlertViewOriginalDelegateKey;
static char const UIAlertViewClickedBlockKey;
static char const UIAlertViewWillPresentBlockKey;
static char const UIAlertViewDidPresentBlockKey;
static char const UIAlertViewWillDismissBlockKey;
static char const UIAlertViewDidDismissBlockKey;
static char const UIAlertViewCancelBlockKey;
static char const UIAlertViewShouldEnableFirstOtherButtonBlockKey;
static char const UIAlertViewDismissNotificationNameKey;
static char const UIAlertViewAlertHolderKey;



@implementation UIAlertView (AutoDismissWithBlocks)

+(instancetype)showWithTitle:(NSString*)title
                     message:(NSString*)message
                       style:(UIAlertViewStyle)style
           cancelButtonTitle:(NSString*)cancelButtonTitle
           otherButtonTitles:(NSArray*)otherButtonTitles
                clickedBlock:(UIAlertViewCompletionBlock)clickedBlock
     dismissNotificationName:(NSString*)dismissNotificationName
{
    UIAlertView* alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:cancelButtonTitle
                                       otherButtonTitles:nil];
    
    alertView.alertViewStyle = style;
    alertView.dismissNotificationName = dismissNotificationName;
    
    // Add buttons
    for (NSString* buttonTitle in otherButtonTitles)
    {
        [alertView addButtonWithTitle:buttonTitle];
    }
    
    if (clickedBlock)
    {
        alertView.clickedButtonBlock = clickedBlock;
    }
    
    // Dismiss all others alert views
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDismissAlertViews object:nil];
    
    if (dismissNotificationName)
    {
        [[NSNotificationCenter defaultCenter] addObserver:alertView
                                                 selector:@selector(onNotification:)
                                                     name:dismissNotificationName
                                                   object:nil];
    }

    
    [alertView show];
    
    return alertView;
}

+(instancetype)showWithTitle:(NSString*)title
                     message:(NSString*)message
                       style:(UIAlertViewStyle)style
           cancelButtonTitle:(NSString*)cancelButtonTitle
           otherButtonTitles:(NSArray*)otherButtonTitles
                clickedBlock:(UIAlertViewCompletionBlock)clickedBlock
{
    return [UIAlertView showWithTitle:title
                              message:message
                                style:style
                    cancelButtonTitle:cancelButtonTitle
                    otherButtonTitles:otherButtonTitles
                         clickedBlock:clickedBlock
              dismissNotificationName:nil];
}

+(instancetype)showWithTitle:(NSString *)title
                     message:(NSString *)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
                clickedBlock:(UIAlertViewCompletionBlock)clickedBlock
     dismissNotificationName:(NSString*)dismissNotificationName
{
    return [UIAlertView showWithTitle:title
                              message:message
                                style:UIAlertViewStyleDefault
                    cancelButtonTitle:cancelButtonTitle
                    otherButtonTitles:otherButtonTitles
                         clickedBlock:clickedBlock
              dismissNotificationName:dismissNotificationName];
}

+(instancetype)showWithTitle:(NSString *)title
                     message:(NSString *)message
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSArray *)otherButtonTitles
                clickedBlock:(UIAlertViewCompletionBlock)clickedBlock
{
    return [UIAlertView showWithTitle:title
                              message:message
                                style:UIAlertViewStyleDefault
                    cancelButtonTitle:cancelButtonTitle
                    otherButtonTitles:otherButtonTitles
                         clickedBlock:clickedBlock
              dismissNotificationName:nil];
}



+(instancetype)showWithTitle:(NSString*)title
                     message:(NSString*)message
                    delegate:(id)delegate
                       style:(UIAlertViewStyle)style
     dismissNotificationName:(NSString*)dismissNotificationName
           cancelButtonTitle:(NSString*)cancelButtonTitle
           otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list args;
    va_start(args, otherButtonTitles);
    
    NSMutableArray* buttonTitles = [NSMutableArray arrayWithCapacity:2];
    for (NSString* anOtherButtonTitle = otherButtonTitles; anOtherButtonTitle != nil; anOtherButtonTitle = va_arg(args, NSString *))
    {
        [buttonTitles addObject:anOtherButtonTitle];
    }
    
    UIAlertView* alertView = [UIAlertView showWithTitle:title
                                                message:message
                                                  style:style
                                      cancelButtonTitle:cancelButtonTitle
                                      otherButtonTitles:buttonTitles
                                           clickedBlock:nil
                                dismissNotificationName:dismissNotificationName];
    
    alertView.delegate = delegate;
    [alertView _checkAlertViewDelegate];

    return alertView;
}

+(instancetype)showWithTitle:(NSString*)title
                     message:(NSString*)message
                    delegate:(id)delegate
     dismissNotificationName:(NSString*)dismissNotificationName
           cancelButtonTitle:(NSString*)cancelButtonTitle
           otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    return [UIAlertView showWithTitle:title
                              message:message
                             delegate:delegate
                                style:UIAlertViewStyleDefault
              dismissNotificationName:dismissNotificationName
                    cancelButtonTitle:cancelButtonTitle
                    otherButtonTitles:otherButtonTitles, nil];
}

+(instancetype)showWithTitle:(NSString*)title
                     message:(NSString*)message
                    delegate:(id)delegate
           cancelButtonTitle:(NSString*)cancelButtonTitle
           otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    return [UIAlertView showWithTitle:title
                              message:message
                             delegate:delegate
                                style:UIAlertViewStyleDefault
              dismissNotificationName:nil
                    cancelButtonTitle:cancelButtonTitle
                    otherButtonTitles:otherButtonTitles, nil];
}

#pragma mark - Properties

- (void)_checkAlertViewDelegate
{
    if (self.delegate != (id<UIAlertViewDelegate>)self)
    {
        objc_setAssociatedObject(self, &UIAlertViewOriginalDelegateKey, self.delegate, OBJC_ASSOCIATION_ASSIGN);
        self.delegate = (id<UIAlertViewDelegate>)self;
    }
}

- (UIAlertViewCompletionBlock)clickedButtonBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewClickedBlockKey);
}

- (void)setClickedButtonBlock:(UIAlertViewCompletionBlock)tapBlock
{
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, &UIAlertViewClickedBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewCompletionBlock)willDismissBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewWillDismissBlockKey);
}

- (void)setWillDismissBlock:(UIAlertViewCompletionBlock)willDismissBlock
{
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, &UIAlertViewWillDismissBlockKey, willDismissBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewCompletionBlock)didDismissBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewDidDismissBlockKey);
}

- (void)setDidDismissBlock:(UIAlertViewCompletionBlock)didDismissBlock
{
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, &UIAlertViewDidDismissBlockKey, didDismissBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewBlock)willPresentBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewWillPresentBlockKey);
}

- (void)setWillPresentBlock:(UIAlertViewBlock)willPresentBlock
{
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, &UIAlertViewWillPresentBlockKey, willPresentBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewBlock)didPresentBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewDidPresentBlockKey);
}

- (void)setDidPresentBlock:(UIAlertViewBlock)didPresentBlock
{
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, &UIAlertViewDidPresentBlockKey, didPresentBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewBlock)cancelBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewCancelBlockKey);
}

- (void)setCancelBlock:(UIAlertViewBlock)cancelBlock
{
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, &UIAlertViewCancelBlockKey, cancelBlock, OBJC_ASSOCIATION_COPY);
}

- (void)setShouldEnableFirstOtherButtonBlock:(UIAlertViewShouldEnableFirstOtherButtonBlock)shouldEnableFirstOtherButtonBlock
{
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, &UIAlertViewShouldEnableFirstOtherButtonBlockKey, shouldEnableFirstOtherButtonBlock, OBJC_ASSOCIATION_COPY);
}

- (UIAlertViewShouldEnableFirstOtherButtonBlock)shouldEnableFirstOtherButtonBlock
{
    return objc_getAssociatedObject(self, &UIAlertViewShouldEnableFirstOtherButtonBlockKey);
}

- (NSString*)dismissNotificationName
{
    return objc_getAssociatedObject(self, &UIAlertViewDismissNotificationNameKey);
}

- (void)setDismissNotificationName:(NSString*)dismissNotificationName
{
    [self _checkAlertViewDelegate];
    
    if (self.dismissNotificationName && dismissNotificationName)
        NSAssert(NO, @"Dismiss notification name already set.");
        
    objc_setAssociatedObject(self, &UIAlertViewDismissNotificationNameKey, dismissNotificationName, OBJC_ASSOCIATION_COPY);
}

- (id)alertHolder
{
    return objc_getAssociatedObject(self, &UIAlertViewAlertHolderKey);
}

- (void)setAlertHolder:(id)alertHolder
{
    [self _checkAlertViewDelegate];
    objc_setAssociatedObject(self, &UIAlertViewAlertHolderKey, alertHolder, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - UIAlertViewDelegate

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    UIAlertViewBlock block = alertView.willPresentBlock;
    
    if (block)
    {
        block(alertView);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, &UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(willPresentAlertView:)])
    {
        [originalDelegate willPresentAlertView:alertView];
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    UIAlertViewBlock block = alertView.didPresentBlock;
    
    if (block)
    {
        block(alertView);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, &UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(didPresentAlertView:)])
    {
        [originalDelegate didPresentAlertView:alertView];
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    UIAlertViewBlock block = alertView.cancelBlock;
    
    if (block)
    {
        block(alertView);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, &UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertViewCancel:)])
    {
        [originalDelegate alertViewCancel:alertView];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIAlertViewCompletionBlock completion = alertView.clickedButtonBlock;
    
    if (self.dismissNotificationName)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:self.dismissNotificationName object:nil];
    }
    
    self.dismissNotificationName = nil;
    
    if (completion)
    {
        completion(alertView, buttonIndex);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, &UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
    {
        [originalDelegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIAlertViewCompletionBlock completion = alertView.willDismissBlock;
    
    if (completion)
    {
        completion(alertView, buttonIndex);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, &UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:willDismissWithButtonIndex:)])
    {
        [originalDelegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIAlertViewCompletionBlock completion = alertView.didDismissBlock;
    
    if (completion)
    {
        completion(alertView, buttonIndex);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, &UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertView:didDismissWithButtonIndex:)])
    {
        [originalDelegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    BOOL(^shouldEnableFirstOtherButtonBlock)(UIAlertView *alertView) = alertView.shouldEnableFirstOtherButtonBlock;
    
    if (shouldEnableFirstOtherButtonBlock)
    {
        return shouldEnableFirstOtherButtonBlock(alertView);
    }
    
    id originalDelegate = objc_getAssociatedObject(self, &UIAlertViewOriginalDelegateKey);
    if (originalDelegate && [originalDelegate respondsToSelector:@selector(alertViewShouldEnableFirstOtherButton:)])
    {
        return [originalDelegate alertViewShouldEnableFirstOtherButton:alertView];
    }
    
    return YES;
}

#pragma mark - Notifications

-(void)onNotification:(NSNotification*)notification
{
    BOOL dismiss = YES;
    
    // If object specified then must dismiss only alert views for this object
    if (notification.object)
    {
        id holder = self.alertHolder;
        dismiss = (holder && holder == notification.object);
    }
    
    // Skip this alert, because asked for specific alerts to react
    if (!dismiss) return;
    
    if (self.dismissNotificationName)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:self.dismissNotificationName object:nil];
    }
    
    self.dismissNotificationName = nil;

    [self dismissWithClickedButtonIndex:[self cancelButtonIndex] animated:NO];
}

@end
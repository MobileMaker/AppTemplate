//
//  EAAutoDismissWithBlocks.h
//  Template
//
//  Created by Maker
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UIAlertViewBlock) (UIAlertView* alertView);
typedef void (^UIAlertViewCompletionBlock) (UIAlertView* alertView, NSInteger buttonIndex);
typedef BOOL (^UIAlertViewShouldEnableFirstOtherButtonBlock)(UIAlertView* alertView);

/** UIAlertView that automatically dismiss on notification
 @warning Never use delegate property and use only class methods to show this alert view
 */
@interface UIAlertView (Blocks)

/** Alert view without auto dismiss and with click block */
+(instancetype)showWithTitle:(NSString*)title
                      message:(NSString*)message
                        style:(UIAlertViewStyle)style
            cancelButtonTitle:(NSString*)cancelButtonTitle
            otherButtonTitles:(NSArray*)otherButtonTitles
                clickedBlock:(UIAlertViewCompletionBlock)clickedBlock;

/** Alert view without auto dismiss and with click block */
+(instancetype)showWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonTitles
                clickedBlock:(UIAlertViewCompletionBlock)clickedBlock;

/** Default initializer with auto dismiss */
+(instancetype)showWithTitle:(NSString*)title
                     message:(NSString*)message
                    delegate:(id)delegate
                       style:(UIAlertViewStyle)style
           cancelButtonTitle:(NSString*)cancelButtonTitle
           otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/** Default initializer with auto dismiss */
+(instancetype)showWithTitle:(NSString*)title
                     message:(NSString*)message
                    delegate:(id)delegate
           cancelButtonTitle:(NSString*)cancelButtonTitle
           otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


@property (nonatomic, copy) UIAlertViewCompletionBlock clickedButtonBlock;  // Called ONLY when user clicks on button
@property (nonatomic, copy) UIAlertViewCompletionBlock willDismissBlock;    // Called when view are going to dismiss after user clicked on button or dismissWithClickedButtonIndex called
@property (nonatomic, copy) UIAlertViewCompletionBlock didDismissBlock;     // Called when view are going to dismiss after user clicked on button or dismissWithClickedButtonIndex called

@property (nonatomic, copy) UIAlertViewBlock willPresentBlock;
@property (nonatomic, copy) UIAlertViewBlock didPresentBlock;
@property (nonatomic, copy) UIAlertViewBlock cancelBlock;

@property (nonatomic, copy) UIAlertViewShouldEnableFirstOtherButtonBlock shouldEnableFirstOtherButtonBlock;

@end


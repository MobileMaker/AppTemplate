//
//  NSArray+UITextField.h
//  Template
//
//  Created by Maker.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (UITextField)

- (UITextField*) activeTextField;
- (BOOL) checkForEmptyTextFieldAndBecomeFirstResponder;
- (UITextField*) textFieldByViewTag:(NSInteger) viewTag;
- (NSInteger) indexByViewTag:(NSInteger) viewTag;
- (void) resignAllTextFields;

@end

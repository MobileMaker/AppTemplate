//
//  NSArray+UITextField.m
//  Template
//
//  Created by Maker.
//  Copyright (c) 2014 Maker. All rights reserved.
//

#import "NSArray+UITextField.h"

@implementation NSArray (UITextField)

-(UITextField*)activeTextField
{
    NSEnumerator* enumerator = [self objectEnumerator];
    for (UITextField* txtField in enumerator)
        if ([txtField isFirstResponder])
            return txtField;
    
    return nil;
}

-(BOOL)checkForEmptyTextFieldAndBecomeFirstResponder
{
    NSEnumerator* enumerator = [self objectEnumerator];
    for (UITextField* txtField in enumerator)
        if (txtField.text == nil || txtField.text.length == 0)
        {
            [txtField becomeFirstResponder];
            return YES;
        }
    
    return NO;
}

-(UITextField*)textFieldByViewTag:(NSInteger)viewTag
{
    NSEnumerator* enumerator = [self objectEnumerator];
    for (UITextField* view in enumerator)
        if (view.tag == viewTag)
            return view;
    
    return nil;
}

-(NSInteger)indexByViewTag:(NSInteger)viewTag
{
    for (NSInteger index = 0; index < [self count]; index++)
    {
        UIView* view = (UIView*)[self objectAtIndex:index];
        if (view.tag == viewTag)
            return index;
    }
    
    return NSNotFound;
}

-(void)resignAllTextFields
{
    NSEnumerator* enumerator = [self objectEnumerator];
    for (UITextField* txtField in enumerator)
    {
        if ([txtField isFirstResponder])
        {
            [txtField resignFirstResponder];
            break;
        }
    }
}

@end

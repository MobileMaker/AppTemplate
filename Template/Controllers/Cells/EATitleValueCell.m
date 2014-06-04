//
//  EATitleValueCell.h
//  Template
//
//  Created by Maker
//  Copyright 2014. All rights reserved.
//

#import "EATitleValueCell.h"

@implementation EATitleValueCell

+(CGFloat)cellHeight
{
    return 44.0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setClipsToBounds:YES];
        
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectNull];
        [self.lblTitle setTextColor:[UIColor colorWithWhite:136.0/255.0 alpha:1.0]];
        [self.lblTitle setOpaque:YES];
        [self.lblTitle setTextAlignment:NSTextAlignmentLeft];
        [self.lblTitle setBackgroundColor:self.backgroundColor];
        [self.lblTitle setFont:[[EAFontManager shared] fontWithName:kFontAvenirLTRoman andSize:16.0]];
        [self.lblTitle setNumberOfLines:1];
        [self.contentView addSubview:self.lblTitle];
        [self.lblTitle alignLeadingEdgeWithView:self.contentView predicate:@"10.0"];
        [self.lblTitle alignTopEdgeWithView:self.contentView predicate:nil];
        [self.lblTitle alignBottomEdgeWithView:self.contentView predicate:nil];
        [self.lblTitle constrainWidth:@"120.0"];
        
        // Subscribe on properties
        [self addObserver:self forKeyPath:@"textField" options:NSKeyValueObservingOptionOld context:nil];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return self;
}

-(void)dealloc
{
    // Unsubscribe from properties
    [self removeObserver:self forKeyPath:@"textField"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"textField"])
    {
        UITextField* oldTextField = (UITextField*)[change objectForKey:NSKeyValueChangeOldKey];
        if (oldTextField != self.textField)
        {
            [self.textField setTextAlignment:NSTextAlignmentLeft];
            [self.textField setFont:[[EAFontManager shared] fontWithName:kFontAvenirLTMedium andSize:16.0]];
            [self.textField setTextColor:[UIColor colorWithWhite:136.0/255.0 alpha:1.0]];
            [self.textField setOpaque:YES];
            [self.textField setClearsOnBeginEditing:NO];
            [self.textField setBorderStyle:UITextBorderStyleNone];
            [self.textField setClearButtonMode:UITextFieldViewModeWhileEditing];
            [self.textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [self.textField setBackgroundColor:self.backgroundColor];
            
            if (self.textField.superview)
                [self.textField removeFromSuperview];
            if (oldTextField && [oldTextField isKindOfClass:[UITextField class]] && oldTextField.superview)
                [oldTextField removeFromSuperview];
            
            [self.contentView addSubview:self.textField];
            [self.textField alignTopEdgeWithView:self.contentView predicate:nil];
            [self.textField alignBottomEdgeWithView:self.contentView predicate:nil];
            [self.textField alignTrailingEdgeWithView:self.contentView predicate:@"-5.0"];
            [self.textField alignLeadingEdgeWithView:self.lblTitle predicate:@"125.0"];
        }
        
        [self setNeedsDisplay];
        [self setNeedsLayout];
    }
    else
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    // Don't touch text field because it set from outside
    [self.lblTitle setText:nil];
}

@end

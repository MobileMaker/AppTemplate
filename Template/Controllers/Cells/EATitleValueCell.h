//
//  EATitleValueCell.h
//  Template
//
//  Created by Maker
//  Copyright 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EATitleValueCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic, strong) UILabel* lblTitle;
@property (nonatomic, strong) UITextField* textField;

+(CGFloat)cellHeight;

@end

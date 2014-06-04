//
//  EALoginView.h
//  Template
//
//  Created by Maker
//  Copyright 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginCompletionBlock)(NSString* email, NSString* password);


@interface EALoginView: UIView

+(CGSize)viewSize;

-(instancetype)initWithEmail:(NSString*)email password:(NSString*)password completion:(LoginCompletionBlock)completion;

@end

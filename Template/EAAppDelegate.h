//
//  EAAppDelegate.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>


/** Application delegate */
@interface EAAppDelegate : UIResponder <UIApplicationDelegate>

@end




/** Configure application services */
@interface EAAppDelegate(ConfigureServices)

/** Configure whole application with services and frameworks from born to die */
-(void)initApplication;

/** Terminate all services before shutting down */
-(void)shutdownApplication;

@end

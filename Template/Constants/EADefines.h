//
//  EADefines.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

/** Define server release environment */
#define SERVER_MODE_RELEASE 1
/** Define server staging environment */
#define SERVER_MODE_STAGING 2
/** Define server live environment */
#define SERVER_MODE_LIVE 3

/** Define server mode as server environment. Default to live if not set before */
#ifndef SERVER_MODE
#define SERVER_MODE SERVER_MODE_LIVE
#endif

/** Removes view form parent and nil it */
#define REMOVE_AND_NULLIFY_VIEW(x) if (x) {[x removeFromSuperview]; x = nil;}

#if (SERVER_MODE != SERVER_MODE_LIVE)
    /** For non live version add additional checking for data and app flow consistency */
    #define CHECK_CONSISTENCY   1
#endif

/** Check for devices running 7.0 and above */
#define IS_DEVICE_RUNNING_IOS_7_AND_ABOVE() ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)

/** Check for devices running 6.0, 6.0.x, 6.1, 6.1.x */
#define IS_DEVICE_RUNNING_IOS_6_OR_BELOW() ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending)

/** Check for 4 inch screen resolution */
#define IS_IPHONE5_SCREEN ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 568.0))
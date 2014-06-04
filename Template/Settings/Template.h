//
//  Template.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EADeepLinking.h"


/** Holds application settings */
@interface Template: NSObject

/** Is first app start */
@property (nonatomic, assign, readonly) BOOL firstStart;
/** First application launch date
 * @warning First application launch date after install, so after reinstall will be different
 */
@property (nonatomic, strong, readonly) NSDate* firstStartDate;
/** Network online status */
@property (nonatomic, assign, readonly) BOOL isOnline;
/** Unique device identifier */
@property (nonatomic, copy, readonly) NSString* deviceUID;
/** Application launch options */
@property (nonatomic, strong) NSDictionary* applicationLaunchOptions;
/** Application deep linking parameters */
@property (nonatomic, strong) EADeepLinking* applicationDeepLinking;
/** Current application version */
@property (nonatomic, copy, readonly) NSString* applicationVersion;
/** Current application build number */
@property (nonatomic, strong, readonly) NSNumber* applicationBuild;
/** Check if application version was changed */
@property (nonatomic, assign, readonly) BOOL isApplicationUpdated;
/** Protocol sync time */
@property (nonatomic, strong, readonly) NSNumber* syncTime;
/** Logged in user name */
@property (nonatomic, copy) NSString* loggedInUserName;



/** Get singleton instance */
+(Template*)shared;

/** Update data from user defaults */
-(void)update;

/** Cleanup all holding resources before shutting down */
-(void)cleanup;

/** Flush changes to disk */
-(void)flush;

@end

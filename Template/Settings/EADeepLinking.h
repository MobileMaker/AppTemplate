//
//  EADeepLinking.h
//  Template
//
//  Created by Maker
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Deep linking object that system requested application to link with */
@interface EADeepLinking : NSObject

/** Deep linking URL */
@property (nonatomic, copy, readonly) NSString* URL;
/** Is deep linking was requested by application launch*/
@property (nonatomic, assign) BOOL asLaunchRequest;
/** Application that requested deep linking */
@property (nonatomic, copy, readonly) NSString* sourceApplication;
/** Broken to components URL part without scheme */
@property (nonatomic, strong, readonly) NSArray* pathComponents;
/** Broken to components URL parameters */
@property (nonatomic, strong, readonly) NSDictionary* params;

-(instancetype)initWithURL:(NSString*)url
             sourceApplication:(NSString*)sourceApplication
           asLaunchRequest:(BOOL)asLaunchRequest;

@end

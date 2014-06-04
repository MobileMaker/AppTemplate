//
//  EAResourceManager.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Use it to cache any application resource to minimize disk operations.
 * It loads resources from application bundle as binary data
 */
@interface EAResourceManager : NSObject

/** Singleton instance */
+(EAResourceManager*)shared;

/** Cleanup resources before terminating application. Save cached data, etc */
-(void)cleanup;

/** Request resource instance from manager
 @param resourceName        Bundle resource name
 @param resourceType        Bundle resource type (extention)
 @return Resource instance or nil
 */
-(NSData*)dataForResource:(NSString*)resourceName ofType:(NSString*)resourceType;

@end

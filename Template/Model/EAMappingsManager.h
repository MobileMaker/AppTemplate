//
//  EAMappingsManager.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>


/** Manages mapping settings for RestKit layer, ORM model
 *
 * Caches mappings for responses and instantiates on demand. Removes not used mappings on memory warnings
 */
@interface EAMappingsManager : NSObject

/** Singleton instance */
+(EAMappingsManager*)shared;

/** Cleanup resources before terminating application. Save cached data, etc */
-(void)cleanup;

/** Mapping for class 
 * @param cls           Class to get mappings for
 * @return Mappings for properties
 */
-(RKObjectMapping*)mappingsForClass:(Class)cls;

@end

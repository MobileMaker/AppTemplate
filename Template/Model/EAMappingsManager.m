//
//  EAMappingsManager.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "EAMappingsManager.h"

@interface EAMappingsManager()

@property (nonatomic, strong) NSMutableDictionary* mappings;
@property (nonatomic, strong) NSDictionary* mappingsInitializers;

@end


@implementation EAMappingsManager

+(EAMappingsManager*)shared
{
    static dispatch_once_t pred;
    static EAMappingsManager* sharedInstance = nil;
    
    // Instantiate singleton on first request
    dispatch_once(&pred, ^{
        sharedInstance = [[EAMappingsManager alloc] init];
    });
    
    return sharedInstance;
}

/** Initializes mappings manager with mapping initializers for supported classes */
-(instancetype)init
{
    if (self = [super init])
    {
        self.mappings = [NSMutableDictionary dictionaryWithCapacity:10];
        
        // Subscribe on memory warnings to optimize emmory management
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
        self.mappingsInitializers = @{NSStringFromClass([EAResponseEntity class]): NSStringFromSelector(@selector(initResponseEntityMappings))};
    }
    
    return self;
}

/** Clears cached mappings on memory warning */
-(void)handleMemoryWarning:(NSNotification *)notification
{
    // Remove all cached mappings
    [self.mappings removeAllObjects];
}

-(void)cleanup
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    self.mappings = nil;
}

/** Instantiates mappings on demand or uses cached instance 
 * 
 * Uses map table class -> mapping initializer to get initializer function and instantiate mapping. Configure available initializers in mappingsInitializers
 * @see mappingsInitializers
 */
-(void)initMappingsForClass:(NSString*)classString
{
    RKObjectMapping* mapping = (RKObjectMapping*)[self.mappings objectForKey:classString];
    if (!mapping)
    {
        DLog(@"Mappings for '%@' not found. Initialize mappings...", classString);
        NSString* selectorString = (NSString*)[self.mappingsInitializers objectForKey:classString];
        if (selectorString)
        {
            SEL initializer = NSSelectorFromString(selectorString);
            if ([self respondsToSelector:initializer])
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [self performSelector:initializer];
#pragma clang diagnostic pop
            else
                NSAssert(NO, @"Mappings initializer registered for class '%@' but not implemented", classString);
        }
        else
            NSAssert(NO, @"Mappings initializer not registered for class '%@'", classString);
    }
}

/** Initializes basic mappings for any response object 
 * @param responseEntityMappings        Object mapping to initialize with basic properties mappings
 */
-(void)initResponseEntityMappingsFor:(RKObjectMapping*)responseEntityMappings
{
    NSAssert(responseEntityMappings, @"Nil object mapping provided to initialize with basic mappings");

    [responseEntityMappings addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"Success" toKeyPath:@"success"]];
    [responseEntityMappings addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"Message" toKeyPath:@"message"]];
}

-(void)initResponseEntityMappings
{
    RKObjectMapping* reponseEntityMapping = [RKObjectMapping mappingForClass:[EAResponseEntity class]];
    
    [self initResponseEntityMappingsFor:reponseEntityMapping];
    
    [self addMappings:reponseEntityMapping];
}

-(void)initCitiesEntityMappings
{
    /*RKObjectMapping* cityEntityMapping = [RKObjectMapping mappingForClass:[JNCityEntity class]];
    [cityEntityMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"CityID" toKeyPath:@"cityId"]];
    [cityEntityMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"CityName" toKeyPath:@"cityName"]];
    [cityEntityMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"CityDescription" toKeyPath:@"cityDescription"]];
    [cityEntityMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"PercentComplete" toKeyPath:@"percentCompleted"]];
    
    RKObjectMapping* citiesEntityMapping = [RKObjectMapping mappingForClass:[JNCitiesEntity class]];
    [citiesEntityMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Response.Cities" toKeyPath:@"cities" withMapping:cityEntityMapping]];
    [citiesEntityMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"Response.TotalItemsCount" toKeyPath:@"totalItemsCount"]];
    
    [self initResponseEntityMappingsFor:citiesEntityMapping];
    
    [self addMappings:citiesEntityMapping];*/
}

/** Cache object mappings */
-(void)addMappings:(RKObjectMapping*)mapping
{
    [self.mappings setObject:mapping forKey:NSStringFromClass(mapping.objectClass)];
}

-(RKObjectMapping*)mappingsForClass:(Class)cls
{
    NSString* classString = NSStringFromClass(cls);
    
    // Lazy initialization
    [self initMappingsForClass:classString];
    
    RKObjectMapping* mapping = (RKObjectMapping*)[self.mappings objectForKey:classString];
    NSAssert(mapping, @"Mappings for class '%@' not available", classString);

    return mapping;
}

@end

//
//  EAResourceManager.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "EAResourceManager.h"
#import "Utils/EATriple.h"


/** Resource loading state. Prevent failed resource to load again */
typedef NS_ENUM(NSInteger, ResourceState)
{
    ResourceLoaded,
    ResourceFailed,
};


@interface EAResourceManager()

@property (atomic, strong) NSMutableDictionary* resources;

@end

@implementation EAResourceManager

/** Generate key for fonts cache */
+(NSString*)keyForResourceWithName:(NSString*)name andType:(NSString*)type
{
    return [NSString stringWithFormat:@"%@.%@", name, type];
}

+(EAResourceManager*)shared
{
    static dispatch_once_t pred;
    static EAResourceManager* sharedInstance = nil;
    
    // Instantiate singleton on first request
    dispatch_once(&pred, ^{
        sharedInstance = [[EAResourceManager alloc] init];
    });
    
    return sharedInstance;
}

-(id)init
{
    if (self = [super init])
    {
        self.resources = [NSMutableDictionary dictionaryWithCapacity:5];
        
        // Subscribe on memory warnings to optimize emmory management
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

-(void)dealloc
{
    NSAssert(NO, @"This function must not be called");
}

-(void)handleMemoryWarning:(NSNotification *)notification
{
    // Clear fonts cache
    [self.resources removeAllObjects];
}

-(void)cleanup
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    self.resources = nil;
}

-(NSData*)dataForResource:(NSString*)resourceName ofType:(NSString*)resourceType
{
    id resource = [self objectForResource:resourceName ofType:resourceType];
    
    return (NSData*)resource;
}

-(id)objectForResource:(NSString*)resourceName ofType:(NSString*)resourceType
{
    NSAssert(resourceName && resourceType, @"Nil font name argument");
    
    NSString* encodedResourceName = [EAResourceManager keyForResourceWithName:resourceName andType:resourceType];
    
    EATriple* triple = [self.resources objectForKey:encodedResourceName];
    
    if (triple)
    {
        switch (((NSNumber*)triple.second).integerValue)
        {
            case ResourceLoaded:
                return triple.third;
                
            case ResourceFailed:
                return nil;
                
            default:
                break;
        }
    }
    // Load resource
    else
    {
        NSString* path = [[NSBundle mainBundle] pathForResource:resourceName ofType:resourceType];
        NSData* data = path ? [NSData dataWithContentsOfFile:path] : nil;
        
        if (data)
            triple = [[EATriple alloc] initWithFirstObj:path andSecondObj:[NSNumber numberWithInteger:ResourceLoaded] andThirdObj:data];
        else
            // Mark resource as not loadable and don't try next time
            triple = [[EATriple alloc] initWithFirstObj:path andSecondObj:[NSNumber numberWithInteger:ResourceFailed] andThirdObj:nil];
        
        [self.resources setObject:triple forKey:encodedResourceName];
    }

    return triple.third;
}

@end

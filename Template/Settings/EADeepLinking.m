//
//  EADeepLinking.m
//  Template
//
//  Created by Maker.
//  Copyright (c) 2014. All rights reserved.
//

#import "EADeepLinking.h"
#import "Utils/NSString+EAAdditions.h"


@interface EADeepLinking()

@property (nonatomic, copy, readwrite) NSString* URL;
@property (nonatomic, copy, readwrite) NSString* sourceApplication;
@property (nonatomic, strong, readwrite) NSArray* pathComponents;
@property (nonatomic, strong, readwrite) NSDictionary* params;

@end

@implementation EADeepLinking

-(instancetype)initWithURL:(NSString*)url
         sourceApplication:(NSString*)sourceApplication
           asLaunchRequest:(BOOL)asLaunchRequest
{
    /*if (self  = [super init])
    {
        _sourceApplication = [sourceApplication copy];
        _asLaunchRequest = asLaunchRequest;
        _URL = [url copy];
        
        if (url)
        {
            // Seperate params and actually URL part
            NSArray* urlComponents = [url componentsSeparatedByString:@"?"];
            if (0 == urlComponents.count)
            {
                DLog(@"Ignoring deep linking via '%@' due to wrong URL structure", url);
                return self;
            }
            
            _pathComponents = [[(NSString*)[urlComponents objectAtIndex:0] pathComponents] mutableCopy];          // URL parts
            
            // Parse URL params
            if (urlComponents.count > 1)
            {
                _params = [(NSString*)[urlComponents objectAtIndex:1] parseAsQueryString];     // URL params
            }
            
            // Remove scheme information
            [(NSMutableArray*)_pathComponents removeObjectAtIndex:0];
        }
    }*/
    
    return self;
}

@end

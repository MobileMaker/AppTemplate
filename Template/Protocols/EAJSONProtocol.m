//
//  EAJSONProtocol.m
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import "EAJSONProtocol.h"
#import "Model/EAMappingsManager.h"

@interface EAJSONProtocol()

@property (nonatomic, strong) RKObjectManager* manager;
@property (atomic, copy) ProtocolResponseHandler responseHandler;

@end

@implementation EAJSONProtocol

-(instancetype)init
{
    if (self = [super init])
    {
        self.protocolTimeout = kAppRestShortQueryTimeout;
        self.queryParams = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

#pragma mark - Protocol specific

-(void)prepareProtocolHTTPParams
{
}

-(ProtocolId)protocolId
{
    NSLog(@"protocolId has to be defined!");
    abort();
}

-(NSString*)protocolResourcePath
{
    NSLog(@"protocolResourcePath has to be defined!");
    abort();
}

-(RKRequestMethod)protocolRequestMethod
{
    NSLog(@"protocolRequestMethod has to be defined!");
    abort();
}

-(Class)protocolResponseEntityClass
{
    NSLog(@"protocolResponseEntityClass has to be defined!");
    abort();
}

-(BOOL)protocolResponseIsObjectsCollection
{
    NSLog(@"protocolResponseIsObjectsCollection has to be defined!");
    abort();
}

-(NSArray*)protocolErrorsFromResponse:(id)responseObj
{
    /*if (!responseObj) return nil;
    
    EAResponseEntity* responseEntity = (EAResponseEntity*)responseObj;
    return responseEntity.errors ? (responseEntity.errors.count ? responseEntity.errors : nil) : nil;*/
    
    return nil;
}

#pragma mark - JSON Protocol

-(void)stop
{
    if (self.manager)
    {
        self.responseHandler = nil;
        //[self.manager cancelAllObjectRequestOperationsWithMethod:RKRequestMethodAny matchingPathPattern:nil];
        [self.manager.operationQueue cancelAllOperations];
    }
}

-(void)startWithCompletion:(ProtocolResponseHandler)handler
{
    /*NSAssert(handler, @"Missing JSON protocol handler");
    
    // Build API url 
    static NSString* serverURL = nil;
    if (!serverURL)
    {
        serverURL = [NSString stringWithFormat:@"%@%@", kServerAPI, kProtocolVersion];
    }
    
    self.responseHandler = handler;
    
    // Prepare protocol HTTP parameters
    [self prepareProtocolHTTPParams];
    
    NSAssert(serverURL, @"No server URL specified");
    
    //_manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:[serverURL stringByAppendingString:kServerRelativeAPI]]];
    _manager.HTTPClient.allowsInvalidSSLCertificate = YES;
    
    // Configure mappings for response object
    Class responseObjectClass = [self protocolResponseEntityClass];
    if (responseObjectClass)
    {
        RKObjectMapping* mappings = [[EAMappingsManager shared] mappingsForClass:responseObjectClass];
        if (mappings)
        {
            NSIndexSet* statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
            RKResponseDescriptor* descriptor = [RKResponseDescriptor responseDescriptorWithMapping:mappings
                                                                                            method:[self protocolRequestMethod]
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:statusCodes];
            
            // Add our descriptors to the manager
            [self.manager addResponseDescriptorsFromArray:[NSArray arrayWithObject:descriptor]];
        }
    }
    
    __block EAJSONProtocol* _self = self;
    
    void (^sucessBlock)(RKObjectRequestOperation*, RKMappingResult*) = ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
        DLog(@"%@", operation.targetObject);
        
        id object = [_self protocolResponseIsObjectsCollection] ? mappingResult.array : mappingResult.firstObject;
        
        // Check for protocol version
        NSArray* errors = [self protocolErrorsFromResponse:object];
        for (EAErrorEntity *error in errors)
        {
            if ([error.errorCode isEqualToString:kProtocolErrorIvalidProtocolVersion])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationInvalidVersionFound object:nil];
                return;
            }
        }
        
        if (_self.responseHandler)
        {
            _self.responseHandler(_self, EAResponseErrorOK, object);
            _self.responseHandler = nil;
        }
    };
    
    void (^failedBlock)(RKObjectRequestOperation*, NSError*) = ^(RKObjectRequestOperation* operation, NSError *error)
    {
        DLog(@"%@", error);
        
        if (!_self.responseHandler) return;
        
        EAProtocolError protocolError = EAResponseErrorData;
        
        NSLog(@"errorMessage: %@", [[error userInfo] objectForKey:RKObjectMapperErrorObjectsKey]);
        
        NSHTTPURLResponse* httpResponse = [[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey];
        NSInteger statusCode = [httpResponse statusCode];
        
        // Parse NSURL error
        if ([error.domain isEqualToString:NSURLErrorDomain])
        {
            switch (error.code)
            {
                case NSURLErrorCannotFindHost:
                case NSURLErrorCannotConnectToHost:
                case NSURLErrorNetworkConnectionLost:
                    protocolError = EAResponseErrorHostNotFound;
                    break;
                    
                case NSURLErrorNotConnectedToInternet:
                    protocolError = EAResponseErrorOffline;
                    break;
                    
                case NSURLErrorTimedOut:
                    protocolError = EAResponseErrorTimeout;
                    break;
                    
                default:
                    break;
            }
        }
        
        // Something wrong with data received or send to the server
        _self.responseHandler(_self, protocolError, nil);
        _self.responseHandler = nil;
    };
    
#warning Could print user sensitive data so must be turned off for distribution
#ifndef APPSTORE
    DLog(@"Query %@ with params:%@", [[self.manager.baseURL absoluteString] stringByAppendingString:[self protocolResourcePath]], self.queryParams);
#endif
    
    switch ([self protocolRequestMethod])
    {
        case RKRequestMethodPUT:
        case RKRequestMethodPOST:
        case RKRequestMethodDELETE:
        {
            // Compose the query
            NSMutableArray* queryString = [NSMutableArray arrayWithCapacity:self.queryStringParams.count];
            NSString* param;
            for (NSString* key in self.queryStringParams) {
                param = [NSString stringWithFormat:@"%@=%@", key, [self.queryStringParams objectForKey:key]];
                [queryString addObject:param];
            }
            
            NSString* path = [NSString stringWithFormat:@"%@?%@", [self protocolResourcePath], [queryString componentsJoinedByString:@"&"]];
            
            [self.manager postObject:nil
                                path:path
                          parameters:self.bodyParams
                             success:sucessBlock
                             failure:failedBlock];
        }
            break;
            
        case RKRequestMethodGET:
        {
            [self.manager getObjectsAtPath:[self protocolResourcePath]
                                parameters:self.queryStringParams
                                   success:sucessBlock
                                   failure:failedBlock];
        }
            break;
            
        default:
            
            break;
    }*/
}

@end

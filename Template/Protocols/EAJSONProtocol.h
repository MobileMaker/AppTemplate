//
//  EAJSONProtocol.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "EAProtocolConstants.h"
#import "EAProtocolUtils.h"


@class EAJSONProtocol;


/** Completion block for protocol 
 * @see EAMappingsManager
 * @see ProtocolId
 * @see EAProtocolError
 */
typedef void (^ProtocolResponseHandler)(EAJSONProtocol* proto, EAProtocolError responseError, id responseObject);


/** Base class for any network protocol. 
 *
 * Implements network part and mapping managements according to concrete protocol configuration. Defines what data must be sent, what HTTP
 * method to use, what data msut be received and entities to map it to. The magic does by RestKit - session automatically attached to request and saved on 
 * response to HTTP basic session handling mechanism, that can be accessed with available NS API
 *
 * @see EAMappingsManager
 * @see ProtocolId
 * @see EAProtocolError
 */
@interface EAJSONProtocol : NSObject

/** Protocol request timeout
 * @warning At the moment default RestKit value used because difficult to implement without subclassing
 */
@property(nonatomic, assign) NSTimeInterval protocolTimeout;
/** Protocol params*/
@property (nonatomic, strong) NSMutableDictionary* queryParams;


/** Starts protocol execution over network */
-(void)startWithCompletion:(ProtocolResponseHandler)handler;

/** Stops network protocol*/
-(void)stop;


/** Returns protocol identifier */
-(ProtocolId)protocolId;
/** Returns relative to base URL protocol resource path */
-(NSString*)protocolResourcePath;
/** Returns protocol HTTP request method */
-(RKRequestMethod)protocolRequestMethod;
/** Returns protocol response entity classb */
-(Class)protocolResponseEntityClass;
/** Is protocol response collection of objects */
-(BOOL)protocolResponseIsObjectsCollection;

@end

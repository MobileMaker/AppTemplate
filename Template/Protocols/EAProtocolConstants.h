//
//  EAProtocolConstants.h
//  Template
//
//  Created by Maker
//  email: maker@mail.ru, maker@gmail.com; skype: maker
//  Copyright (c) 2014. All rights reserved.
//

/** Network protocol identifier */
typedef NS_ENUM(NSInteger, ProtocolId)
{
    PutYourProtocolId
};

/** Protocol execution error */
typedef NS_ENUM(NSInteger, EAProtocolError)
{
    EAResponseErrorOK = 0,
    EAResponseErrorHostNotFound,
    EAResponseErrorTimeout,
    EAResponseErrorOffline,
    EAResponseErrorData,
    EAResponseErrorIncompleteRequestData,
};

static const NSUInteger kAppRestShortQueryTimeout = 10;
static const NSUInteger kAppRestLongQueryTimeout = 20;
static const NSUInteger kServerSyncTime = 5;

/** Protocol server API endpoint */
extern NSString* const kWebURL;
extern NSString* const kProtocolVersion;
extern NSString* const kServerAPI;

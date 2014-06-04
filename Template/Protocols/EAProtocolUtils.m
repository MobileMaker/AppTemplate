//
//  EAProtocolUtils.m
//  Template
//
//  Created by Maker
//  (email:maker@gmail.com, maker@mail.ru; skype:maker)
//  Copyright (c) 2014. All rights reserved.

#import "EAProtocolUtils.h"
#import "EAProtocolConstants.h"


@implementation EAProtocolUtils

+(NSString*)protocolErrorToString:(NSInteger)error
{
    switch (error)
    {
        case EAResponseErrorOK: return @"OK";
        case EAResponseErrorHostNotFound: return @"HostNotFound";
        case EAResponseErrorTimeout: return @"Timeout";
        case EAResponseErrorOffline: return @"Offline";
        case EAResponseErrorData: return @"DataError";
            
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"<Unknown code:%d>", error];
}

@end
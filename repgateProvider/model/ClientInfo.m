//
//  ClientInfo.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/11/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "ClientInfo.h"

@implementation ClientInfo

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self) {
        _ID = dictionary[@"ID"];
        _email = dictionary[@"email"];
        _displayName = dictionary[@"displayName"];
        _role = dictionary[@"role"];
        _userCode = dictionary[@"userCode"];
        _deviceId = dictionary[@"deviceId"];
        _deviceType = dictionary[@"deviceType"];
        _logoUrl = dictionary[@"logoUrl"];
        _birthday = dictionary[@"birthday"];
        _gender = dictionary[@"gender"];
        _phone = dictionary[@"phone"];
        _officeAddr = dictionary[@"officeAddr"];
        _company = dictionary[@"company"];
        _education = dictionary[@"education"];
        _certifications = dictionary[@"certifications"];
        _awards = dictionary[@"awards"];
        _requestSendAvailable = dictionary[@"requestSendAvailable"];
        _messageSendAvailable = dictionary[@"messageSendAvailable"];
        _messageNew = dictionary[@"messageNew"];
        _requestNew = dictionary[@"requestNew"];
    }
    
    return self;
}

- (NSDictionary*)toDictionary
{
    NSAssert(NO, @"not implemented");
    
    return nil;
}

@end

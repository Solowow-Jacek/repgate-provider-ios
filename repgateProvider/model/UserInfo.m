//
//  UserInfo.m
//  repgateProvider
//
//  Created by Helminen Sami on 2/27/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self) {
        _ID = dictionary[@"ID"];
        _email = dictionary[@"email"];
        _password = dictionary[@"password"];
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
        _pSpecialty = dictionary[@"pSpecialty"];
        _cSpecialty = dictionary[@"cSpecialty"];
        _education = dictionary[@"education"];
        _certifications = dictionary[@"certifications"];
        _awards = dictionary[@"awards"];
        _block_allow_message = dictionary[@"block_allow_message"];
        _block_allow_request = dictionary[@"block_allow_request"];
        _products = dictionary[@"products"];
        if (dictionary[@"area_of_interest"] != NULL)
            _area_of_interest = dictionary[@"area_of_interest"];
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

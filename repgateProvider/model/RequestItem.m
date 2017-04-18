//
//  RequestItem.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/7/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "RequestItem.h"

@implementation RequestItem

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self) {
        _ID = dictionary[@"ID"];
        _title = dictionary[@"title"];
        _senderId = dictionary[@"senderId"];
        _changerId = dictionary[@"changerId"];
        _senderName = dictionary[@"senderName"];
        _receiverId = dictionary[@"receiverId"];
        _receiverName = dictionary[@"receiverName"];
        _requestType = dictionary[@"requestType"];
        _requestDateTime = dictionary[@"requestDateTime"];
        _content = dictionary[@"content"];
        _handleStatus = dictionary[@"handleStatus"];
        _office_schedule = dictionary[@"office_schedule"];
        _createdAt = dictionary[@"createdAt"];
        _isNew = dictionary[@"isNew"];
        _senderImageUrl = dictionary[@"senderImageUrl"];
    }
    
    return self;
}

- (NSDictionary*)toDictionary
{
    NSAssert(NO, @"not implemented");
    
    return nil;
}

@end

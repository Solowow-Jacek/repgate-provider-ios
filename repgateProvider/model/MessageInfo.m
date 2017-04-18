//
//  MessageInfo.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/6/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "MessageInfo.h"

@implementation MessageInfo

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    
    if (self) {
        _ID = dictionary[@"ID"];
        _title = dictionary[@"title"];
        _senderId = dictionary[@"senderId"];
        _senderName = dictionary[@"senderName"];
        _receiverId = dictionary[@"receiverId"];
        _receiverName = dictionary[@"receiverName"];
        _attachs = dictionary[@"attachs"];
        _videoLink = dictionary[@"videoLink"];
        _content = dictionary[@"content"];
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

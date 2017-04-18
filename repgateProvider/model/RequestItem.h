//
//  RequestItem.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/7/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDictionalConvertTable.h"

@interface RequestItem : NSObject<VDictionalConvertTable>

@property(nonatomic,strong) NSString* ID;
@property(nonatomic,strong) NSString* title;
@property(nonatomic,strong) NSString* content;
@property(nonatomic,strong) NSString* senderId;
@property(nonatomic,strong) NSString* changerId;
@property(nonatomic,strong) NSString* senderName;
@property(nonatomic,strong) NSString* receiverId;
@property(nonatomic,strong) NSString* receiverName;
@property(nonatomic,strong) NSNumber* requestType;
@property(nonatomic,strong) NSString* requestDateTime;
@property(nonatomic,strong) NSNumber* handleStatus;
@property(nonatomic,strong) NSString* createdAt;
@property(nonatomic,strong) NSNumber* isNew;
@property(nonatomic,strong) NSNumber* office_schedule;
@property(nonatomic,strong) NSString* senderImageUrl;

@end

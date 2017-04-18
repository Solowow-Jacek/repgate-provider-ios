//
//  MessageInfo.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/6/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDictionalConvertTable.h"

@interface MessageInfo : NSObject<VDictionalConvertTable>

@property(nonatomic,strong) NSString* ID;
@property(nonatomic,strong) NSString* title;
@property(nonatomic,strong) NSString* senderId;
@property(nonatomic,strong) NSString* senderName;
@property(nonatomic,strong) NSString* receiverId;
@property(nonatomic,strong) NSString* receiverName;
@property(nonatomic,strong) NSString* attachs;
@property(nonatomic,strong) NSString* pdfLink;
@property(nonatomic,strong) NSString* videoLink;
@property(nonatomic,strong) NSString* productInfo;
@property(nonatomic,strong) NSString* content;
@property(nonatomic,strong) NSString* createdAt;
@property(nonatomic,strong) NSNumber* isNew;
@property(nonatomic,strong) NSString* senderImageUrl;
@property(nonatomic,strong) NSNumber* msgType;

@end

//
//  ClientInfo.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/11/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDictionalConvertTable.h"
@interface ClientInfo : NSObject<VDictionalConvertTable>

@property(nonatomic,strong) NSString* ID;
@property(nonatomic,strong) NSString* email;
@property(nonatomic,strong) NSString* displayName;
@property(nonatomic,strong) NSString* role;
@property(nonatomic,strong) NSString* userCode;
@property(nonatomic,strong) NSString* deviceId;
@property(nonatomic,strong) NSString* deviceType;
@property(nonatomic,strong) NSString* logoUrl;
@property(nonatomic,strong) NSString* birthday;
@property(nonatomic,strong) NSString* gender;
@property(nonatomic,strong) NSString* phone;
@property(nonatomic,strong) NSString* officeAddr;
@property(nonatomic,strong) NSString* company;
@property(nonatomic,strong) NSString* education;
@property(nonatomic,strong) NSString* certifications;
@property(nonatomic,strong) NSString* awards;
@property(nonatomic,strong) NSNumber* requestSendAvailable;
@property(nonatomic,strong) NSNumber* messageSendAvailable;
@property(nonatomic,strong) NSString* messageNew;
@property(nonatomic,strong) NSString* requestNew;

@end

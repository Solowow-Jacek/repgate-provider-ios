//
//  UserInfo.h
//  repgateProvider
//
//  Created by Helminen Sami on 2/27/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDictionalConvertTable.h"

@interface UserInfo : NSObject<VDictionalConvertTable>

@property(nonatomic,strong) NSNumber* ID;
@property(nonatomic,strong) NSString* email;
@property(nonatomic,strong) NSString* password;
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
@property(nonatomic,strong) NSString* pSpecialty;
@property(nonatomic,strong) NSString* cSpecialty;
@property(nonatomic,strong) NSString* education;
@property(nonatomic,strong) NSString* certifications;
@property(nonatomic,strong) NSString* awards;
@property(nonatomic,strong) NSString* block_allow_message;
@property(nonatomic,strong) NSString* block_allow_request;
@property(nonatomic,strong) NSString* products;
@property(nonatomic,strong) NSString* area_of_interest;
@property(nonatomic,strong) NSNumber* messageNew;
@property(nonatomic,strong) NSNumber* requestNew;

@end

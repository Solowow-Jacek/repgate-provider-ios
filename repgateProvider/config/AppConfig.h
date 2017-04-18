//
//  AppConfig.h
//  repgateProvider
//
//  Created by Helminen Sami on 2/27/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface AppConfig : NSObject

+ (void)setDeviceToken:(NSString *)token;
+ (NSString *)getDeviceToken;

+ (void)setEmail:(NSString *)email;
+ (NSString *)getEmail;

+ (void)setPassword:(NSString *)password;
+ (NSString *)getPassword;

+ (void)setRememberFlag:(NSNumber *)info;
+ (NSNumber *)getRememberFlag;

@end

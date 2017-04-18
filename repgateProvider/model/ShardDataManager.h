//
//  ShardDataManager.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/1/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface ShardDataManager : NSObject

+ (ShardDataManager *)sharedDataManager;

- (UserInfo*)getUserInfo;
- (void)saveUserInfo:(UserInfo *)info;
@end

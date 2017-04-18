//
//  ShardDataManager.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/1/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "ShardDataManager.h"

@interface ShardDataManager ()
@property(nonatomic, strong) UserInfo *mUserInfo;
@end

@implementation ShardDataManager

static ShardDataManager *mSharedDataManager;

+ (ShardDataManager *)sharedDataManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (mSharedDataManager==nil) {
            mSharedDataManager=[ShardDataManager new];
        }
    });
    return mSharedDataManager;
}

- (UserInfo*)getUserInfo {
    return self.mUserInfo;
}

- (void)saveUserInfo:(UserInfo *)info {
    [self.mUserInfo init];
    self.mUserInfo = info;
}

@end

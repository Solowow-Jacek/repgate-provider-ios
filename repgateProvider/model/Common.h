//
//  Common.h
//  Travel Maker
//
//  Created by developer on 12/8/15.
//  Copyright © 2015 developer. All rights reserved.
//

#ifndef Common_h
#define Common_h

#import <UIKit/UIKit.h>
#import "RootViewController.h"

#import "ResponseData.h"
#import "UserInfo.h"
#import "MessageInfo.h"
#import "RequestModel.h"
#import "RequestItem.h"
#import "SpecialtyInfo.h"
#import "RoundButton.h"
#import "CreateMessageViewController.h"

#define BASE_URL                     @"https://repgate.com/wp-json/wp/v2/"
#define FILE_STACK_API_KEY           @"AGDJJNUrnQF6A7ymIFHLCz"

//App Type
enum {
    APP_TYPE_HEATHCARE = 1,
    APP_TYPE_SALESREP,
};

//Device Type
enum {
    USER_DEVICE_TYPE_ANDROID = 1,
    USER_DEVICE_TYPE_IOS,
    USER_DEVICE_TYPE_PC,
};

//App Role
enum {
    USER_ROLE_UNDEFIND = 0,
    USER_ROLE_ADMIN,
    USER_ROLE_PHYSICIAN,
    USER_ROLE_PHYSICIAN_ASSISTANT,
    USER_ROLE_NURS,
    USER_ROLE_FONT_DESK,
    USER_ROLE_SALES_REP,
};

//Request Const Value
enum {
    REQUEST_LUNCH = 1,
    REQUEST_APPOINTMENT,
};

enum {
    REQUEST_ACTION_CONFIRM = 1,
    REQUEST_ACTION_CHANGE,
    REQUEST_ACTION_CANCEL,
};

/* ***************** Photo size relation *********************/
#define IMAGE_SIZE_VERY_SMALL       64.0
#define IMAGE_SIZE_SMALL            128.0
#define IMAGE_SIZE_NORMAL           256.0
#define IMAGE_SIZE_LARGE            512.0
#define IMAGE_SIZE_VERY_LARGE       1024.0

//Error Strings related to AFHTTPSession
#define login_api_msg_error    @"This service is not available now."
#define network_msg_error      @"Please make sure your internet connection."

@interface Common : NSObject

//Request Const Value
@property(strong, nonatomic) NSArray* reqStatusArray;
@property(strong, nonatomic) NSArray* reqTypeArray;
@property(strong, nonatomic) NSArray* reqActionArray;
//User info
@property(strong, nonatomic) NSArray* roleArray;

+ (Common *)sharedManager;
+ (BOOL)isEmptyString:(NSString *)string;
+ (NSMutableArray*) compareArray: (NSString *)key sortArray:(NSMutableArray*)sortArray;
+ (void)showAlert:(NSString *)title Message:(NSString *)message ButtonName:(NSString *)buttonname;

+ (BOOL)checkEmailValidation:(NSString *)email;
+ (BOOL)checkPasswordValidation:(NSString *)password;
+ (BOOL)checkPhoneValidation:(NSString *)phone;
+ (BOOL) validateEmail: (NSString *) candidate;
+ (BOOL) validateNumeric: (NSString *) candidate;
+ (BOOL) checkDateValidation:(NSString *) date;

+ (void) openUrlWithSafari:(NSString *) url;

+ (NSString *) getPrefInfo: (NSString *) key;
+ (void) setPrefInfo: (NSString *)key Value:(NSString *) value;
+ (void) removePrefInfo: (NSString *)key;

@end

#endif /* Common_h */

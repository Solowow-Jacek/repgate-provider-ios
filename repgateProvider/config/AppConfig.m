//
//  AppConfig.m
//  repgateProvider
//
//  Created by Helminen Sami on 2/27/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig

+ (void)setDeviceToken:(NSString *)token {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"DeviceToken"];
    [defaults synchronize];
}

+ (NSString *)getDeviceToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"DeviceToken"];
    return token;
}

+ (void)setEmail:(NSString *)email {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:email forKey:@"Email"];
    [defaults synchronize];
}

+ (NSString *)getEmail {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"Email"];
    return token;
}

+ (void)setPassword:(NSString *)password {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:password forKey:@"Password"];
    [defaults synchronize];
}

+ (NSString *)getPassword {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"Password"];
    return token;
}

+ (void)setRememberFlag:(NSNumber*)flag {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:flag forKey:@"RememberFlag"];
    [defaults synchronize];
}

+ (NSNumber *)getRememberFlag {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *flag = [defaults objectForKey:@"RememberFlag"];
    return flag;
}
@end

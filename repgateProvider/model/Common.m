//
//  Common.m
//  Travel Maker
//
//  Created by developer on 12/8/15.
//  Copyright © 2015 developer. All rights reserved.
//

#import "Common.h"

@implementation Common
@synthesize reqStatusArray;
@synthesize reqTypeArray;
@synthesize reqActionArray;

static Common *commonSharedManager;

+ (Common *)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (commonSharedManager==nil) {
            commonSharedManager=[Common new];
            commonSharedManager.reqStatusArray = [[NSArray alloc] initWithObjects:@"Initial", @"Confirmed", @"Changed", @"Canceled", nil];
            commonSharedManager.reqTypeArray = [[NSArray alloc] initWithObjects:@"Lunch", @"Appointment", nil];
            commonSharedManager.reqActionArray = [[NSArray alloc] initWithObjects:@"Initial", @"Confirm", @"Change", @"Cancel", nil];
            
            commonSharedManager.roleArray = [[NSArray alloc] initWithObjects:@"UNDEFINED", @"ADMINISTRATOR", @"PHYSICIAN", @"PHYSICIAN ASSISTANT",@"NURSE PRACTIONER", @"OFFICE MANAGER", @"SALES REP", nil];
        }
    });
    return commonSharedManager;
}

+ (BOOL)checkEmailValidation:(NSString *)email
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//+ (BOOL)checkPasswordValidation:(NSString *)password
//{
//    NSInteger length = [password length];
//    return length >= PASSWORD_MINENGTH? YES: NO;
//}
//
//+ (BOOL)checkPhoneValidation:(NSString *)phone
//{
//    NSInteger length = [phone length];
//    
//    if (length < CELLPHONE_MAXLENGTH)
//        return NO;
//    
//    return YES;
//}

+ (BOOL)isEmptyString:(NSString *)string
// Returns YES if the string is nil or equal to @""
{
    // Note that [string length] == 0 can be false when [string isEqualToString:@""] is true, because these are Unicode strings.
    
    if (((NSNull *) string == [NSNull null]) || (string == nil) ) {
        return YES;
    }
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

+(NSMutableArray*) compareArray: (NSString *)key sortArray:(NSMutableArray*)sortArray{
    
    NSMutableArray* sortedMuArray = NULL;
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [sortArray sortedArrayUsingDescriptors:sortDescriptors];
    
    sortedMuArray = (NSMutableArray *) sortedArray;
    
    return sortedMuArray;
}


+(void)showAlert:(NSString *)title Message:(NSString *)message ButtonName:(NSString *)buttonname
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:buttonname style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        //do something when click button
    }];
    [alert addAction:okAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
    
}

+(void) openUrlWithSafari:(NSString *) url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
}

+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL) validateNumeric: (NSString *) candidate {
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:candidate];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    return valid;
}

+ (BOOL) checkDateValidation:(NSString *) date
{
    if ([self validateNumeric:date] == NO) {
        return NO;
    }
    
    NSInteger length = [date length];
    if (length == 2) {
        return YES;
    }
    return NO;
}


+ (NSString *) getPrefInfo: (NSString *) key {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *value = [preferences objectForKey:key];
    return value;
}
+ (void) setPrefInfo: (NSString *)key Value:(NSString *) value {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setObject:value forKey:key];
    return;
}
+ (void) removePrefInfo: (NSString *)key{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences removeObjectForKey: key];
    return;
}

@end


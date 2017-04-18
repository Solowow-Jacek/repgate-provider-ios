//
//  LoginViewController.m
//  repgateProvider
//
//  Created by Helminen Sami on 2/27/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "LoginViewController.h"
#import "HTAutocompleteTextField.h"
#import "HTAutocompleteManager.h"
#import "RoundButton.h"
#import "TNRectangularCheckBoxData.h"
#import "BFPaperCheckbox.h"

@interface LoginViewController () <BFPaperCheckboxDelegate>
{
    BOOL m_isInitialized;
    NSString *deviceToken;
    UserInfo *userInfo;
}

@property (weak, nonatomic) IBOutlet HTAutocompleteTextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet RoundButton *btnSinin;
@property (weak, nonatomic) IBOutlet UIButton *btnResetPass;
@property (weak, nonatomic) IBOutlet BFPaperCheckbox *chkRemember;

@end

@implementation LoginViewController

@synthesize txtEmail, txtPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    deviceToken = [AppConfig getDeviceToken];
    // Do any additional setup after loading the view.
    
    [HTAutocompleteTextField setDefaultAutocompleteDataSource:[HTAutocompleteManager sharedManager]];
    
    NSNumber *flag = [AppConfig getRememberFlag];
    if ([flag integerValue] == 1) {
        txtEmail.text = [AppConfig getEmail];
        txtPassword.text = [AppConfig getPassword];
        [self.chkRemember checkAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!m_isInitialized) {
        NSNumber *flag = [AppConfig getRememberFlag];
        if ([flag integerValue] == 1) {
            txtEmail.text = [AppConfig getEmail];
            txtPassword.text = [AppConfig getPassword];
            [self.chkRemember checkAnimated:YES];
            [self onSignIn:nil];
            m_isInitialized = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onSignIn:(id)sender {
    NSString *errMsg = [self checkInputValidation];
    
    if ([errMsg isEqualToString:@""]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // fetch repos from web service
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:txtEmail.text forKey:@"email"];
        [params setObject:txtPassword.text forKey:@"password"];
//        [params setObject:@"111111" forKey:@"password"];
        [params setObject:deviceToken forKey:@"deviceId"];
        [params setObject:[NSString stringWithFormat:@"%d", USER_DEVICE_TYPE_IOS] forKey:@"deviceType"];
        [params setObject:[NSString stringWithFormat:@"%d", APP_TYPE_HEATHCARE] forKey:@"appType"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        NSLog(@"API_URL: %@", (BASE_URL @"signin"));
        
        [manager POST: (BASE_URL @"signin") parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"responseObject: %@", responseObject);
            ResponseData *result = [[ResponseData alloc] initWithDictionary:responseObject];
            
            if ([result.success boolValue] == YES) {
                NSLog(@"responseObject: %@", responseObject);
                UserInfo *info = [[UserInfo alloc] initWithDictionary:responseObject[@"data"]];
                if (self.chkRemember.isChecked) {
                    [AppConfig setEmail:txtEmail.text];
                    [AppConfig setPassword:txtPassword.text];
                    [AppConfig setRememberFlag:[NSNumber numberWithInt:1]];
                } else {
                    [AppConfig setRememberFlag:[NSNumber numberWithInt:0]];
                }
                
                [AppConfig setPassword:txtPassword.text];
                
                [[ShardDataManager sharedDataManager] saveUserInfo:info];
                
                [self performSegueWithIdentifier:@"gotoHomeSegue" sender:self];
            } else {
                NSDictionary *dic = responseObject[@"error"];
                NSString *err = dic[@"err_msg"];
                [Common showAlert:@"Error" Message:err ButtonName:@"OK"];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //here is place for code executed in error case
            [Common showAlert:@"Error" Message:network_msg_error ButtonName:@"OK"];
            NSLog(@"Error: %@", [error localizedDescription]);
        }];
    }
}

- (IBAction)onClickRem:(id)sender {
    if (self.chkRemember.isChecked) {
        [self.chkRemember uncheckAnimated:YES];
    } else {
        [self.chkRemember checkAnimated:YES];
    }
}

- (IBAction)onResetPassword:(id)sender {
}

- (NSString *)checkInputValidation {
    NSString *errMsg = @"";
    NSString *email = txtEmail.text;
    NSString *password = txtPassword.text;
    
    if ([email isEqualToString:@""] && [password isEqualToString:@""]) {
        errMsg = [errMsg stringByAppendingString:@"Please input email and password"];
    } else if ([email isEqualToString:@""]) {
        errMsg = [errMsg stringByAppendingString:@"Please input email"];
    } else if ([password isEqualToString:@""]) {
        errMsg = [errMsg stringByAppendingString:@"Please input password."];
    }
    
    return errMsg;
}
@end

//
//  MainViewController.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/1/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "MainViewController.h"
#import "VHBoomMenuButton.h"
#import "VHUtils.h"
#import "VHPiecePlaceEnum.h"
#import "VHButtonPlaceEnum.h"
#import "VHButtonPlaceAlignmentEnum.h"
#import "VHPiecePlaceManager.h"
#import "VHBoomEnum.h"
#import "CreateRequestViewController.h"
#import "LoginViewController.h"
#import "ScheduleViewController.h"

@interface MainViewController () <VHBoomDelegate>
{
    UserInfo *userInfo;
    NSString *deviceToken;
}

@property (weak, nonatomic) IBOutlet VHBoomMenuButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnUsers;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnRequest;
@property (weak, nonatomic) IBOutlet UIButton *btnTutorial;
@property (weak, nonatomic) IBOutlet UIButton *btnMissedMsgs;
@property (weak, nonatomic) IBOutlet UIButton *btnMissedReqs;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    deviceToken = [AppConfig getDeviceToken];
    userInfo = [[ShardDataManager sharedDataManager] getUserInfo];
    
    self.btnMissedMsgs.hidden = YES;
    self.btnMissedReqs.hidden = YES;
    [self setupMenu];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    userInfo = [[ShardDataManager sharedDataManager] getUserInfo];
//    
//    if ([userInfo.messageNew integerValue] > 0) {
//        [self.btnMissedMsgs setTitle:[userInfo.messageNew stringValue] forState:UIControlStateNormal];
//        self.btnMissedMsgs.hidden = NO;
//    } else {
//        self.btnMissedMsgs.hidden = YES;
//    }
//    
//    if ([userInfo.requestNew integerValue] > 0) {
//        [self.btnMissedReqs setTitle:[userInfo.requestNew stringValue] forState:UIControlStateNormal];
//        self.btnMissedReqs.hidden = NO;
//    } else {
//        self.btnMissedReqs.hidden = YES;
//    }
    
    [self reloadUserInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMenu {
    [self.btnMenu init];
    
    self.btnMenu.buttonEnum = VHButtonHam;
    self.btnMenu.piecePlaceEnum = VHPiecePlace_HAM_4;
    self.btnMenu.buttonPlaceEnum = VHButtonPlace_HAM_4;
    self.btnMenu.hamWidth = 0.1;
    self.btnMenu.hamHeight = 0.1;
    self.btnMenu.noBackground = YES;
    self.btnMenu.boomDelegate = self;
    
    [self.btnMenu addHamButtonBuilderBlock:^(VHHamButtonBuilder *builder) {
        builder.imageNormal = @"menu_icon_messege";
        builder.titleContent = @"Create Message";
        builder.titleNormalColor = [UIColor whiteColor];
        builder.buttonNormalColor = UIColorFromRGB(0x2196F3);
    }];
    [self.btnMenu addHamButtonBuilderBlock:^(VHHamButtonBuilder *builder) {
        builder.imageNormal = @"menu_icon_messege";
        builder.titleContent = @"Create Request";
        builder.titleNormalColor = [UIColor whiteColor];
        builder.buttonNormalColor = UIColorFromRGB(0x2196F3);
    }];
    [self.btnMenu addHamButtonBuilderBlock:^(VHHamButtonBuilder *builder) {
        builder.imageNormal = @"menu_icon_messege";
        builder.titleContent = @"Schedule";
        builder.titleNormalColor = [UIColor whiteColor];
        builder.buttonNormalColor = UIColorFromRGB(0x2196F3);
    }];
    [self.btnMenu addHamButtonBuilderBlock:^(VHHamButtonBuilder *builder) {
        builder.imageNormal = @"menu_icon_messege";
        builder.titleContent = @"Logout";
        builder.titleNormalColor = [UIColor whiteColor];
        builder.buttonNormalColor = [UIColor darkGrayColor];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//Rest API
- (void)reloadUserInfo {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // fetch repos from web service
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userInfo.email forKey:@"email"];
    [params setObject:[AppConfig getPassword] forKey:@"password"];
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
            userInfo = info;
            
            [[ShardDataManager sharedDataManager] saveUserInfo:userInfo];
            
            if ([userInfo.messageNew integerValue] > 0) {
                [self.btnMissedMsgs setTitle:[userInfo.messageNew stringValue] forState:UIControlStateNormal];
                self.btnMissedMsgs.hidden = NO;
            } else {
                self.btnMissedMsgs.hidden = YES;
            }
            
            if ([userInfo.requestNew integerValue] > 0) {
                [self.btnMissedReqs setTitle:[userInfo.requestNew stringValue] forState:UIControlStateNormal];
                self.btnMissedReqs.hidden = NO;
            } else {
                self.btnMissedReqs.hidden = YES;
            }
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

// #pragma mark - Boom Menu delegate
- (void)onBoomClicked:(int)index {
    switch (index) {
        case 0:
        {
            CreateMessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateMessageVcID"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            CreateRequestViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateRequestVcID"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            ScheduleViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ScheduleVcID"];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] ;
            alertView.alertViewStyle = UIAlertActionStyleDefault;
            [alertView show];
            break;
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    if (buttonIndex == 1) {
        [[ShardDataManager sharedDataManager] saveUserInfo:nil];
        [AppConfig setEmail:@""];
        [AppConfig setPassword:@""];
        [AppConfig setRememberFlag:[NSNumber numberWithInt:0]];
        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginVcID"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)onBoomBackgroundClicked {
}

- (void)onBoomWillHide {
}

- (void)onBoomDidHide {
}

- (void)onBoomWillShow {
}

- (void)onBoomDidShow {
}

- (IBAction)onClickUsers:(id)sender {
    [self performSegueWithIdentifier:@"gotoUsersSegue" sender:self];
}

- (IBAction)onClickProfile:(id)sender {
    [self performSegueWithIdentifier:@"gotoProfileSegue" sender:self];
}

- (IBAction)onClickMessages:(id)sender {
    [self performSegueWithIdentifier:@"gotoMyMessagesSegue" sender:self];
}

- (IBAction)onClickRequests:(id)sender {
    [self performSegueWithIdentifier:@"gotoMyRequestsSegue" sender:self];
}

- (IBAction)onClickTutorials:(id)sender {
}


@end

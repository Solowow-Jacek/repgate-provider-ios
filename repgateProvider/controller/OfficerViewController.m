//
//  OfficerViewController.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/11/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "OfficerViewController.h"
#import "NZCircularImageView.h"
#import "ClientInfo.h"
#import "VHBoomMenuButton.h"
#import "CreateRequestViewController.h"
#import "LoginViewController.h"
#import "ScheduleViewController.h"

@interface OfficerViewController () <VHBoomDelegate>
{
    UserInfo *userInfo;
    ClientInfo *officeInfo;
}

@property(strong, nonatomic) IBOutlet NZCircularImageView *imgAvatar;
@property(strong, nonatomic) IBOutlet UILabel *officeName;
@property(strong, nonatomic) IBOutlet UILabel *role;
@property(strong, nonatomic) IBOutlet UILabel *telephone;
@property(strong, nonatomic) IBOutlet UILabel *address;
@property(strong, nonatomic) IBOutlet RoundButton *sendMsg;
@property (weak, nonatomic) IBOutlet VHBoomMenuButton *btnMenu;

@end

@implementation OfficerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userInfo = [[ShardDataManager sharedDataManager] getUserInfo];
    [self loadOfficeInfo];
    
    [self setupMenu];
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

- (void)loadOfficeInfo {
    // fetch repos from web service
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userInfo.ID forKey:@"userId"];
    [params setObject:[NSString stringWithFormat:@"%d", USER_ROLE_FONT_DESK] forKey:@"role"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET: (BASE_URL @"getJoinedUsers") parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject: %@", responseObject);
        ResponseData *result = [[ResponseData alloc] initWithDictionary:responseObject];
        
        if ([result.success boolValue] == YES) {
            NSLog(@"responseObject: %@", responseObject);
            NSMutableArray *array = responseObject[@"data"];
            
            for (int i=0; i < array.count; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                
                officeInfo = [[ClientInfo alloc] initWithDictionary:dic];
            }
            
            if (officeInfo != nil) {
                if (![officeInfo.logoUrl isEqualToString:@""]) {
                    [_imgAvatar setImageWithResizeURL:officeInfo.logoUrl];
                }
                
                _officeName.text = officeInfo.displayName;
//                _role.text = officeInfo.role;
                _telephone.text = officeInfo.phone;
                _address.text = officeInfo.officeAddr;
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onClickMenu:(id)sender {
}
- (IBAction)onClickSendMsg:(id)sender {
    CreateMessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateMessageVcID"];
    vc.recvInfo = officeInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

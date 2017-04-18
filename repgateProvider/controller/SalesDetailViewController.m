//
//  SalesDetailViewController.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/11/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "SalesDetailViewController.h"
#import "Common.h"
#import "ClientInfo.h"
#import "NZCircularImageView.h"
#import "VHBoomMenuButton.h"
#import "CreateRequestViewController.h"
#import "LoginViewController.h"
#import "ScheduleViewController.h"

@interface SalesDetailViewController () <VHBoomDelegate>
{
    UserInfo *userInfo;
}

@property(strong, nonatomic) IBOutlet NZCircularImageView *imgAvatar;
@property(strong, nonatomic) IBOutlet UILabel *salesName;
@property(strong, nonatomic) IBOutlet UILabel *role;
@property(strong, nonatomic) IBOutlet UILabel *telephone;
@property(strong, nonatomic) IBOutlet UILabel *address;
@property(strong, nonatomic) IBOutlet UILabel *company;
@property(strong, nonatomic) IBOutlet RoundButton *sendMsg;
@property(strong, nonatomic) IBOutlet RoundButton *sendReq;
@property (weak, nonatomic) IBOutlet VHBoomMenuButton *btnMenu;

@end

@implementation SalesDetailViewController

@synthesize salesInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userInfo = [[ShardDataManager sharedDataManager] getUserInfo];
    
    if (salesInfo != nil) {
        if (![salesInfo.logoUrl isEqualToString:@""]) {
            [_imgAvatar setImageWithResizeURL:salesInfo.logoUrl];
        }
        
        _salesName.text = salesInfo.displayName;
        _telephone.text = salesInfo.phone;
        _address.text = salesInfo.officeAddr;
        _company.text = salesInfo.company;
    }
    
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickSendReq:(id)sender {
    CreateRequestViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateRequestVcID"];
    vc.recvInfo = salesInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onClickSendMsg:(id)sender {
    CreateMessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateMessageVcID"];
    vc.recvInfo = salesInfo;
    [self.navigationController pushViewController:vc animated:YES];
}



@end

//
//  MyRequestsViewController.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/6/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "MyRequestsViewController.h"
#import "AAPullToRefresh.h"
#import "FZAccordionTableView.h"
#import "RequestTableViewCell.h"
#import "RequestHeaderTableViewCell.h"
#import "YUTableView.h"
#include <stdlib.h>
#import "ShowRequestViewController.h"
#import "VHBoomMenuButton.h"
#import "CreateRequestViewController.h"
#import "LoginViewController.h"
#import "ScheduleViewController.h"

@interface MyRequestsViewController () <YUTableViewDelegate, VHBoomDelegate>
{
    AAPullToRefresh *topRefreshView;
    UserInfo *userInfo;
    NSMutableArray *reqArray;
    NSMutableArray *reqItemArray;
    NSIndexPath *currentIndex;
    RequestItem *currentReq;
}

@property (weak, nonatomic) IBOutlet YUTableView *tableView;
@property (nonatomic, strong) NSDictionary *tableProperties;
@property (weak, nonatomic) IBOutlet VHBoomMenuButton *btnMenu;

@end

@implementation MyRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setupMenu];
    
    userInfo = [[ShardDataManager sharedDataManager] getUserInfo];
    reqArray = [[NSMutableArray alloc] init];
    reqItemArray = [[NSMutableArray alloc] init];
    [self setTable];
    __weak typeof(self) weakSelf = self;
    topRefreshView = [self.tableView addPullToRefreshPosition:AAPullToRefreshPositionTop ActionHandler:^(AAPullToRefresh *v){
        [weakSelf reloadReqData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    topRefreshView.showPullToRefresh = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    topRefreshView.showPullToRefresh = NO;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [topRefreshView manuallyTriggered];
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

- (NSArray *)refreshTable {
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0; i < reqArray.count; i++)
    {
        RequestModel *reqSection = reqArray[i];
        YUTableViewItem *mainItem      = [[YUTableViewItem alloc] initWithData: [NSString stringWithFormat:@"%@", reqSection.date]];
        mainItem.cellIdentifier = @"RequestHeaderTableCell";
        NSMutableArray  *subItemList   = [NSMutableArray arrayWithCapacity:reqSection.reqs.count];
        
        for (int j = 0; j < reqSection.reqs.count; j++)
        {
            RequestItem *item = reqSection.reqs[j];
            YUTableViewItem * subItem       = [[YUTableViewItem alloc] initWithData: item];
//            YUTableViewItem * subItem       = [[YUTableViewItem alloc] init];
            subItem.cellIdentifier          = @"RequestTableCell";
            [subItemList addObject: subItem];
        }
        
        mainItem.subItems = subItemList;
        [array addObject: mainItem];
    }
    
    [_tableView setCellsFromArray:array cellIdentifier:@"RequestHeaderTableCell"];
    return array;
}

- (void)reloadReqData {
    // fetch repos from web service
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userInfo.ID forKey:@"userId"];
    [params setObject:@"0" forKey:@"officeSchedule"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET: (BASE_URL @"getAllRequests") parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject: %@", responseObject);
        ResponseData *result = [[ResponseData alloc] initWithDictionary:responseObject];
        
        if ([result.success boolValue] == YES) {
            NSLog(@"responseObject: %@", responseObject);
            NSMutableArray *array = responseObject[@"data"];
            
            [reqArray removeAllObjects];
            for (int i=0; i < array.count; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                
                RequestModel *req = [[RequestModel alloc] initWithDictionary:dic];
                [reqArray addObject:req];
            }
            
            [topRefreshView performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:0.1f];
            
            [self refreshTable];
            
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

- (void) setTable
{

    _tableView.showAllItems = YES;
    _tableView.scrollToTopWhenAnimationFinished = NO;
    _tableView.insertRowAnimation = UITableViewRowAnimationTop;
    _tableView.deleteRowAnimation = UITableViewRowAnimationTop;
    _tableView.userInteractionEnabledDuringAnimation = YES;
    _tableView.parentView = self;
    
    _tableView.competitionBlock                 = ^(void)
    {
        NSLog( @"Animation completed!");
    };
}

#pragma mark - YUTableViewDelegate

- (CGFloat)heightForItem:(YUTableViewItem *)item
{
    if ([item.cellIdentifier isEqualToString:@"RequestTableCell"])
        return 103;
    if ([item.cellIdentifier isEqualToString: @"RequestHeaderTableCell"])
        return 45;
    return _tableView.rowHeight;
}

- (void)didSelectedRow:(YUTableViewItem *)item
{
    NSString * msg;
    
    if ([item.cellIdentifier isEqualToString:@"RequestTableCell"]) {
        msg = ((RequestItem *)item.itemData).title;
        currentReq = (RequestItem *)item.itemData;
    } else {
        msg = item.itemData;
    }
    
    if (item.subItems.count == 0)
    {
        [self performSegueWithIdentifier:@"gotoShowRequestSegue" sender:self];
    }
    else
    {
        NSLog(@"%@ selected", msg);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoShowRequestSegue"]) {
        ShowRequestViewController *vc = [segue destinationViewController];
        vc.reqInfo = currentReq;
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickMenu:(id)sender {
}

@end

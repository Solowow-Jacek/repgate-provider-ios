//
//  MyMessagesViewController.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/3/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "MyMessagesViewController.h"
#import "MessageTableViewCell.h"
#import "ShowMessageViewController.h"
#import "VHBoomMenuButton.h"
#import "CreateRequestViewController.h"
#import "LoginViewController.h"
#import "ScheduleViewController.h"
#import "AAPullToRefresh.h"

@interface MyMessagesViewController () <UITableViewDataSource, UITableViewDelegate, VHBoomDelegate>
{
    AAPullToRefresh *topRefreshView;
    UserInfo *userInfo;
    NSMutableArray *msgArray;
    NSIndexPath *currentIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet VHBoomMenuButton *btnMenu;
@property (weak, nonatomic) IBOutlet UISegmentedControl *swtMsgType;

@end

@implementation MyMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userInfo = [[ShardDataManager sharedDataManager] getUserInfo];
    msgArray = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    topRefreshView = [self.tableView addPullToRefreshPosition:AAPullToRefreshPositionTop ActionHandler:^(AAPullToRefresh *v){
        [weakSelf refreshTable];
    }];
    
    [self setupMenu];
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

- (void)refreshTable {
    // fetch repos from web service
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userInfo.ID forKey:@"userId"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET: (BASE_URL @"getAllMessages") parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject: %@", responseObject);
        ResponseData *result = [[ResponseData alloc] initWithDictionary:responseObject];
        
        if ([result.success boolValue] == YES) {
            NSLog(@"responseObject: %@", responseObject);
            NSMutableArray *array = responseObject[@"data"];
            
            [msgArray removeAllObjects];
            for (int i=0; i < array.count; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                
                MessageInfo *msg = [[MessageInfo alloc] initWithDictionary:dic];
                switch (_swtMsgType.selectedSegmentIndex) {
                    case 0:
                    {
                        NSInteger recvId = [msg.receiverId integerValue];
                        NSInteger userId = [userInfo.ID integerValue];
                        if (recvId == userId)
                            [msgArray addObject:msg];
                        break;
                    }
                    case 1:
                    {
                        NSInteger recvId = [msg.senderId integerValue];
                        NSInteger userId = [userInfo.ID integerValue];
                        if (recvId == userId)
                            [msgArray addObject:msg];
                        break;
                    }
                        
                    default:
                        break;
                }
            }
            
            [topRefreshView performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:0.1f];
            [self.tableView reloadData];
        } else {
            NSDictionary *dic = responseObject[@"error"];
            NSString *err = dic[@"err_msg"];
            [Common showAlert:@"Error" Message:err ButtonName:@"OK"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [topRefreshView performSelector:@selector(stopIndicatorAnimation) withObject:nil afterDelay:0.1f];
        //here is place for code executed in error case
        [Common showAlert:@"Error" Message:network_msg_error ButtonName:@"OK"];
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msgArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageTableCell"];

    [cell setData:msgArray[indexPath.row]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [NewsFeedTableViewCell heightOfCell:feedArray[indexPath.row]];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    currentIndex = indexPath;
    [self performSegueWithIdentifier:@"showMessageSegue" sender:self];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMessageSegue"]) {
        ShowMessageViewController *vc = [segue destinationViewController];
        MessageInfo *msg = msgArray[currentIndex.row];
        vc.msgInfo = msg;
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onSelMsgType:(id)sender {
    [topRefreshView manuallyTriggered];
}

@end

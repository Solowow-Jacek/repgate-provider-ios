//
//  CreateRequestViewController.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/15/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "CreateRequestViewController.h"
#import "Common.h"
#import "MainViewController.h"
#import "NSDate+MDExtension.h"
#import "MDDatePickerDialog.h"
#import "NSDate+MDExtension.h"
#import "MDTimePickerDialog.h"

@interface CreateRequestViewController ()
{
    UserInfo *userInfo;
    NSString *dateTime;
    NSMutableArray *receiverArray;
    NIDropDown *dropDown;
    NSNumber *recvId;
}

@property (weak, nonatomic) IBOutlet UILabel *txtFrom;
@property (weak, nonatomic) IBOutlet UIButton *btnSelReceiver;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAppointment;
@property (weak, nonatomic) IBOutlet UIButton *btnLunch;
@property (weak, nonatomic) IBOutlet UILabel *txtDateTime;
@property (weak, nonatomic) IBOutlet UIButton *btnDateTimePicker;
@property (weak, nonatomic) IBOutlet UIButton *btnSendRequest;

@property(nonatomic) MDDatePickerDialog *datePicker;
@property(nonatomic) MDTimePickerDialog *timePicker;
@property(nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation CreateRequestViewController
@synthesize recvInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userInfo = [[ShardDataManager sharedDataManager] getUserInfo];
    _dateFormatter = [[NSDateFormatter alloc] init];
    receiverArray = [[NSMutableArray alloc] init];
    
    [_btnAppointment setBackgroundImage:[UIImage imageNamed:@"icon_appointment1.png"] forState:UIControlStateSelected];
    [_btnAppointment setBackgroundImage:[UIImage imageNamed:@"icon_appointment.png"] forState:UIControlStateNormal];
    [_btnLunch setBackgroundImage:[UIImage imageNamed:@"icon_lunch1.png"] forState:UIControlStateSelected];
    [_btnLunch setBackgroundImage:[UIImage imageNamed:@"icon_lunch.png"] forState:UIControlStateNormal];
    
    if (userInfo != nil) {
        _txtFrom.text = userInfo.displayName;
    }
    
    if (recvInfo != nil) {
        recvId = recvInfo.ID;
        NSString *title = recvInfo.displayName;
        [_btnSelReceiver setTitle:title forState:UIControlStateNormal];
    }
    
    [self loadClientInfo];
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

//Rest API
- (void)loadClientInfo {
    // fetch repos from web service
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userInfo.ID forKey:@"userId"];
    [params setObject:[NSString stringWithFormat:@"%d", USER_ROLE_SALES_REP] forKey:@"role"];
    
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
            
            [receiverArray removeAllObjects];
            for (int i=0; i < array.count; i++) {
                NSDictionary *dic = [array objectAtIndex:i];
                
                UserInfo *receiver = [[UserInfo alloc] initWithDictionary:dic];
                [receiverArray addObject:receiver];
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

- (void)NIDropDown:(NIDropDown *)niDropDown selectIndex:(NSInteger)index{
    
    /*----------------Get Selected Value[Multiple selection]-----------------*/
    recvId = ((UserInfo*)receiverArray[index]).ID;
    NSString *title = ((UserInfo*)receiverArray[index]).displayName;
    [_btnSelReceiver setTitle:title forState:UIControlStateNormal];
}

- (void)datePickerDialogDidSelectDate:(NSDate *)date {
    _dateFormatter.dateFormat = @"yyy-MM-dd";
    dateTime = [_dateFormatter stringFromDate:date];
    
    if (!_timePicker) {
        _timePicker = [[MDTimePickerDialog alloc] init];
        _timePicker.theme = MDTimePickerThemeLight;
        _timePicker.delegate = self;
    }
    [_timePicker show];
}

- (void)timePickerDialog:(MDTimePickerDialog *)timePickerDialog
           didSelectHour:(NSInteger)hour
               andMinute:(NSInteger)minute {
    long hr = (long)hour > 12 ? hour - 12 : hour;
    NSString *timeStr = (long)hour >= 12 ? @"pm " : @"am ";
    NSString *timeValue = [[NSString stringWithFormat:@"%.2li:%.2li ", hr, (long)minute] stringByAppendingString:timeStr];
    _txtDateTime.text = [timeValue stringByAppendingString:dateTime];
}

- (IBAction)onClickSelReceiver:(id)sender {
    if(dropDown == nil) {
        CGFloat f = 180;
        dropDown = [[NIDropDown alloc] showDropDown:sender :&f :receiverArray :@"down"];
        dropDown.delegate = self;
        dropDown.layer.zPosition = 1;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

- (IBAction)onClickAppointment:(id)sender {
    _btnAppointment.selected = YES;
    _btnLunch.selected = NO;
}

- (IBAction)onClickLunch:(id)sender {
    _btnAppointment.selected = NO;
    _btnLunch.selected = YES;
}

- (IBAction)onClickDateTime:(id)sender {
    if (!_datePicker) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.year = 2017;
        dateComponents.month = 1;
        dateComponents.day = 1;
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
        
        MDDatePickerDialog *datePicker = [[MDDatePickerDialog alloc] init];
        _datePicker = datePicker;
        _datePicker.minimumDate = date;
        _datePicker.selectedDate = date;
        _datePicker.delegate = self;
    }
    [_datePicker show];
}

- (IBAction)onClickSendRequest:(id)sender {
    if ([_txtTitle.text isEqualToString:@""]) {
        [Common showAlert:@"Error" Message:@"Please input request title" ButtonName:@"OK"];
        return;
    }
    if ([[recvId stringValue] isEqualToString:@""]) {
        [Common showAlert:@"Error" Message:@"Please input request receiver" ButtonName:@"OK"];
        return;
    }
    if ([_txtDateTime.text isEqualToString:@""]) {
        [Common showAlert:@"Error" Message:@"Please input request datetime" ButtonName:@"OK"];
        return;
    }
    
    NSNumber *reqType;
    if (_btnAppointment.isSelected) {
        reqType = [NSNumber numberWithInt:REQUEST_APPOINTMENT];
    } else {
        reqType = [NSNumber numberWithInt:REQUEST_LUNCH];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSString *createAt = [formatter stringFromDate:[NSDate date]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:_txtTitle.text forKey:@"title"];
    [params setObject:@"" forKey:@"content"];
    [params setObject:userInfo.ID forKey:@"senderId"];
    [params setObject:recvId forKey:@"receiverId"];
    [params setObject:reqType forKey:@"requestType"];
    [params setObject:_txtDateTime.text forKey:@"requestDateTime"];
    [params setObject:@"0" forKey:@"handleStatus"];
    [params setObject:createAt forKey:@"createAt"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST: (BASE_URL @"createRequest") parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"responseObject: %@", responseObject);
        ResponseData *result = [[ResponseData alloc] initWithDictionary:responseObject];
        
        if ([result.success boolValue] == YES) {
            NSLog(@"responseObject: %@", responseObject);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You sent successfully request to sales rep." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] ;
            alertView.alertViewStyle = UIAlertActionStyleDefault;
            [alertView show];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    if (buttonIndex == 0) {
        [self onBack:nil];
    }
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onClickLogo:(id)sender {
    MainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVcID"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

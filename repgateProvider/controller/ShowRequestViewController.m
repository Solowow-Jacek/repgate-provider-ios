//
//  ShowRequestViewController.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/15/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "ShowRequestViewController.h"
#import "NZCircularImageView.h"
#import "NSDate+MDExtension.h"
#import "MDDatePickerDialog.h"
#import "NSDate+MDExtension.h"
#import "MDTimePickerDialog.h"
#import "MainViewController.h"

@interface ShowRequestViewController ()
{
    UserInfo *userInfo;
    NSString *dateTime;
}

@property (weak, nonatomic) IBOutlet UILabel *txtTitle;
@property (weak, nonatomic) IBOutlet NZCircularImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *txtSenderName;
@property (weak, nonatomic) IBOutlet UIButton *btnAppoint;
@property (weak, nonatomic) IBOutlet UIButton *btnLunch;
@property (weak, nonatomic) IBOutlet UILabel *txtDateTime;
@property (weak, nonatomic) IBOutlet UIButton *btnCalendar;
@property (weak, nonatomic) IBOutlet UILabel *txtStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UIButton *btnChange;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@property(nonatomic) MDDatePickerDialog *datePicker;
@property(nonatomic) MDTimePickerDialog *timePicker;
@property(nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ShowRequestViewController
@synthesize reqInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userInfo = [[ShardDataManager sharedDataManager] getUserInfo];
    _dateFormatter = [[NSDateFormatter alloc] init];
    
    //Setup UI
    if (reqInfo != nil) {
        _txtTitle.text = reqInfo.title;
        
        if (![reqInfo.senderImageUrl isEqualToString:@""]) {
            [_imgAvatar setImageWithResizeURL:reqInfo.senderImageUrl];
        }
        
        if ([reqInfo.requestType integerValue] == REQUEST_APPOINTMENT) {
            [_btnAppoint setBackgroundImage:[UIImage imageNamed:@"icon_appointment1.png"] forState:UIControlStateNormal];
            [_btnLunch setBackgroundImage:[UIImage imageNamed:@"icon_lunch.png"] forState:UIControlStateNormal];
        } else {
            [_btnAppoint setBackgroundImage:[UIImage imageNamed:@"icon_appointment.png"] forState:UIControlStateNormal];
            [_btnLunch setBackgroundImage:[UIImage imageNamed:@"icon_lunch1.png"] forState:UIControlStateNormal];
        }
        
        _txtSenderName.text = reqInfo.senderName;
        _txtStatus.text = [Common sharedManager].reqStatusArray[[reqInfo.handleStatus integerValue]];
        _txtDateTime.text = reqInfo.requestDateTime;
        
        if ([reqInfo.isNew boolValue] == true)
            [self changeRequestReadStatus];
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

//Rest API
- (void)changeRequestReadStatus {
    // fetch repos from web service
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:reqInfo.ID forKey:@"reqId"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST: (BASE_URL @"readRequest") parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"responseObject: %@", responseObject);
        ResponseData *result = [[ResponseData alloc] initWithDictionary:responseObject];
        
        if ([result.success boolValue] == YES) {
            NSLog(@"responseObject: %@", responseObject);
            userInfo.requestNew = [NSNumber numberWithInteger:[userInfo.requestNew integerValue] - 1];
            [[ShardDataManager sharedDataManager] saveUserInfo:userInfo];
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

- (void)deleteRequest {
    // fetch repos from web service
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userInfo.ID forKey:@"userId"];
    [params setObject:reqInfo.ID forKey:@"reqId"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST: (BASE_URL @"deleteRequest") parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"responseObject: %@", responseObject);
        ResponseData *result = [[ResponseData alloc] initWithDictionary:responseObject];
        
        if ([result.success boolValue] == YES) {
            NSLog(@"responseObject: %@", responseObject);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your request has been deleted!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] ;
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

- (void)sendRequest:(NSNumber*)actionType {
    // fetch repos from web service
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:reqInfo.ID forKey:@"reqId"];
    [params setObject:actionType forKey:@"actionType"];
    [params setObject:_txtDateTime.text forKey:@"requestDateTime"];
    [params setObject:userInfo.ID forKey:@"userId"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST: (BASE_URL @"handleRequest") parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"responseObject: %@", responseObject);
        ResponseData *result = [[ResponseData alloc] initWithDictionary:responseObject];
        
        if ([result.success boolValue] == YES) {
            NSLog(@"responseObject: %@", responseObject);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your request has been sent!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] ;
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

//#pragma mark - DateTime Picker

- (void)datePickerDialogDidSelectDate:(NSDate *)date {
    _dateFormatter.dateFormat = @"yyy-MM-dd";
    dateTime = [_dateFormatter stringFromDate:date];
    
    if (!_timePicker) {
        NSMutableArray *dateArray = [NSMutableArray arrayWithArray:[reqInfo.requestDateTime componentsSeparatedByString:@" "]];
        NSMutableArray *dateArray1 = [NSMutableArray arrayWithArray:[(NSString*)dateArray[0] componentsSeparatedByString:@":"]];
        
        NSInteger hour = [dateArray1[0] integerValue];
        NSInteger min = [dateArray1[1] integerValue];
        if ([dateArray[1] isEqualToString:@"pm"]) {
            hour = hour + 12;
        }
        
        _timePicker = [[MDTimePickerDialog alloc] initWithHour:hour minute:min];
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickDelete:(id)sender {
    [self deleteRequest];
}

- (IBAction)onClickDateTime:(id)sender {
    if (!_datePicker) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        NSMutableArray *dateArray = [NSMutableArray arrayWithArray:[reqInfo.requestDateTime componentsSeparatedByString:@" "]];
        NSMutableArray *dateArray1 = [NSMutableArray arrayWithArray:[(NSString*)dateArray[2] componentsSeparatedByString:@"-"]];
        dateComponents.year = [dateArray1[0] integerValue];
        dateComponents.month = [dateArray1[1] integerValue];
        dateComponents.day = [dateArray1[2] integerValue];
        NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
        
        MDDatePickerDialog *datePicker = [[MDDatePickerDialog alloc] init];
        _datePicker = datePicker;
        _datePicker.minimumDate = date;
        _datePicker.selectedDate = date;
        _datePicker.delegate = self;
    }
    [_datePicker show];
}
- (IBAction)onSelAppointment:(id)sender {
//    _btnAppoint.selected = YES;
//    _btnLunch.selected = NO;
}
- (IBAction)onSelLunch:(id)sender {
//    _btnAppoint.selected = NO;
//    _btnLunch.selected = YES;
}
- (IBAction)onClickConfirm:(id)sender {
    [self sendRequest:[NSNumber numberWithInt:REQUEST_ACTION_CONFIRM]];
}
- (IBAction)onClickChange:(id)sender {
    [self sendRequest:[NSNumber numberWithInt:REQUEST_ACTION_CHANGE]];
}
- (IBAction)onClickCancel:(id)sender {
    [self sendRequest:[NSNumber numberWithInt:REQUEST_ACTION_CANCEL]];
}
- (IBAction)onClickLogo:(id)sender {
    MainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVcID"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

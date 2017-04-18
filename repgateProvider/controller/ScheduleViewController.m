//
//  ScheduleViewController.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/24/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "ScheduleViewController.h"
#import "VHBoomMenuButton.h"
#import "CreateRequestViewController.h"
#import "LoginViewController.h"
#import "CreateMessageViewController.h"
#import "ShowRequestViewController.h"

@interface ScheduleViewController ()
{
    UserInfo *userInfo;
    NSMutableArray *reqArray;
    NSMutableArray *reqItemArray;
    void * _KVOContext;
}

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet FSCalendar *calendarView;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UIPanGestureRecognizer *scopeGesture;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeight;
@property (weak, nonatomic) IBOutlet VHBoomMenuButton *btnMenu;

@property (strong, nonatomic) NSArray<NSString *> *datesShouldNotBeSelected;
@property (strong, nonatomic) NSArray<NSString *> *datesWithEvent;

@property (strong, nonatomic) NSCalendar *gregorianCalendar;

@property (strong, nonatomic) NSCalendar *lunarCalendar;
@property (strong, nonatomic) NSArray<NSString *> *lunarChars;

@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;

@property (assign, nonatomic) NSInteger      theme;
@property (assign, nonatomic) BOOL           lunar;

@end

@implementation ScheduleViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSLocale *chinese = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        
        self.dateFormatter1 = [[NSDateFormatter alloc] init];
//        self.dateFormatter1.locale = chinese;
        self.dateFormatter1.dateFormat = @"yyyy-MM-dd";
        
        self.dateFormatter2 = [[NSDateFormatter alloc] init];
//        self.dateFormatter2.locale = chinese;
        self.dateFormatter2.dateFormat = @"yyyy-MM-dd";
        
        self.calendarView.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userInfo = [[ShardDataManager sharedDataManager] getUserInfo];
    reqArray = [[NSMutableArray alloc] init];
    reqItemArray = [[NSMutableArray alloc] init];
    
    [self setupMenu];
    
    [self loadReqData];
    
    [self.calendarView selectDate:[NSDate date] scrollToDate:YES];
    
    self.calendarView.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesUpperCase;
    
    self.calendarView.appearance.weekdayTextColor = [UIColor whiteColor];
    self.calendarView.appearance.headerTitleColor = [UIColor whiteColor];
    self.calendarView.appearance.eventDefaultColor = FSColorRGBA(255,255,139,1.0);;
    self.calendarView.appearance.selectionColor = FSColorRGBA(23,86,98,1.0);
    self.calendarView.appearance.headerDateFormat = @"MMMM yyyy";
    self.calendarView.appearance.todayColor = FSCalendarStandardTodayColor;
    self.calendarView.appearance.borderRadius = 1.0;
    self.calendarView.appearance.headerMinimumDissolvedAlpha = 0.2;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendarView action:@selector(handleScopeGesture:)];
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    self.scopeGesture = panGesture;
    
    // While the scope gesture begin, the pan gesture of tableView should cancel.
    [self.tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
    
    [self.calendarView addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    
    self.calendarView.scope = FSCalendarScopeWeek;
    
    // For UITest
    self.calendarView.accessibilityIdentifier = @"calendar";
}

- (void)dealloc
{
    [self.calendarView removeObserver:self forKeyPath:@"scope" context:_KVOContext];
    NSLog(@"%s",__FUNCTION__);
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

- (void)loadReqData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // fetch repos from web service
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userInfo.ID forKey:@"userId"];
    [params setObject:@"1" forKey:@"officeSchedule"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET: (BASE_URL @"getAllRequests") parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
            [self.calendarView reloadData];
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

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == _KVOContext) {
        FSCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
        FSCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        NSLog(@"From %@ to %@",(oldScope==FSCalendarScopeWeek?@"week":@"month"),(newScope==FSCalendarScopeWeek?@"week":@"month"));
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

// Whether scope gesture should begin
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
    if (shouldBegin) {
        CGPoint velocity = [self.scopeGesture velocityInView:self.view];
        switch (self.calendarView.scope) {
            case FSCalendarScopeMonth:
                return velocity.y < 0;
            case FSCalendarScopeWeek:
                return velocity.y > 0;
        }
    }
    return shouldBegin;
}



#pragma mark - FSCalendarDataSource

//- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
//{
//    return [self.gregorianCalendar isDateInToday:date] ? @"今天" : nil;
//}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date
{
    if (!_lunar) {
        return nil;
    }
    NSInteger day = [_lunarCalendar component:NSCalendarUnitDay fromDate:date];
    return _lunarChars[day-1];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{

    for (RequestModel *item in reqArray) {
        NSLog(@"did select date %@",[self.dateFormatter1 stringFromDate:date]);
        NSLog(@"did select date1 %@",item.date);
        if ([item.date isEqualToString:[self.dateFormatter1 stringFromDate:date]]) {
            return 1;
        }
    }
    
    return 0;
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter1 dateFromString:@"2016/01/01"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter1 dateFromString:@"2017/12/31"];
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    //    NSLog(@"%@",(calendar.scope==FSCalendarScopeWeek?@"week":@"month"));
    _calendarHeight.constant = CGRectGetHeight(bounds);
    [self.view layoutIfNeeded];
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    BOOL shouldSelect = ![_datesShouldNotBeSelected containsObject:[self.dateFormatter1 stringFromDate:date]];
    if (!shouldSelect) {
        [[[UIAlertView alloc] initWithTitle:@"FSCalendar"
                                    message:[NSString stringWithFormat:@"FSCalendar delegate forbid %@  to be selected",[self.dateFormatter1 stringFromDate:date]]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    } else {
        NSLog(@"Should select date %@",[self.dateFormatter1 stringFromDate:date]);
    }
    return shouldSelect;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter1 stringFromDate:date]);
    
    [reqItemArray removeAllObjects];
    for (RequestModel *item in reqArray) {
        NSLog(@"did select date %@",[self.dateFormatter1 stringFromDate:date]);
        NSLog(@"did select date1 %@",item.date);
        if ([item.date isEqualToString:[self.dateFormatter1 stringFromDate:date]]) {
            reqItemArray = [item.reqs mutableCopy];
            break;
        }
    }
    
    [self.tableView reloadData];
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleOffsetForDate:(NSDate *)date
{
    if ([self calendar:calendar subtitleForDate:date]) {
        return CGPointZero;
    }
    for (RequestModel *item in reqArray) {
        NSString *strDate = [self.dateFormatter1 stringFromDate:date];
        if ([item.date isEqualToString:strDate]) {
            return CGPointMake(0, -2);
        }
    }
    return CGPointZero;
}

- (CGPoint)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventOffsetForDate:(NSDate *)date
{
    if ([self calendar:calendar subtitleForDate:date]) {
        return CGPointZero;
    }
    for (RequestModel *item in reqArray) {
        NSString *strDate = [self.dateFormatter1 stringFromDate:date];
        if ([item.date isEqualToString:strDate]) {
            return CGPointMake(0, -10);
        }
    }
    return CGPointZero;
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventSelectionColorsForDate:(nonnull NSDate *)date
{
    if ([self calendar:calendar subtitleForDate:date]) {
        return @[appearance.eventDefaultColor];
    }
    for (RequestModel *item in reqArray) {
        NSString *strDate = [self.dateFormatter1 stringFromDate:date];
        if ([item.date isEqualToString:strDate]) {
            return @[[UIColor whiteColor]];
            break;
        }
    }
    return nil;
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"%s %@", __FUNCTION__, [self.dateFormatter1 stringFromDate:calendar.currentPage]);
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return reqItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scheduleCell"];
    
    RequestItem *scheduleInfo = reqItemArray[indexPath.row];
    
    UILabel *title = (UILabel*)[cell viewWithTag:1];
    title.text = scheduleInfo.title;
    UILabel *from = (UILabel*)[cell viewWithTag:2];
    from.text = scheduleInfo.senderName;
    UILabel *to = (UILabel*)[cell viewWithTag:3];
    to.text = scheduleInfo.receiverName;
    UILabel *date = (UILabel*)[cell viewWithTag:4];
    NSString *reqType = [Common sharedManager].reqTypeArray[[scheduleInfo.requestType integerValue]-1];
    date.text = [NSString stringWithFormat:@"%@ %@", scheduleInfo.requestDateTime, reqType];
    
    UIView *view = (UIView*)[cell viewWithTag:5];
    switch ([scheduleInfo.handleStatus integerValue]) {
        case 1:
        {
            [view setBackgroundColor:RGB(129, 199, 132)];
            break;
        }
        case 2:
        {
            [view setBackgroundColor:RGB(255, 241, 118)];
            break;
        }
        case 3:
        {
            [view setBackgroundColor:RGB(229, 115, 115)];
            break;
        }
            
        default:
        {
            [view setBackgroundColor:[UIColor blueColor]];
            break;
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        FSCalendarScope selectedScope = indexPath.row == 0 ? FSCalendarScopeMonth : FSCalendarScopeWeek;
        [self.calendarView setScope:selectedScope animated:YES];
    }
    
    ShowRequestViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowRequestVcID"];
    RequestItem *scheduleInfo = reqItemArray[indexPath.row];
    vc.reqInfo = scheduleInfo;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 120;
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  ReplyMessageViewController.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/15/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "ReplyMessageViewController.h"
#import "Common.h"
#import "MainViewController.h"
#import "FPPickerController.h"
#import "FPMediaInfo.h"

@interface ReplyMessageViewController ()
{
    UserInfo *userInfo;
    NSMutableArray* fileArray;
    NSMutableArray* fileArray1;
    NSMutableArray *receiverArray;
    NIDropDown *dropDown;
    NSNumber *recvId;
    NSInteger recvType;
    NSString *attachStr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *txtFrom;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectUserType;
@property (weak, nonatomic) IBOutlet UIButton *selectReceiver;
@property (weak, nonatomic) IBOutlet UITextView *txtBefore;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtMsgBody;

@end

@implementation ReplyMessageViewController
@synthesize msgInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userInfo = [[ShardDataManager sharedDataManager] getUserInfo];
    fileArray = [[NSMutableArray alloc] init];
    fileArray1 = [[NSMutableArray alloc] init];
    receiverArray = [[NSMutableArray alloc] init];
    
    _txtFrom.text = userInfo.displayName;
    NSString *str = [NSString stringWithFormat:@"From: %@\r", msgInfo.senderName];
    str = [NSString stringWithFormat:@"%@Sent:%@\r", str, msgInfo.createdAt];
    str = [NSString stringWithFormat:@"%@To:%@\r", str, msgInfo.receiverName];
    str = [NSString stringWithFormat:@"%@Title:%@\r\r", str, msgInfo.title];
    str = [NSString stringWithFormat:@"%@%@\r", str, msgInfo.content];
    _txtBefore.text = str;
    _txtBefore.font = [UIFont systemFontOfSize:15];
    _txtBefore.textColor = [UIColor lightGrayColor];
    
    attachStr = @"";
    recvType = USER_ROLE_FONT_DESK;
    int type = [msgInfo.msgType intValue];
    if (type == 1) {
        _txtTitle.text = [NSString stringWithFormat:@"RE:%@", msgInfo.title];
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        recvId = [f numberFromString:msgInfo.senderId];
        NSString *title = msgInfo.senderName;
        [_selectReceiver setTitle:title forState:UIControlStateNormal];
    } else if (type == 2) {
        if (msgInfo != nil && ![msgInfo.attachs isEqualToString:@""]) {
            attachStr = msgInfo.attachs;
            fileArray = [NSMutableArray arrayWithArray:[msgInfo.attachs componentsSeparatedByString:@"hufeixiaomi"]];
        }
        [_selectReceiver setTitle:@"" forState:UIControlStateNormal];
        _txtTitle.text = [NSString stringWithFormat:@"Fwd:%@", msgInfo.title];
    } else {
        NSLog(@"No reply or forward message.");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileUploadToServer:) name:@"AttachFinished" object:nil];
    
    [self loadClientInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StopActivityIndicator" object:nil];
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
    [params setObject:[NSString stringWithFormat:@"%d", recvType] forKey:@"role"];
    
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
    [_selectReceiver setTitle:title forState:UIControlStateNormal];
}

- (void)fileUploadToServer:(NSNotification *)notification {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    for (FPMediaInfo *item in fileArray) {
    FPMediaInfo *item = fileArray1[fileArray1.count-1];
    NSString *mimtype = [item MIMEtype];
    if (mimtype == nil) {
        if ([[item mediaType] containsString:@"image"])
            mimtype = @"image/png";
        else if ([[item mediaType] containsString:@"video"] || [[item mediaType] containsString:@"movie"]) {
            mimtype = @"video/mp4";
        }
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:(BASE_URL @"uploadFile") parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:item.mediaURL name:@"file" fileName:item.filename mimeType:mimtype error:nil];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"responseObject: %@", responseObject);
        ResponseData *result = [[ResponseData alloc] initWithDictionary:responseObject];
        
        if ([result.success boolValue] == YES) {
            NSLog(@"responseObject: %@", responseObject);
            NSDictionary *dic = responseObject[@"data"];
            NSString *url = dic[@"url"];
            if ([attachStr isEqualToString:@""]) {
                attachStr = [attachStr stringByAppendingFormat:@"%@", url];
            } else {
                attachStr = [attachStr stringByAppendingFormat:@"hufeixiaomi%@", url];
            }
            [fileArray addObject:url];
            
            [self.tableView reloadData];
            
        } else {
            NSDictionary *dic = responseObject[@"error"];
            NSString *err = dic[@"err_msg"];
            [Common showAlert:@"Error" Message:err ButtonName:@"OK"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //here is place for code executed in error case
        [Common showAlert:@"Error" Message:network_msg_error ButtonName:@"OK"];
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    //    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fileArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attachCell"];
    
    NSString *fileName = fileArray[indexPath.row];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[fileName componentsSeparatedByString:@"/"]];
    fileName = array[array.count-1];
    
    UILabel *name = (UILabel*)[cell viewWithTag:2];
    name.text = fileName.lowercaseString;
    UIImageView *icon = (UIImageView*)[cell viewWithTag:1];
    
    if ([name.text containsString:@"pdf"]) {
        icon.image = [UIImage imageNamed:@"icon_pdf.png"];
    } else if ([name.text containsString:@"mp4"] || [name.text containsString:@"mov"]) {
        icon.image = [UIImage imageNamed:@"icon_video.png"];
    } else if ([name.text containsString:@"png"] || [name.text containsString:@"jpg"]) {
        icon.image = [UIImage imageNamed:@"icon_photo.png"];
    } else {
        icon.image = [UIImage imageNamed:@"icon_pdf.png"];
    }
    
    UIImageView *del = (UIImageView*)[cell viewWithTag:3];
    del.hidden = YES;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
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

- (IBAction)changeReceiver:(id)sender {
    UISegmentedControl *segmentControl=(UISegmentedControl *)sender;
    
    if (segmentControl.selectedSegmentIndex == 0) { // Office
        recvType = USER_ROLE_FONT_DESK;
    } else {                                        // Sale Reps
        recvType = USER_ROLE_SALES_REP;
    }
    
    [self loadClientInfo];
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onAttach:(id)sender {
    FPPickerController *pickerController = [FPPickerController new];
    pickerController.fpdelegate = self;
    
    pickerController.dataTypes = @[@"*/*"];
    
    /*
     * Select and order the sources (Optional) Default is all sources
     */
    //fpController.sourceNames = @[FPSourceImagesearch];
    
    /*
     * Enable multselect (Optional) Default is single select
     */
    pickerController.selectMultiple = NO;
    
    /*
     * Specify the maximum number of files (Optional) Default is 0, no limit
     */
    pickerController.maxFiles = 10;
    
    /*
     * Optionally disable the front camera mirroring (experimental)
     */
    pickerController.disableFrontCameraLivePreviewMirroring = NO;
    
    pickerController.modalPresentationStyle = UIModalPresentationPopover;
    
    /*
     * If controller will show in popover set popover size (iPad)
     */
    pickerController.preferredContentSize = CGSizeMake(400, 500);
    
    UIPopoverPresentationController *presentationController = pickerController.popoverPresentationController;
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    presentationController.sourceView = sender;
    presentationController.sourceRect = [sender bounds];
    
    /*
     * Display it.
     */
    [self presentViewController:pickerController
                       animated:YES
                     completion:nil];
}
- (IBAction)onSendMsg:(id)sender {
    if ([_txtTitle.text isEqualToString:@""]) {
        [Common showAlert:@"Error" Message:@"Please input message title" ButtonName:@"OK"];
        return;
    }
    if ([[recvId stringValue] isEqualToString:@""]) {
        [Common showAlert:@"Error" Message:@"Please input message receiver" ButtonName:@"OK"];
        return;
    }
    if ([_txtMsgBody.text isEqualToString:@""]) {
        [Common showAlert:@"Error" Message:@"Please input message contents" ButtonName:@"OK"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userInfo.ID forKey:@"senderId"];
    [params setObject:recvId forKey:@"receiverId"];
    [params setObject:_txtTitle.text forKey:@"title"];
    [params setObject:attachStr forKey:@"attachs"];
    [params setObject:attachStr forKey:@"pdfLink"];
    [params setObject:@"" forKey:@"videoLink"];
    [params setObject:@"" forKey:@"productInfo"];
    [params setObject:_txtMsgBody.text forKey:@"content"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST: (BASE_URL @"createMessage") parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"responseObject: %@", responseObject);
        ResponseData *result = [[ResponseData alloc] initWithDictionary:responseObject];
        
        if ([result.success boolValue] == YES) {
            NSLog(@"responseObject: %@", responseObject);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You sent successfully message to doctor." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] ;
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

//FPPicker delegate
- (void)fpPickerController:(FPPickerController *)pickerController
didFinishPickingMultipleMediaWithResults:(NSArray *)results
{
    NSLog(@"FILES CHOSEN: %@", results);
    
    if (results.count == 0)
    {
        NSLog(@"Nothing was picked.");
        
        return;
    }
    
    // Making a little carousel effect with the images
    
    //[fileArray removeAllObjects];
    for (FPMediaInfo *info in results)
    {
        // Check if uploaded file is an image to add it to carousel
        
        if (info)
        {
            //NSString *fileUrl = [NSString stringWithFormat:@"%@hufeixiaomi", info.remoteURL.path];
            [fileArray1 addObject:info];
        }
    }
    
    [self dismissViewControllerAnimated:YES
                             completion: ^() {
                                 [self.tableView reloadData];
                             }
     ];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AttachFinished" object:nil];
}

- (void)fpPickerController:(FPPickerController *)pickerController didFinishPickingMediaWithInfo:(FPMediaInfo *)info
{
    if (info)
    {
        //[fileArray removeAllObjects];
        [fileArray1 addObject:info];
        
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AttachFinished" object:nil];
    }
    else
    {
        NSLog(@"Nothing was picked.");
    }
}

- (void)fpPickerControllerDidCancel:(FPPickerController *)pickerController
{
    NSLog(@"FP Cancelled Open");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - FPSaveControllerDelegate Methods

- (void)        fpSaveController:(FPSaveController *)saveController
    didFinishSavingMediaWithInfo:(FPMediaInfo *)info
{
    NSLog(@"FP finished saving with info %@", info);
}

- (void)fpSaveControllerDidCancel:(FPSaveController *)saveController
{
    NSLog(@"FP Cancelled Save");
}

- (void)fpSaveController:(FPSaveController *)saveController
                didError:(NSError *)error
{
    NSLog(@"FP Error: %@", error);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //    UITextField * alertTextField = [alertView textFieldAtIndex:0];
    if (buttonIndex == 0) {
        [self onBack:nil];
    }
}
- (IBAction)onClickLogo:(id)sender {
    MainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVcID"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

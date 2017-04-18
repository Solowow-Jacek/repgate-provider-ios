//
//  ShowMessageViewController.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/13/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "ShowMessageViewController.h"
#import "NZCircularImageView.h"
#import "ReplyMessageViewController.h"
#import "MainViewController.h"

@interface ShowMessageViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* fileArray;
    UserInfo *userInfo;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ShowMessageViewController
@synthesize msgInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userInfo = [[ShardDataManager sharedDataManager] getUserInfo];
    fileArray = [[NSMutableArray alloc] init];
    if (msgInfo != nil && ![msgInfo.attachs isEqualToString:@""]) {
        fileArray = [NSMutableArray arrayWithArray:[msgInfo.attachs componentsSeparatedByString:@"hufeixiaomi"]];
    }
    
    if ([msgInfo.isNew boolValue] == true)
        [self changeMessageReadStatus];
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
- (void)changeMessageReadStatus {
    // fetch repos from web service
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:msgInfo.ID forKey:@"msgId"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST: (BASE_URL @"readMessage") parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"responseObject: %@", responseObject);
        ResponseData *result = [[ResponseData alloc] initWithDictionary:responseObject];
        
        if ([result.success boolValue] == YES) {
            NSLog(@"responseObject: %@", responseObject);
            userInfo.messageNew = [NSNumber numberWithInteger:[userInfo.messageNew integerValue] - 1];
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

- (void)deleteMessage {
    // fetch repos from web service
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userInfo.ID forKey:@"userId"];
    [params setObject:msgInfo.ID forKey:@"msgId"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST: (BASE_URL @"deleteMessage") parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"responseObject: %@", responseObject);
        ResponseData *result = [[ResponseData alloc] initWithDictionary:responseObject];
        
        if ([result.success boolValue] == YES) {
            NSLog(@"responseObject: %@", responseObject);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your message has been deleted!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] ;
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
    
    if (buttonIndex == 0) {
        [self onBack:nil];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;
    else if (section == 1)
        return fileArray.count;
    else if (section == 2)
        return 1;
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
            CGFloat height = 153.5;
            UITextView *msgBody = (UITextView*)[cell viewWithTag:6];
            msgBody.text = msgInfo.content;
            msgBody.font = [UIFont systemFontOfSize:17];
            
            CGFloat fixedWidth = msgBody.frame.size.width;
            CGSize newSize = [msgBody sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            CGRect newFrame = msgBody.frame;
            newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
            msgBody.frame = newFrame;

            return height + newFrame.size.height;
        }
    } else if (indexPath.section == 2)
        return 116;

    return tableView.rowHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            UILabel *title = (UILabel*)[cell viewWithTag:1];
            title.text = msgInfo.title;
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
            
            NZCircularImageView *avatar = (NZCircularImageView*)[cell viewWithTag:1];
            if (![msgInfo.senderImageUrl isEqualToString:@""]) {
                [avatar setImageWithResizeURL:msgInfo.senderImageUrl];
            }
            UILabel *sender = (UILabel*)[cell viewWithTag:2];
            sender.text = msgInfo.senderName;
            UILabel *from = (UILabel*)[cell viewWithTag:3];
            from.text = msgInfo.senderName;
            UILabel *to = (UILabel*)[cell viewWithTag:4];
            to.text = msgInfo.receiverName;
            UILabel *date = (UILabel*)[cell viewWithTag:5];
            date.text = msgInfo.createdAt;
            UITextView *msgBody = (UITextView*)[cell viewWithTag:6];
            msgBody.text = msgInfo.content;
            msgBody.font = [UIFont systemFontOfSize:17];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    } else if (indexPath.section == 1) {
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
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"actionCell"];
        
        UIButton *reply = (UIButton*)[cell viewWithTag:1];
        UIButton *forward = (UIButton*)[cell viewWithTag:2];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [NewsFeedTableViewCell heightOfCell:feedArray[indexPath.row]];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NSString *url = fileArray[indexPath.row];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"gotoReplyMessageSegue"]) {
        ReplyMessageViewController *vc = [segue destinationViewController];
        vc.msgInfo = msgInfo;
    }
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onClickDelete:(id)sender {
    [self deleteMessage];
}
- (IBAction)onReply:(id)sender {
    msgInfo.msgType = [NSNumber numberWithInt:1];
    [self performSegueWithIdentifier:@"gotoReplyMessageSegue" sender:self];
}
- (IBAction)onForward:(id)sender {
    msgInfo.msgType = [NSNumber numberWithInt:2];
    [self performSegueWithIdentifier:@"gotoReplyMessageSegue" sender:self];
}
- (IBAction)onClickLogo:(id)sender {
    MainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainVcID"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end


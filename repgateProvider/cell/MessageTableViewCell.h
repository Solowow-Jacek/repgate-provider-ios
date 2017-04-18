//
//  MessageTableViewCell.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/3/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZCircularImageView.h"
#import "MessageInfo.h"

@interface MessageTableViewCell : UITableViewCell

@property(strong, nonatomic) IBOutlet NZCircularImageView *imgAvatar;
@property(strong, nonatomic) IBOutlet UILabel *senderName;
@property(strong, nonatomic) IBOutlet UILabel *msgTitle;
@property(strong, nonatomic) IBOutlet UILabel *msgBody;
@property(strong, nonatomic) IBOutlet UILabel *msgDate;
@property(strong, nonatomic) IBOutlet UIImageView *imgNewIndicator;

- (void)setData:(MessageInfo *)data;

@end

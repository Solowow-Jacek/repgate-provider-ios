//
//  RequestTableViewCell.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/6/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZCircularImageView.h"
#import "RequestItem.h"
#import "YUTableView.h"

@interface RequestTableViewCell : UITableViewCell <YUTableViewCellDelegate>

@property(strong, nonatomic) IBOutlet NZCircularImageView *imgAvatar;
@property(strong, nonatomic) IBOutlet UILabel *senderName;
@property(strong, nonatomic) IBOutlet UILabel *reqTitle;
@property(strong, nonatomic) IBOutlet UILabel *reqType;
@property(strong, nonatomic) IBOutlet UILabel *reqDate;
@property(strong, nonatomic) IBOutlet UIImageView *imgNewIndicator;
@property(strong, nonatomic) IBOutlet UIView *reqStatus;

@end

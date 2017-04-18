//
//  ReceiverTableViewCell.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/18/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZCircularImageView.h"

@interface ReceiverTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NZCircularImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *recvName;
@property (weak, nonatomic) IBOutlet UILabel *recvRole;

@end

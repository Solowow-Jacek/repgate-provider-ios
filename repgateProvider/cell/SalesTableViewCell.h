//
//  SalesTableViewCell.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/11/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZCircularImageView.h"
#import "ClientInfo.h"

@interface SalesTableViewCell : UITableViewCell

@property(strong, nonatomic) IBOutlet NZCircularImageView *imgAvatar;
@property(strong, nonatomic) IBOutlet UILabel *name;
@property(strong, nonatomic) IBOutlet UILabel *company;

- (void)setData:(ClientInfo *)data;

@end

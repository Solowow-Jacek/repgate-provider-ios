//
//  RequestHeaderTableViewCell.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/7/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUTableView.h"

@interface RequestHeaderTableViewCell : UITableViewCell <YUTableViewCellDelegate>

@property(strong, nonatomic) IBOutlet UILabel *date;

@end

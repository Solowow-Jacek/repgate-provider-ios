//
//  RequestHeaderTableViewCell.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/7/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "RequestHeaderTableViewCell.h"

@implementation RequestHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellContentsFromItem:(YUTableViewItem *)item
{
    NSString *day = (NSString *) item.itemData;
    
    _date.text = day;
    
    if (item.status == YUTableViewItemStatusSubmenuOpened)
        self.contentView.backgroundColor = [UIColor grayColor];
    else
        self.contentView.backgroundColor = [UIColor whiteColor];
}

@end

//
//  RequestTableViewCell.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/6/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "RequestTableViewCell.h"
#import "UserInfo.h"
#import "Common.h"

@implementation RequestTableViewCell
{
    UserInfo *userInfo;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    userInfo = [[ShardDataManager sharedDataManager] getUserInfo];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCellContentsFromItem: (YUTableViewItem *) item
{
    RequestItem * data  = (RequestItem *) item.itemData;
    if (![data.senderImageUrl isEqualToString:@""]) {
        [_imgAvatar setImageWithResizeURL:data.senderImageUrl];
    }
    
    _senderName.text = data.senderName;
    _reqTitle.text = data.title;
    if (data.requestType == 1) {
        _reqType.text = @"Lunch";
    } else {
        _reqType.text = @"Appointment";
    }
    _reqDate.text = data.createdAt;
    
    if ([data.isNew boolValue] == YES && ![data.changerId isEqualToString:[userInfo.ID stringValue]]) {
        _imgNewIndicator.hidden = NO;
    } else {
        _imgNewIndicator.hidden = YES;
    }
    
    if (item.status == YUTableViewItemStatusSubmenuOpened)
        self.contentView.backgroundColor = [UIColor grayColor];
    else
        self.contentView.backgroundColor = [UIColor whiteColor];
}

@end

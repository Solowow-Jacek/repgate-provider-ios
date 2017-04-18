//
//  MessageTableViewCell.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/3/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "UserInfo.h"
#import "Common.h"

@implementation MessageTableViewCell
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

- (void)setData:(MessageInfo *)data {
    if (![data.senderImageUrl isEqualToString:@""]) {
        [_imgAvatar setImageWithResizeURL:data.senderImageUrl];
    }
    
    _senderName.text = data.senderName;
    _msgTitle.text = data.title;
    _msgBody.text = data.content;
    _msgDate.text = data.createdAt;
    
    if ([data.isNew boolValue] == YES && ![data.senderId isEqualToString:[userInfo.ID stringValue]]) {
        _imgNewIndicator.hidden = NO;
    } else {
        _imgNewIndicator.hidden = YES;
    }
}

@end

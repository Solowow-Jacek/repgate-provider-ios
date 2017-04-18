//
//  SalesTableViewCell.m
//  repgateProvider
//
//  Created by Helminen Sami on 3/11/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "SalesTableViewCell.h"

@implementation SalesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(ClientInfo *)data {
    if (![data.logoUrl isEqualToString:@""]) {
        [_imgAvatar setImageWithResizeURL:data.logoUrl];
    }
    
    _name.text = data.displayName;
    _company.text = data.company;
}

@end

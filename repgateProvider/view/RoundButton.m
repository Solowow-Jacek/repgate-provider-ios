//
//  RoundButton.m
//  repgateProvider
//
//  Created by Helminen Sami on 2/27/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    self = [super init];
    if (self) {
        [self setUISettings];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUISettings];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUISettings];
    }
    return self;
}

- (void)setUISettings {
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.layer.masksToBounds = NO;
    
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 5;
    self.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
    self.titleLabel.textColor = [UIColor whiteColor];
}

@end

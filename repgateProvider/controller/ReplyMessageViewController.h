//
//  ReplyMessageViewController.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/15/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "RootViewController.h"
#import "MessageInfo.h"
#import "NIDropDown.h"

@interface ReplyMessageViewController : RootViewController<NIDropDownDelegate>

@property (nonatomic, strong) MessageInfo *msgInfo;

@end

//
//  CreateRequestViewController.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/15/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "RootViewController.h"
#import "NIDropDown.h"

@interface CreateRequestViewController : RootViewController<NIDropDownDelegate>

@property (nonatomic, strong) UserInfo *recvInfo;

@end

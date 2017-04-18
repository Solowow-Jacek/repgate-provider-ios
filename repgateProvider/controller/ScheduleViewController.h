//
//  ScheduleViewController.h
//  repgateProvider
//
//  Created by Helminen Sami on 3/24/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "RootViewController.h"
#import "Common.h"
#import "FSCalendar.h"

@interface ScheduleViewController : RootViewController<UITableViewDataSource,UITableViewDelegate,FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@end

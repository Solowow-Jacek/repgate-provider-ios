//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NIDropDownSpec;
@protocol NIDropDownSpecDelegate <NSObject>
- (void) niDropDownSpecDelegateMethod: (NIDropDownSpec *) sender;
- (void)NIDropDownSpec:(NIDropDownSpec *)niDropDown selectIndex:(NSInteger)index;
@end

@interface NIDropDownSpec : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}
@property (nonatomic, retain) id <NIDropDownSpecDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;
-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSMutableArray *)arr :(NSString *)direction;
@end

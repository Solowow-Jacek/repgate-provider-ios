//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDownSpec.h"
#import "NIDropDownCell.h"
#import "QuartzCore/QuartzCore.h"
#import "SpecialtiesTableViewCell.h"
#import "SpecialtyInfo.h"
#import "Common.h"

@interface NIDropDownSpec ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, retain) NSMutableArray *list;
@property(nonatomic, strong) UIButton *btnSender;
@end

@implementation NIDropDownSpec
@synthesize table;
@synthesize list;
@synthesize btnSender;
@synthesize delegate;
@synthesize animationDirection;

#define ANIMATION_DURATION  0.2

- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSMutableArray *)arr :(NSString *)direction {
    btnSender = b;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        CGRect btn = b.frame;
        self.list = [NSMutableArray arrayWithArray:arr];
        
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, -5);
        }else if ([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height + 5, btn.size.width, 0);
            self.layer.shadowOffset = CGSizeMake(-5, 5);
        }
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 5;        
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1.0;
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
//        table.backgroundColor = [UIColor colorWithRed:(67.0/255.0) green:(109.0/255.0) blue:(113.0/255.0) alpha:1];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        table.separatorColor = [UIColor grayColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:ANIMATION_DURATION];
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y-*height-31, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height + 5, btn.size.width, *height );
        }
        table.frame = CGRectMake(0, 0, btn.size.width, *height);
        [self addSubview:table];
        
//        self.backgroundColor = [UIColor colorWithRed:(67.0/255.0) green:(109.0/255.0) blue:(113.0/255.0) alpha:1];
//        self.backgroundColor = [UIColor whiteColor];
        [UIView commitAnimations];
        [b.superview addSubview:self];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIMATION_DURATION];
    if ([animationDirection isEqualToString:@"up"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y, btn.size.width, 0);
    }else if ([animationDirection isEqualToString:@"down"]) {
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    }
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"specialtiesCell";
    
    SpecialtiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SpecialtiesTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    SpecialtyInfo *info = self.list[indexPath.row];

    cell.txtSpecName.text = info.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(NIDropDownSpec:selectIndex:)]) {
        [self.delegate NIDropDownSpec:self selectIndex:indexPath.row];
    }
    [self hideDropDown:btnSender];
    [self myDelegate];
}

- (void) myDelegate {
    [self.delegate niDropDownSpecDelegateMethod:self];
}

-(void)dealloc {
//    [super dealloc];
//    [table release];
//    [self release];
}

@end

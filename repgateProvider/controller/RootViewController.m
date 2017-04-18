//
//  RootViewController.m
//  FANster
//
//  Created by star on 7/6/15.
//  Copyright (c) 2015 Rod Michael. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
{
    IQKeyboardReturnKeyHandler *returnKeyHandler;
    
    UIButton *backBtn;
    UIButton *rightBtn;
    UIBarButtonItem *backBarButtonItem;
    UIBarButtonItem *rightBtnItem;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setKeyBoard];
    [self setNavBarStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setKeyBoard
{
    [[IQKeyboardManager sharedManager] setOverrideKeyboardAppearance:NO];
    [[IQKeyboardManager sharedManager] setKeyboardAppearance:UIKeyboardAppearanceDefault];
    // [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    [returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
    
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:YES];
    [[IQKeyboardManager sharedManager] keyboardDistanceFromTextField];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
}


// hide navigation shadow
- (void)setNavBarStyle {
    self.navigationController.navigationBarHidden = YES;
    /*
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]}];
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    
    // hide all of navigation buttons
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
    [self showBackButton];
     */
}

- (void)showBackButton {
    // back button item
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 22, 22);
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back1"] forState:UIControlStateNormal];
    backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)showRightButtonWithTitle:(NSString *)title {
    // right bar button
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 22);
    [rightBtn addTarget:self action:@selector(onClickRightButton:) forControlEvents:UIControlEventTouchUpInside];
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_list"] forState:UIControlStateNormal];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)hideLeftBarButton {
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)hideRightBarButton {
    self.navigationItem.rightBarButtonItem = nil;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickRightButton:(id)sender {
    
}

@end

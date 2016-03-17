//
//  HNANavigationController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/25.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNANavigationController.h"

@interface HNANavigationController ()

@end

@implementation HNANavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置导航栏主题
    [self setupNavigationBar];
    
    // 2.设置导航栏按钮主题
    
    [self setupBarButtonItem];
}
/**
 *  设置导航栏主题
 */
- (void)setupNavigationBar{
    // 字体颜色
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = HNANavTextColor;
    [appearance setTitleTextAttributes:attributes];
    
    [self.navigationBar setTintColor: HNANavTextColor];
    // 背景色
    [self.navigationBar setBarTintColor: HNANavBackgroundColor];
    //
    self.navigationBar.translucent = YES;
}
/**
 *  设置导航栏按钮主题
 */
- (void)setupBarButtonItem{
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = HNANavTextColor;
    
    [appearance setTitleTextAttributes:attributes forState: UIControlStateNormal];
}

#pragma mark - 重写
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 隐藏底部tabar
    [viewController setHidesBottomBarWhenPushed:YES];
    [super pushViewController:viewController animated:YES];
}

@end

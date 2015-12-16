//
//  HNANavigationController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/25.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNANavigationController.h"
#define NavigationMainColor [UIColor orangeColor]

@interface HNANavigationController ()

@end

@implementation HNANavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置导航栏主题
    [self setupNavigationBar];
    // 2.设置导航栏按钮主题
    [self.navigationBar setTintColor: NavigationMainColor];
    
    [self setupBarButtonItem];
}

/**
 *  设置导航栏主题
 */
- (void)setupNavigationBar{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = NavigationMainColor;
    
    [appearance setTitleTextAttributes:attributes];
}

/**
 *  设置导航栏按钮主题
 */
- (void)setupBarButtonItem{
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = NavigationMainColor;
    
    [appearance setTitleTextAttributes:attributes forState:UIControlStateNormal];
}
@end

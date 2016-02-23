//
//  HNATabBarController.m
//  MedicalNet
//
//  Created by gengliming on 16/1/15.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNATabBarController.h"

@interface HNATabBarController ()

@end

@implementation HNATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = [UIColor orangeColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
}
@end

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    HNALog(@"tabbarcontroller deallc");
}
@end

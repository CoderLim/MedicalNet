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

- (void)dealloc {
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBar.tintColor = [UIColor orangeColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - 公开方法
- (void)setTarbarHidden:(BOOL)hidden animate:(BOOL)animate {
    if (!animate) {
        [self.tabBar setHidden:hidden];
    }
    // 计算transform
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (hidden) {
        transform = ({
            CGFloat tabbarH = self.tabBar.frame.size.height;
            CGAffineTransformMakeTranslation(0, tabbarH);
        });
    }
    // 添加动画
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.tabBar.transform = transform;
                     }];
}
@end

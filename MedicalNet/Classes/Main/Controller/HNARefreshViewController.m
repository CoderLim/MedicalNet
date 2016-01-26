//
//  HNARefreshViewController.m
//  MedicalNet
//
//  Created by gengliming on 16/1/26.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

// 集成刷新控件的基类控制器

#import "HNARefreshViewController.h"
#import "MJRefresh.h"

@interface HNARefreshViewController() 

@end
@implementation HNARefreshViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.header beginRefreshing];
}

- (void)loadData {
    
}

#pragma mark - MJRefreshBaseViewDelegate 
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    [self loadData];
}

- (void)refreshViewEndRefreshing:(MJRefreshBaseView *)refreshView {
    
}
@end

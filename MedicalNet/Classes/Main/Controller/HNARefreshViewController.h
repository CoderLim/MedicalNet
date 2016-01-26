//
//  HNARefreshViewController.h
//  MedicalNet
//
//  Created by gengliming on 16/1/26.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

// 集成刷新控件的基类控制器

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@class MJRefreshHeaderView;

@interface HNARefreshViewController : UIViewController <MJRefreshBaseViewDelegate>
@property (nonatomic, weak) MJRefreshHeaderView *header;

- (void)loadData;
@end

//
//  HNAPackageButtonScrollView.h
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 预约体检-->套餐列表

#import <UIKit/UIKit.h>
#import "HNAGetPackageListResult.h"
#import "HNAHCReservePackageButton.h"

@class HNAHCReservePackageScrollView;

@protocol HNAHCReservePackageScrollViewDelegate <NSObject>
@optional
/**
 *  当点击其中某个button时调该通知函数
 */
- (void)packageScrollView:(HNAHCReservePackageScrollView *)scrollView didClickedAtIndex:(NSInteger)index;
@end

IB_DESIGNABLE
@interface HNAHCReservePackageScrollView : UIScrollView
/**
 *  当前选择的套餐id
 */
@property (nonatomic, copy, readonly) NSString *selectedPackageId;
/**
 *  代理
 */
@property(nonatomic,weak) IBOutlet id<HNAHCReservePackageScrollViewDelegate> hcDelegate;
/**
 *  当前选中的button
 */
@property (nonatomic, weak) HNAHCReservePackageButton *selectedButton;
/**
 *  一组数据
 */
@property(nonatomic,strong) NSMutableArray *modelItems;
@property (nonatomic, strong) NSMutableArray *buttons;

/**
 *  根据数据模型添加button
 */
- (void)addButtonWithModel:(HNAPackageListItem *)model;

/**
 *  点击button
 */
- (void)itemClicked:(HNAHCReservePackageButton *)sender;
@end

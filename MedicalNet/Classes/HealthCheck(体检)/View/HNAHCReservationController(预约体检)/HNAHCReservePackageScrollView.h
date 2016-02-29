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
 *  将要点击button
 */
- (BOOL)packageScrollView:(HNAHCReservePackageScrollView *)scrollView willClickAtIndex:(NSInteger)index;
/**
 *  当点击button
 */
- (void)packageScrollView:(HNAHCReservePackageScrollView *)scrollView didClickedAtIndex:(NSInteger)index;

@end

IB_DESIGNABLE
@interface HNAHCReservePackageScrollView : UIScrollView

/**
 *  当前选择的套餐id
 */
@property (nonatomic, assign, readonly) NSInteger selectedPackageId;
/**
 *  代理
 */
@property(nonatomic,weak) IBOutlet id<HNAHCReservePackageScrollViewDelegate> hcDelegate;
/**
 *  当前选中的button
 */
@property (nonatomic, weak) HNAHCReservePackageButton *selectedItem;
/**
 *  所有数据
 */
@property(nonatomic,strong) NSMutableArray *models;
/**
 *  所有控件
 */
@property (nonatomic, strong) NSMutableArray<HNAHCReservePackageButton *> *items;
/**
 *  根据数据模型添加button
 */
- (void)addItemWithModel:(HNAPackageListItem *)model;
/**
 *  根据packageId选中对应套餐
 */
- (void)selectWithPackageId:(NSInteger)packageId;
/**
 *  返回指定index的套餐id
 */
- (NSInteger)packageIdAtIndex:(NSInteger)index;
/**
 *  根据索引选中套餐
 */
- (void)selectAtIndex:(NSInteger)index;
/**
 *  点击button
 */
- (void)itemClicked:(HNAHCReservePackageButton *)sender;

@end

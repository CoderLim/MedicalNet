//
//  HNAHCDetailCellBase.h
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAGetHCDetailResult.h"
#import "HNAProgressCellBase.h"

@interface HNAHCDetailCellBase : HNAProgressCellBase

+(instancetype) alloc __attribute__((unavailable("不可用，请使用cellFor开头的方法")));
+ (instancetype)cellForTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath;
/**
 *  模型数据
 */
@property (nonatomic, strong) HNAHCStatusRecord *model;
/**
 *  cell的父控件
 */
@property (nonatomic, weak) UITableView *tableView;
/**
 *  indexPath
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  获取cell的reuse标示
 */
+ (NSString *)getIdentifier;

- (void)descBtnClicked:(UIButton *)sender;

@end

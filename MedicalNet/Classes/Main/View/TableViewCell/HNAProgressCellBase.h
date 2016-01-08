//
//  HNAProgressCellBase.h
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HNAProgressCellPositionType) {
    HNAProgressCellPositionTypeDefault,
    HNAProgressCellPositionTypeBegin,
    HNAProgressCellPositionTypeEnd
};

/**
 *  带左侧进度的cell
 */
@interface HNAProgressCellBase : UITableViewCell

/*
 *    是否是选中状态
 */
@property (nonatomic, assign) BOOL isSelected;

/*
 *   位置类型
 */
@property (nonatomic, assign) HNAProgressCellPositionType positionType;

@end

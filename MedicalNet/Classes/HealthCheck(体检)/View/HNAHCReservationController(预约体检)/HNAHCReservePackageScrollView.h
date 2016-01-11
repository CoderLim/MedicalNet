//
//  HNAPackageButtonScrollView.h
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNAGetPackageListResult.h"
#import "HNAHCReservePackageButton.h"

@class HNAHCReservePackageScrollView;

@protocol HNAHCReservePackageScrollViewDelegate <NSObject>
@optional
- (void)packageScrollView:(HNAHCReservePackageScrollView *)scrollView didClickedAtIndex:(NSInteger)index;
@end

@interface HNAHCReservePackageScrollView : UIScrollView
@property(nonatomic,weak) id<HNAHCReservePackageScrollViewDelegate> delegate;
@property (nonatomic, copy) HNAHCReservePackageButton *selectedButton;
@property(nonatomic,strong) NSMutableArray *items;
- (void)addButtonWithModel:(HNAPackageListItem *)model;
@end

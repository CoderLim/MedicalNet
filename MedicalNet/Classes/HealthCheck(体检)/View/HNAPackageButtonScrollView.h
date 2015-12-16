//
//  HNAPackageButtonScrollView.h
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HNAPackageButtonScrollView;

@protocol HNAPackageButtonScrollViewDelegate <NSObject>
@optional
- (void)packageButtonScrollView:(HNAPackageButtonScrollView *)scrollView didClickedAtIndex:(NSInteger)index;

@end

@interface HNAPackageButtonScrollView : UIScrollView

@property(nonatomic,weak) id<HNAPackageButtonScrollViewDelegate> delegate;
@property(nonatomic,strong) NSMutableArray *items;
- (void)addItem:(UIButton *)button;

@end

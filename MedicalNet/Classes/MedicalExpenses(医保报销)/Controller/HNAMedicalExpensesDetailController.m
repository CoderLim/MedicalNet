//
//  HNAMedicalExpensesDetailController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/27.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAMedicalExpensesDetailController.h"
#define DetailViewHeight 320

@interface HNAMedicalExpensesDetailController ()
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *checkDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeightConstraint;
- (IBAction)checkDetailBtnClick:(UIButton *)sender;

@end

@implementation HNAMedicalExpensesDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)checkDetailBtnClick:(UIButton *)sender {
    if (self.detailView.hidden) {
        [self spreadDetailView];
    } else {
        [self closeDetailView];
    }
}

/**
 *  detailView展开
 */
- (void)spreadDetailView{
    CGFloat height = DetailViewHeight;
    
    // 隐藏detailView
    self.detailView.hidden = NO;
    
    // 设置“查看明细”文字
    [self.checkDetailBtn setTitle:@"收起" forState:UIControlStateNormal];
    
    // 展开动画
    WEAKSELF(weakSelf);
    self.detailViewHeightConstraint.constant = height;
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:nil];
}

/**
 *  detailView收起
 */
- (void)closeDetailView{
    CGFloat height = 0;
    
    // 设置“查看明细”按钮文字
    [self.checkDetailBtn setTitle:@"查看报销明细" forState:UIControlStateNormal];
    
    // 收起动画
    WEAKSELF(weakSelf);
    self.detailViewHeightConstraint.constant = height;
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.detailView.hidden = YES;
    }];
}

@end

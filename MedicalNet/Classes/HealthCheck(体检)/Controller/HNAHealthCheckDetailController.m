//
//  HNAHealthCheckDetailController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/30.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAHealthCheckDetailController.h"
#import "HNAHCPackageDetailController.h"

#import "HNAHealthCheckTool.h"
#import "HNAGetHCDetailParam.h"
#import "HNAGetHCDetailResult.h"
#import "HNAUser.h"
#import "HNAUserTool.h"

#import "UILabel+HNA.h"

@interface HNAHealthCheckDetailController () {
    CGFloat _reminderDetailLabel_correctH;// 实际高度
    CGFloat _reservedDetailView_correctH; // 实际高度
}

// 提醒
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reminderDetailLabel_H;
@property (weak, nonatomic) IBOutlet UILabel *reminderDetailLabel;
- (IBAction)reminderBtnClicked:(id)sender;

// 已预约
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reservedDetailView_H;
@property (weak, nonatomic) IBOutlet UIView *reservedDetailView;
- (IBAction)reservedBtnClicked:(UIButton *)sender;

/**
 *  查看套餐详情
 */
- (IBAction)checkPackageDetail:(UIButton *)sender;
@end

@implementation HNAHealthCheckDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reminderDetailLabel.text = @"明天就要体检啦！\r\n 1、这是提醒第一条 \r\n 2、这是体检提醒第二条，体检提醒第二条";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 将reminderDetailLabel的实际高度存起来
    _reminderDetailLabel_correctH = [self.reminderDetailLabel correctHeight];
    _reservedDetailView_correctH = self.reservedDetailView_H.constant;
}

// 加载数据
- (void)loadData{
    HNAGetHCDetailParam *param = [[HNAGetHCDetailParam alloc] init];
    WEAKSELF(weakSelf);
    [HNAHealthCheckTool getHCDetailWithParam:param success:^(HNAGetHCDetailResult *result) {
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -
// 点击 "提醒"
- (IBAction)reminderBtnClicked:(id)sender {
    self.reminderDetailLabel.hidden = !self.reminderDetailLabel.hidden;
    if (self.reminderDetailLabel.hidden) {
        self.reminderDetailLabel_H.constant = 0;
    } else {
        self.reminderDetailLabel_H.constant = _reminderDetailLabel_correctH;
    }
    [self.view layoutIfNeeded];
}

// 点击 "已预约"
- (IBAction)reservedBtnClicked:(UIButton *)sender {
    self.reservedDetailView.hidden = !self.reservedDetailView.hidden;
    self.reservedDetailView_H.constant = self.reservedDetailView.hidden ? 0 : _reservedDetailView_correctH;
    [self.view layoutIfNeeded];
}

#pragma mark - 
- (IBAction)checkPackageDetail:(UIButton *)sender {
    HNAHCPackageDetailController *packageDetail = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAHCPackageDetailController"];
    [self.navigationController pushViewController:packageDetail animated:YES];
}
@end

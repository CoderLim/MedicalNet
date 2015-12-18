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

@interface HNAHealthCheckDetailController (){
    NSArray<NSLayoutConstraint *> *_reminderViewConstraints;
    NSArray<NSLayoutConstraint *> *_reservedViewConstraints;
}

// 提醒
@property (weak, nonatomic) IBOutlet UIView *reminderDetailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reminderLabel_B;
- (IBAction)reminderBtnClicked:(id)sender;

// 已预约
@property (weak, nonatomic) IBOutlet UIView *reservedDetailView;
- (IBAction)reservedBtnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reservedLabel_B;

- (IBAction)checkPackageDetail:(UIButton *)sender;
@end

@implementation HNAHealthCheckDetailController



- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _reminderViewConstraints = self.reminderDetailView.constraints;
    [_reminderViewConstraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setActive: NO];
        HNALog(@"%@",obj);
    }];
    
    _reservedViewConstraints = self.reservedDetailView.constraints;
//    [self.test setActive:NO];
    [_reservedViewConstraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setActive: NO];
    }];
}

// 加载数据
- (void)loadData{
    HNAGetHCDetailParam *param = [[HNAGetHCDetailParam alloc] init];
    [HNAHealthCheckTool getHCDetailWithParam:param success:^(HNAGetHCDetailResult *result) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -
// 点击 "提醒"
- (IBAction)reminderBtnClicked:(id)sender {
    // reminderDetaiView显示与隐藏
    self.reminderDetailView.hidden = !self.reminderDetailView.hidden;
    
    // 处理约束
    [self.reminderLabel_B setActive:self.reminderDetailView.hidden];
    
    __weak UIView *weakReminderDetailView = self.reminderDetailView;
    [_reminderViewConstraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setActive: !weakReminderDetailView.hidden];
    }];
    
    // 动画
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

// 点击 "已预约"
- (IBAction)reservedBtnClicked:(UIButton *)sender {
    self.reservedDetailView.hidden = !self.reservedDetailView.hidden;
    
    [self.reservedLabel_B setActive:self.reservedDetailView.hidden];
    
    __weak UIView *weakReservedDetailView = self.reservedDetailView;
    [_reservedViewConstraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setActive: !weakReservedDetailView.hidden];
    }];
    
    // 动画
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 
- (IBAction)checkPackageDetail:(UIButton *)sender {
    HNAHCPackageDetailController *packageDetail = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAHCPackageDetailController"];
    [self.navigationController pushViewController:packageDetail animated:YES];
}
@end

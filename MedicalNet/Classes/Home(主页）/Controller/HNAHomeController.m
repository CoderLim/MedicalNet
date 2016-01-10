//
//  HNAHomeController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAHomeController.h"
#import "HNAHomeTipView.h"
#import "HNAChangeCipherController.h"
#import "HNAExpensesRecordsController.h"
#import "HNAExpensesDirectionsController.h"
#import "HNAPortraitButton.h"
#import "HNAHealthCheckController.h"

@interface HNAHomeController() <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate> {
}
/**
 *  tipview的top约束
 */
@property (nonatomic,weak) NSLayoutConstraint *tipViewConstraint_Top;
/**
 *  没记录view的top约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noRecordsViewConstraint_Top;
/**
 *  有记录view的top约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hasRecordsViewConstraint_Top;

/**
 *  商业医保报销说明按钮点击
 */
- (IBAction)expensesDirectionsBtnClicked:(UIButton *)sender;
/**
 *  商业医保报销纪录按钮点击
 */
- (IBAction)expensesRecordsBtnClicked:(UIButton *)sender;

/**
 *  导航栏按钮点击
 */
- (IBAction)healthCheckupBtnClick:(UIButton *)sender;

/**
 *  修改密码提示 view
 */
@property (nonatomic,weak) HNAHomeTipView *tipView;
/**
 *  没记录 view
 */
@property (weak, nonatomic) IBOutlet UIView *noRecordsView;
/**
 *  有记录 view
 */
@property (weak, nonatomic) IBOutlet UIView *hasRecordsView;
@property (weak, nonatomic) IBOutlet HNAPortraitButton *portraitBtn;
@end

@implementation HNAHomeController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 1.设置控制器
    self.title = @"医保报销";
    
    // 2.设置tipView
    [self setupTipView];
    
    // 3.
//    [self setupPortraitAnimation];
    
//    self.hasRecordsView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 显示tipView
    WEAKSELF(weakSelf);
    if (IOS7) {
        self.tipViewConstraint_Top.constant = 64;
    } else {
        self.tipViewConstraint_Top.constant = 0;
    }
    
    [UIView animateWithDuration:1.5f animations:^{
        [weakSelf.view layoutIfNeeded];
    }];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

- (void)setupTipView{
    WEAKSELF(weakSelf);
    // 1.创建tipView
    HNAHomeTipView *tipView = [HNAHomeTipView tipViewWithChangeCipher:^{
        // 创建修改密码控制器
        HNAChangeCipherController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAChangeCipherController"];
        // 跳转到修改密码控制器
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } andClose:^{
        // 关闭tipView
        weakSelf.tipViewConstraint_Top.constant = 0;
        [UIView animateWithDuration:1.5f animations:^{
            weakSelf.tipView.alpha = 0;
            [weakSelf.view layoutIfNeeded];
        }];
    }];
    tipView.layer.zPosition = 20;
    self.tipView = tipView;
    [self.view addSubview: tipView];
    
    // 2.给tipView添加约束
    NSDictionary *viewsDictionary = @{@"tipView": self.tipView};
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tipView(25)]" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraint_Pos_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-39-[tipView]" options:0 metrics:nil views:viewsDictionary];
    NSArray *constraint_Pos_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tipView]-0-|" options:0 metrics:nil views:viewsDictionary];
    
    self.tipViewConstraint_Top = (NSLayoutConstraint*)[constraint_Pos_V lastObject];
    [self.tipView addConstraints:constraint_H];
    [self.view addConstraints:constraint_Pos_H];
    [self.view addConstraints:constraint_Pos_V];
    [self.view layoutIfNeeded];
}

// 不可用
- (void)setupPortraitAnimation{
    // 旋转
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.repeatCount = 13;
    rotateAnimation.values = @[@0,@(0.5*M_PI),@M_PI,@(1.5*M_PI),@(2*M_PI)];
    // 缩放
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@3.0,@1.0,@0.5,@1.0];
    // 动画组
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.duration = 1.0;
    animationGroup.animations = @[rotateAnimation, scaleAnimation];
    
    [self.portraitBtn.layer addAnimation:animationGroup forKey:@"portraitRotate"];
}

#pragma mark - 导航栏按钮事件
- (IBAction)healthCheckupBtnClick:(UIButton *)sender {
    UINavigationController *healthCheckupNav = [MainStoryboard instantiateViewControllerWithIdentifier:@"HealthCheckup"];
    KeyWindow.rootViewController = healthCheckupNav;
    
    CATransition *ca = [CATransition animation];
    // 设置过度效果
    ca.type = @"oglFlip";
    // 设置动画的过度方向（向右）
    ca.subtype=kCATransitionFromRight;
    // 设置动画的时间
    ca.duration=.45;
    [KeyWindow.layer addAnimation:ca forKey:nil];
}


#pragma mark - scrollView事件
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.superview == self.hasRecordsView) {
        [self expensesRecordsBtnClicked:nil];
    } else if (scrollView.superview == self.noRecordsView){
        [self expensesDirectionsBtnClicked:nil];
    }
}


#pragma mark - 按钮点击事件
/**
 *  医保报销说明按钮点击事件
 */
- (IBAction)expensesDirectionsBtnClicked:(UIButton *)sender {
    // 如果有记录view是隐藏的，就直接跳转，而不添加动画
    if (self.hasRecordsView.hidden == YES) {
        // 跳转到医保报销说明页
        [self performSegueWithIdentifier:@"Home2MedicalDirection" sender:nil];
        return;
    }
    
    CGFloat hasRecordsViewConstraint_Top = self.hasRecordsViewConstraint_Top.constant;
    CGFloat noRecordsViewConstraint_Top = self.noRecordsViewConstraint_Top.constant;
    self.hasRecordsViewConstraint_Top.constant = self.view.frame.size.height;
    self.noRecordsViewConstraint_Top.constant = 64.0;
    self.tipView.alpha = 0.0;
    self.view.userInteractionEnabled = NO;
    
    WEAKSELF(weakSelf);
    [UIView animateWithDuration:1.0f animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        // 跳转到医保报销说明页
//        HNAExpensesDirectionsController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAExpensesDirectionsController"];
//        [weakSelf.navigationController showViewController:vc sender:nil];
        [self performSegueWithIdentifier:@"Home2MedicalDirection" sender:nil];
        
        // 恢复动画前的相关属性
        weakSelf.hasRecordsViewConstraint_Top.constant = hasRecordsViewConstraint_Top;
        weakSelf.noRecordsViewConstraint_Top.constant = noRecordsViewConstraint_Top;
        weakSelf.view.userInteractionEnabled = YES;
    }];
}

/**
 *  商业医保报销纪录 按钮点击事件
 */
- (IBAction)expensesRecordsBtnClicked:(UIButton *)sender {
//    HNAExpensesRecordsController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAExpensesRecordsController"];
//    [self.navigationController pushViewController:vc animated:YES];
    [self performSegueWithIdentifier:@"Home2MedicalRecords" sender:nil];
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
@end

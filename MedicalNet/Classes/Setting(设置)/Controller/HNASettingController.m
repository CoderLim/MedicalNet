//
//  HNASettingController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNASettingController.h"
#import "HNASettingItem.h"
#import "HNASettingGroup.h"
#import "HNASettingSwitchItem.h"
#import "HNASettingArrowItem.h"
#import "HNASettingExecuteItem.h"
#import "HNASettingCell.h"
#import "HNASettingHeaderView.h"
#import "HNAChangeCipherController.h"
#import "HNAChangePhoneController.h"
#import "HNAChangePortraitController.h"
#import "HNAIntroductionController.h"
#import "HNALoginController.h"
#import "MBProgressHUD+MJ.h"
#import "objc/message.h"

@interface HNASettingController()
@property (nonatomic,strong) NSMutableArray *data;
@end

@implementation HNASettingController

- (NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 1.设置tableView属性
    HNASettingHeaderView *headerView =
    [[[NSBundle mainBundle] loadNibNamed:@"HNASettingHeaderView" owner:nil options:nil] lastObject];
    self.tableView.tableHeaderView = headerView;
    
    // 2.设置cell数据
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
}

#pragma mark - 设置cell数据
- (void)setupGroup1{
    // 修改头像
    HNASettingArrowItem *changePortrait = [HNASettingArrowItem itemWithTitle:@"修改头像"];
    changePortrait.targetController = [HNAChangePortraitController class];
    // 修改手机号
    HNASettingArrowItem *changePhone = [HNASettingArrowItem itemWithTitle:@"修改手机号"];
    changePhone.targetController = [HNAChangePhoneController class];
    // 修改密码
    HNASettingArrowItem *changeCipher = [HNASettingArrowItem itemWithTitle:@"修改密码"];
    changeCipher.targetController = [HNAChangeCipherController class];
    
    HNASettingGroup *group = [[HNASettingGroup alloc] init];
    group.items = @[changePortrait, changePhone, changeCipher];
    [self.data addObject:group];
}

- (void)setupGroup2{
    // 体检通知
    HNASettingSwitchItem *healthCheckupNotification = [HNASettingSwitchItem itemWithTitle:@"体检通知"];
    // 报销通知
    HNASettingSwitchItem *medicalExpensesNotification = [HNASettingSwitchItem itemWithTitle:@"报销通知"];
    
    HNASettingGroup *group = [[HNASettingGroup alloc] init];
    group.header = @"消息提醒设置";
    group.items = @[healthCheckupNotification, medicalExpensesNotification];
    [self.data addObject:group];
    
}

- (void)setupGroup3{
    // 清理软件存储缓存
    HNASettingExecuteItem *clearCache = [HNASettingExecuteItem itemWithTitle:@"清理软件存储缓存" option:^{
        [MBProgressHUD showSuccess:@"清理成功"];
    }];
    
    // 我们的其他APP
    HNASettingArrowItem *otherAPP = [HNASettingArrowItem itemWithTitle:@"我们的其他APP"];
    otherAPP.targetController = [HNAIntroductionController class];
    
    // 退出登录
    HNASettingExecuteItem *logout = [HNASettingExecuteItem itemWithTitle:@"退出登录" option:^{
        UINavigationController *loginNav = [MainStoryboard instantiateViewControllerWithIdentifier:@"LoginNav"];
        KeyWindow.rootViewController = loginNav;
        
        CATransition *ca = [CATransition animation];
        // 设置过度效果
        ca.type= kCATransitionPush;
        // 设置动画的过度方向（向左）
        ca.subtype=kCATransitionFromLeft;
        // 设置动画的时间
        ca.duration=.25;
        // 设置动画的起点
        ca.startProgress = 0.5;
        [KeyWindow.layer addAnimation:ca forKey:nil];

    }];
    otherAPP.targetController = [HNALoginController class];
    
    HNASettingGroup *group = [[HNASettingGroup alloc] init];
    group.items = @[clearCache, otherAPP, logout];
    [self.data addObject:group];
}

#pragma mark - tableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HNASettingGroup *group = self.data[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNASettingGroup *group = self.data[indexPath.section];
    HNASettingItem *item = group.items[indexPath.row];
    
    HNASettingCell *cell = [HNASettingCell cellWithTableView:tableView];
    cell.item = item;
    cell.detailTextLabel.text = @"detail";
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    HNASettingGroup *group = self.data[section];
    return group.header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.item数据
    HNASettingGroup *group = self.data[indexPath.section];
    HNASettingItem *item = group.items[indexPath.row];

    if ([item isKindOfClass:[HNASettingArrowItem class]]) {
        // 2.获得目标控制器
        HNASettingArrowItem *arrowItem = (HNASettingArrowItem *)item;
        Class targetVC = arrowItem.targetController;
        NSString *className = [NSString stringWithUTF8String:class_getName(targetVC)];
        UIViewController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:className];
        HNALog(@"%@",className);
        // 3.跳转
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([item isKindOfClass:[HNASettingExecuteItem class]]){
        HNASettingExecuteItem *execItem = (HNASettingExecuteItem *)item;
        execItem.option();
    }
    
    // 4.取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

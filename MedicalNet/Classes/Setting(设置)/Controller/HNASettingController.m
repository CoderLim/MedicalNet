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
#import "SDImageCache.h"
#import "HNANavigationController.h"
#import "MJRefresh.h"

#define Setting2ChangePortraitSegue @"setting2changePortrait"
#define Setting2ChangePwdSegue @"setting2changePwd"
#define Setting2ChangePhoneSegue @"setting2changePhone"
#define Setting2IntroduceSegue @"setting2introduce"

@interface HNASettingController() <MJRefreshBaseViewDelegate>
@property (nonatomic, strong) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet HNASettingHeaderView *tableViewHeader;
@property (nonatomic, weak) MJRefreshHeaderView *header;
@end

@implementation HNASettingController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableView.showsVerticalScrollIndicator = NO;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    self.header = header;
    
    // 设置cell数据
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.header beginRefreshing];
}

- (NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

#pragma mark - 设置cell数据
- (void)setupGroup1{
    // 修改头像
    HNASettingArrowItem *changePortrait = [HNASettingArrowItem itemWithTitle:@"修改头像"];
    changePortrait.segueIdentifier = Setting2ChangePortraitSegue;
    // 修改手机号
    HNASettingArrowItem *changePhone = [HNASettingArrowItem itemWithTitle:@"修改手机号"];
    changePhone.segueIdentifier = Setting2ChangePhoneSegue;
    // 修改密码
    HNASettingArrowItem *changeCipher = [HNASettingArrowItem itemWithTitle:@"修改密码"];
    changeCipher.segueIdentifier = Setting2ChangePwdSegue;
    
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
        [[SDImageCache sharedImageCache] clearDisk];
        [MBProgressHUD showSuccess:@"清理成功"];
    }];
    
    // 我们的其他APP
    HNASettingArrowItem *otherAPP = [HNASettingArrowItem itemWithTitle:@"我们的其他APP"];
    otherAPP.segueIdentifier = Setting2IntroduceSegue;
    
    // 退出登录
    HNASettingExecuteItem *logout = [HNASettingExecuteItem itemWithTitle:@"退出登录" option:^{
//        HNANavigationController *loginNav = [MainStoryboard instantiateViewControllerWithIdentifier:@"LoginNav"];
        HNANavigationController *loginNav = [MainStoryboard instantiateInitialViewController];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = item;
    cell.detailTextLabel.text = @"detail";
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    HNASettingGroup *group = self.data[section];
    return group.header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // item数据
    HNASettingGroup *group = self.data[indexPath.section];
    HNASettingItem *item = group.items[indexPath.row];

    if ([item isKindOfClass:[HNASettingArrowItem class]]) {
        [self performSegueWithIdentifier:((HNASettingArrowItem *)item).segueIdentifier sender:nil];
    } else if ([item isKindOfClass:[HNASettingExecuteItem class]]){
        HNASettingExecuteItem *execItem = (HNASettingExecuteItem *)item;
        execItem.option();
    }
}
#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.header endRefreshing];
    });
}

- (void)dealloc {
    [self.header free];
}
@end

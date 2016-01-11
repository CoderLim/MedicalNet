//
//  HNAHealthCheckupController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 体检主页

#import "HNAHealthCheckController.h"
#import "HNAHealthCheckRecordModel.h"
#import "HNAHealthCheckDetailController.h"
#import "HNAHCDetailController.h"
#import "HNAHCReservationController.h"
#import "HNAHealthCheckRecordCell.h"
#import "HNADatePickButton.h"
#import "MBProgressHUD+MJ.h"

#import "HNAUser.h"
#import "HNAUserTool.h"
#import "HNAHealthCheckTool.h"
#import "HNAGetHCRecordsParam.h"
#import "HNAGetHCRecordsResult.h"

#define HCHome2HCDetailSegue @"HCHome2HCDetail"

@interface HNAHealthCheckController() <HNADatePickButtonDelegate>
/**
 *  体检记录
 */
@property (nonatomic,strong) NSMutableArray<HNAHealthCheckRecordModel *> *records;
 /**
 *  搜索记录
 */
@property (nonatomic,strong) NSMutableArray<HNAHealthCheckRecordModel *> *filterRecords;
/**
 *  日期选择
 */
@property (weak, nonatomic) IBOutlet HNADatePickButton *datePickButton;

/**
 *  查看(预约)体检项目
 */
- (IBAction)reserveHealthCheck:(UIButton *)sender;

/**
 *  跳转到 医保报销
 */
- (IBAction)MedicalExpensesBtnClick:(UIButton *)sender;
@end
@implementation HNAHealthCheckController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"体检";
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAHealthCheckRecordCell" bundle:nil] forCellReuseIdentifier:@"HealthCheckRecordCell"];
    [self loadDataWithYear:2015 month:12];
}

- (NSMutableArray *)records{
    if (_records == nil) {
        _records = [NSMutableArray array];
        
        // 添加记录
        for (NSInteger i = 0; i < 3; i++) {
            HNAHealthCheckRecordModel *model = [HNAHealthCheckRecordModel healthCheckRecordWithName:@"白领套餐" state:@"已完成" date:@"2015-11－1"];
            [_records addObject:model];
        }
    }
    return _records;
}

- (void)loadDataWithYear:(NSInteger)year month:(NSInteger)month{
    [MBProgressHUD showMessage: MessageWhenLoadingData];
    // 参数
    HNAGetHCRecordsParam *param = [[HNAGetHCRecordsParam alloc] init];
    param.id = [HNAUserTool user].id;
    param.year = year;
    param.month = month;
    // 获取记录
    WEAKSELF(weakSelf);
    [HNAHealthCheckTool getHCRecordsWithParam:param success:^(HNAGetHCRecordsResult *result) {
        [weakSelf.records addObjectsFromArray:result.records];
        [weakSelf.tableView reloadData];
        
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"error:%@",error]];
    }];
}



#pragma mark - datePickButton代理
- (void)datePickButton:(HNADatePickButton *)button didFinishSelectDate:(NSDate *)date{
    if (date != nil) {
        NSDateComponents *components = [date components];
        [self loadDataWithYear:components.year month:components.month];
    }
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNAHealthCheckRecordCell *cell = [HNAHealthCheckRecordCell cellWithTableView:tableView];
    HNAHealthCheckRecordModel *model = self.records[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 跳转到 体检详情
    [self performSegueWithIdentifier:HCHome2HCDetailSegue sender:self.records[indexPath.row].id];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
}

#pragma mark - 单击事件
- (IBAction)reserveHealthCheck:(UIButton *)sender {
    // 体检首页 跳转到 预约体检
    [self performSegueWithIdentifier:@"HCHome2HCReserve" sender:nil];
}

#pragma mark - 导航按钮事件
- (IBAction)MedicalExpensesBtnClick:(UIButton *)sender {
    UINavigationController *nav = [MainStoryboard instantiateViewControllerWithIdentifier:@"HomeNav"];
    KeyWindow.rootViewController = nav;
    
    CATransition *ca = [CATransition animation];
    // 设置过度效果
    ca.type = @"oglFlip";
    // 设置动画的过度方向（向右）
    ca.subtype=kCATransitionFromLeft;
    // 设置动画的时间
    ca.duration=.45;
    // 设置动画的起点
    //    ca.startProgress=0.5;
    [KeyWindow.layer addAnimation:ca forKey:nil];
}

#pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: HCHome2HCDetailSegue]) {
        HNAHCDetailController *vc = segue.destinationViewController;
        vc.hcRecordId = [sender stringValue];
    }
}
@end

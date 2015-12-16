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
#import "HNAHCReservationController.h"
#import "HNAHealthCheckRecordCell.h"
#import "HNADatePickButton.h"
#import "MBProgressHUD+MJ.h"

#import "HNAHealthCheckTool.h"
#import "HNAGetHCRecordsParam.h"
#import "HNAGetHCRecordsResult.h"

@interface HNAHealthCheckController() <HNADatePickButtonDelegate>
/**
 *  体检记录
 */
@property (nonatomic,strong) NSMutableArray *records;
 /**
 *  搜索记录
 */
@property (nonatomic,strong) NSMutableArray *filterRecords;
/**
 *  日期选择
 */
@property (weak, nonatomic) IBOutlet HNADatePickButton *datePickButton;

/**
 *  查看(预约)体检项目
 */
- (IBAction)reserveHealthCheck:(UIButton *)sender;


- (IBAction)MedicalExpensesBtnClick:(UIButton *)sender;
@end
@implementation HNAHealthCheckController

- (NSMutableArray *)records{
    if (_records == nil) {
        _records = [NSMutableArray array];
        
        // 添加记录
        for (NSInteger i = 0; i < 20; i++) {
            HNAHealthCheckRecordModel *model = [HNAHealthCheckRecordModel healthCheckRecordWithName:@"白领套餐" state:@"已完成" date:@"2015-11－1"];
            [_records addObject:model];
            if (i % 3 == 0) {
//                model.state = @"13143143114314301743091743271943728174381043201432810341";
            }
        }
        
        // 网络请求
        HNAGetHCRecordsParam *param = [[HNAGetHCRecordsParam alloc] init];
        [HNAHealthCheckTool getHCRecordsWithParam:param success:^(HNAGetHCRecordsResult *result) {
            
        } failure:^(NSError *error) {
            
        }];
    }
    return _records;
}

-(void)viewDidLoad{
    self.title = @"体检";
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAHealthCheckRecordCell" bundle:nil] forCellReuseIdentifier:@"HealthCheckRecordCell"];
}

- (void)loadDataWithDate:(NSDate *)date{
    [MBProgressHUD showError:@"正在努力加载中..."];
    // 参数
    HNAGetHCRecordsParam *param = [[HNAGetHCRecordsParam alloc] init];
    if (date != nil) {
        NSDateComponents *componets = date.components;
        param.year = componets.year;
        param.month = componets.month;
    }
    
    // 获取记录
    WEAKSELF(weakSelf);
    [HNAHealthCheckTool getHCRecordsWithParam:param success:^(HNAGetHCRecordsResult *result) {
        weakSelf.records = result.records;
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"error:%@",error]];
    }];
}

#pragma mark - datePickButton代理
- (void)datePickButton:(HNADatePickButton *)button didFinishSelectDate:(NSDate *)date{
    
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
    HNAHealthCheckDetailController *detailVc = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAHealthCheckDetailController"];
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
}

#pragma mark - 单击事件
- (IBAction)reserveHealthCheck:(UIButton *)sender {
    HNAHCReservationController *reservationVc = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAHCReservationController"];
    [self.navigationController pushViewController:reservationVc animated:YES];
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
@end

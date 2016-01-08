//
//  HNAHCDetailController.m
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

// 体检详情

#import "HNAHCDetailController.h"
#import "HNAHCReportController.h"
#import "HNAHCPackageDetailController.h"

#import "HNAHealthCheckTool.h"
#import "HNAGetHCDetailParam.h"
#import "HNAGetHCDetailResult.h"
#import "HNAUser.h"
#import "HNAUserTool.h"

#import "UILabel+HNA.h"

#import "HNAHCDetailCell.h"
#import "HNAHCDetailReminderCell.h"
#import "HNAHCDetailReservedCell.h"

@interface HNAHCDetailController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  几种状态
 */
@property (nonatomic, strong) NSMutableArray<HNAHCStatusRecord *> *statusRecords;

/**
 *  预约
 */
@property (nonatomic, strong) HNAHCAppointment *appointment;

/**
 *  提醒信息
 */
@property (nonatomic,copy) NSString *alertMessage;

- (IBAction)checkPackageDetail:(UIButton *)sender;
@end
@implementation HNAHCDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAHCDetailHealthCheckedCell" bundle:nil] forCellReuseIdentifier:@"HNAHCDetailHealthCheckedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAHCDetailReminderCell" bundle:nil] forCellReuseIdentifier:@"HNAHCDetailReminderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAHCDetailReservedCell" bundle:nil] forCellReuseIdentifier:@"HNAHCDetailReservedCell"];
    
}

- (NSMutableArray<HNAHCStatusRecord *> *)statusRecords {
    if (_statusRecords == nil) {
        _statusRecords = [NSMutableArray array];
        
        for (NSInteger i=0; i<4; i++) {
            HNAHCStatusRecord *record = [[HNAHCStatusRecord alloc] init];
            record.id = [NSString stringWithFormat:@"%ld",(long)i];
            record.date = @"2015-10-10";
            record.desc = @"描述";
            record.isSelected = NO;
            [_statusRecords addObject:record];
        }
        
    }
    return _statusRecords;
}

// 加载数据
- (void)loadData{
    HNAGetHCDetailParam *param = [[HNAGetHCDetailParam alloc] init];
    WEAKSELF(weakSelf);
    [HNAHealthCheckTool getHCDetailWithParam:param success:^(HNAGetHCDetailResult *result) {
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 按钮点击事件
- (IBAction)checkPackageDetail:(UIButton *)sender {
    HNAHCPackageDetailController *packageDetail = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAHCPackageDetailController"];
    [self.navigationController pushViewController:packageDetail animated:YES];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusRecords.count;
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.数据模型
    HNAHCStatusRecord *record = self.statusRecords[indexPath.row];
    
    // 2.所有cell默认显示HNAHCDetailCell，当点击对应button后（即record.isSelected == YES）切换到对应cell
    HNAHCDetailCellBase *cell = nil;
    if (record.isSelected == NO || indexPath.row <=1) { // 前两个cell不根据isSelected变化
        cell = [HNAHCDetailCell cellForTableView:tableView withIndexPath:indexPath];
        if (indexPath.row == 0) {
            // 设置block
            WEAKSELF(wself);
            ((HNAHCDetailCell *)cell).descBlock = ^{
                HNAHCReportController *reportController = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAHCReportController"];
                [wself.navigationController pushViewController:reportController animated:YES];
            };
        } else {
            ((HNAHCDetailCell *)cell).descBlock = nil;
        }
    } else {
        if (indexPath.row == 2) {
            cell = [HNAHCDetailReminderCell cellForTableView:tableView withIndexPath:indexPath];
        } else if (indexPath.row == 3) {
            cell = [HNAHCDetailReservedCell cellForTableView:tableView withIndexPath:indexPath];
        }
    }
    
    // 3.设置位置属性
    if (indexPath.row == 0) {
        cell.positionType = HNAProgressCellPositionTypeBegin;
    } else if (indexPath.row == 3) {
        cell.positionType = HNAProgressCellPositionTypeEnd;
    } else {
        cell.positionType = HNAProgressCellPositionTypeDefault;
    }
    
    // 4.数据模型赋值给cell
    cell.model = record;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
@end

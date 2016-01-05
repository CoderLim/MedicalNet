//
//  HNAHCDetailController.m
//  MedicalNet
//
//  Created by gengliming on 16/1/5.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAHCDetailController.h"

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

@end
@implementation HNAHCDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusRecords.count;
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier_default = @"HNAHCDetailCell";
    static NSString *identifier_reminder = @"HNAHCDetailReminderCell";
    static NSString *identifier_reserved = @"HNAHCDetailReservedCell";

    HNAHCStatusRecord *record = self.statusRecords[indexPath.row];
    
    HNAHCDetailCell *cell = nil;
    
    if (record.isSelected == NO || indexPath.row <=1) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier_default];
    } else {
        if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:identifier_reminder];
            HNALog(@"%@",record);
        } else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:identifier_reserved];
        }
    }
    cell.tableView = tableView;
    cell.model = record;
    return cell;
}
@end

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
#import "HNAHCCheckedCell.h"
#import "HNAHCDetailReminderCell.h"
#import "HNAHCDetailReservedCell.h"
/**
 *  体检详情 跳转到 套餐详情
 */
#define HCDetail2PackageDetailSegue @"hcDetail2packageDetail"
/**
 *  体检详情 跳转到 体检报告
 */
#define HCDetail2HCReportSegue @"hcDetail2hcReport"

@interface HNAHCDetailController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  套餐名称
 */
@property (weak, nonatomic) IBOutlet UILabel *packageNameLabel;
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
/**
 *  体检套餐id
 */
@property (nonatomic, assign) NSInteger packageId;
/**
 *  查看 套餐详情
 */
- (IBAction)checkPackageDetail:(UIButton *)sender;

@end

@implementation HNAHCDetailController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"体检详情";
    
    // 设置tableView
    [self setupTableView];
    
    // 加载数据
    [self loadData];
}

#pragma mark - Custom Accessors
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

#pragma mark - Private
- (void)setupTableView {
    // tableView注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAHCCheckedCell" bundle:nil] forCellReuseIdentifier:@"HNAHCCheckedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAHCDetailReminderCell" bundle:nil] forCellReuseIdentifier:@"HNAHCDetailReminderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAHCDetailReservedCell" bundle:nil] forCellReuseIdentifier:@"HNAHCDetailReservedCell"];
}
/**
 *  加载数据
 */
- (void)loadData{
    [MBProgressHUD showMessage: kMessageWhenLoadingData];
    
    HNAGetHCDetailParam *param = [[HNAGetHCDetailParam alloc] init];
    param.id = self.hcRecordId;
    WEAKSELF(weakSelf);
    [HNAHealthCheckTool getHCDetailWithParam:param success:^(HNAGetHCDetailResult *result) {
        [MBProgressHUD hideHUD];
        if (result.success==HNARequestResultSUCCESS) {
            weakSelf.appointment = result.appointment;
            weakSelf.alertMessage = result.alertMessage;
            weakSelf.packageId = result.packageId;
            weakSelf.packageNameLabel.text = result.name;
            
            weakSelf.statusRecords = result.statusRecords;
            [self.tableView reloadData];
            [MBProgressHUD showSuccess: kMessageWhenSuccess];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError: kMessageWhenFaild];
    }];
}

#pragma mark - IBActions
- (IBAction)checkPackageDetail:(UIButton *)sender {
    // 跳转 套餐详情页
    [self performSegueWithIdentifier: HCDetail2PackageDetailSegue sender:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.数据模型
    HNAHCStatusRecord *record = self.statusRecords[indexPath.row];
    
    // 2.所有cell默认显示HNAHCDetailCell，当点击对应button后（即record.isSelected == YES）切换到对应cell
    HNAHCDetailCellBase *cell = nil;
    if (indexPath.row == 0) {
        WEAKSELF(weakSelf);
        cell = [HNAHCDetailCell cellForTableView:tableView withIndexPath:indexPath descBlock:^{
            [weakSelf performSegueWithIdentifier:HCDetail2HCReportSegue sender:nil];
        }];
        cell.positionType = HNAProgressCellPositionTypeBegin;
    } else if (indexPath.row == 1) {
        cell = [HNAHCCheckedCell cellForTableView:tableView withIndexPath:indexPath];
        cell.positionType = HNAProgressCellPositionTypeDefault;
    } else if (indexPath.row == 2) {
        cell = record.isSelected ? [HNAHCDetailReminderCell cellForTableView:tableView withIndexPath:indexPath alertMessage:self.alertMessage] : [HNAHCDetailCell cellForTableView:tableView withIndexPath:indexPath];
        cell.positionType = HNAProgressCellPositionTypeDefault;
    } else if (indexPath.row ==3) {
        cell = record.isSelected ? [HNAHCDetailReservedCell cellForTableView:tableView withIndexPath:indexPath appointment:self.appointment] : [HNAHCDetailCell cellForTableView:tableView withIndexPath:indexPath];
        cell.positionType = HNAProgressCellPositionTypeEnd;
    }
    
    // 3.数据模型赋值给cell
    cell.model = record;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - UIViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: HCDetail2PackageDetailSegue]) {
        HNAHCPackageDetailController *packageDetailVc = segue.destinationViewController;
        packageDetailVc.packageId = self.packageId;
    }
}

@end

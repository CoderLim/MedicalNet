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

#import "MJRefresh.h"

/**  跳转到体检详情 */
#define HCHome2HCDetailSegue @"HCHome2HCDetail"

@interface HNAHealthCheckController() <UITableViewDataSource,UITableViewDelegate,HNADatePickButtonDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/**
 *  当前选择的日期
 */
@property (nonatomic, strong) NSDate *selectedDate;
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
 *  预约体检 按钮
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reserveButton_H;
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
/**
 *  查看(预约)体检项目
 */
- (IBAction)reserveHealthCheck:(UIButton *)sender;

@end

@implementation HNAHealthCheckController

- (void)dealloc {
    [self.header free];
}

#pragma mark - View lifecycle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"体检";
    
    // 设置tableView
    [self setupTableView];
    
    // 设置刷新控件
    [self setupRefreshView];
}

#pragma mark - Custom Accessors
- (NSMutableArray *)records{
    if (_records == nil) {
        _records = [NSMutableArray array];
    }
    return _records;
}

#pragma mark - Private
- (void)setupTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAHealthCheckRecordCell" bundle:nil] forCellReuseIdentifier:@"HealthCheckRecordCell"];
}

- (void)setupRefreshView {
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    self.header = header;
}

- (void)loadData {
    HNAGetHCRecordsParam *param = [HNAGetHCRecordsParam param];
    if (self.selectedDate != nil) {
        NSDateComponents *components = [self.selectedDate hna_components];
        param.year = [NSString stringWithFormat:@"%ld", (long)components.year];
        param.month = [NSString stringWithFormat:@"%ld", (long)components.month];
    }
    // 获取记录
    WEAKSELF(weakSelf);
    [HNAHealthCheckTool getHCRecordsWithParam:param
                                      success:^(HNAGetHCRecordsResult *result) {
                                          if (result.success == HNARequestResultSUCCESS){
                                              [weakSelf.records addObjectsFromArray:result.records];
                                              [weakSelf.tableView reloadData];
                                              // 没有体检项目则隐藏入口
                                              if (result.hasNewProject == 0) {
                                                  //                weakSelf.reserveButton.hidden = (result.hasNewProject == 0);
                                                  weakSelf.reserveButton_H.constant = 0;
                                              }
                                          }
                                          [self.header endRefreshing];
                                      } failure:^(NSError *error) {
                                          [self.header endRefreshing];
                                          [MBProgressHUD showError:[NSString stringWithFormat:@"error:%@",error]];
                                      }];
}

#pragma mark - HNADatePickButtonDelegate
- (void)datePickButton:(HNADatePickButton *)button didFinishSelectDate:(NSDate *)date{
    if (date != nil) {
        self.selectedDate = date;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNAHealthCheckRecordCell *cell = [HNAHealthCheckRecordCell cellWithTableView:tableView];
    HNAHealthCheckRecordModel *model = self.records[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:HCHome2HCDetailSegue sender:self.records[indexPath.row].id];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
    
}

#pragma mark - IBActions
- (IBAction)reserveHealthCheck:(UIButton *)sender {
    // 体检首页 跳转到 预约体检
    [self performSegueWithIdentifier:@"HCHome2HCReserve" sender:nil];
}

#pragma mark - UIViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: HCHome2HCDetailSegue]) {
        HNAHCDetailController *vc = segue.destinationViewController;
        vc.hcRecordId = [sender stringValue];
    }
}

@end

//
//  HNAExpensesRecordsController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAExpensesRecordsController.h"
#import "HNAExpensesRecordCell.h"
#import "HNAExpenseRecordModel.h"
#import "HNADatePickButton.h"

#import "HNAInsuranceTool.h"
#import "HNAExpenseRecordsParam.h"
#import "MBProgressHUD+MJ.h"
#import "HNAUserTool.h"
#import "HNAUser.h"

@interface HNAExpensesRecordsController() <HNADatePickButtonDelegate>{
    NSDate *_selectedDate;
}

/**
 *  报销记录
 */
@property (nonatomic,strong) NSMutableArray *records;
@property (nonatomic,strong) NSMutableArray *filterRecords;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet HNADatePickButton *datePickButton;
@end
@implementation HNAExpensesRecordsController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    // 设置navigationItem
    self.navigationItem.title = @"医保报销记录";
    
    // 注册自定义Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAExpensesRecordCell" bundle:nil] forCellReuseIdentifier:RecordCellIdentifier];
}

-(NSMutableArray *)records{
    if (_records == nil) {
        _records = [NSMutableArray array];
        for (NSInteger i = 0; i < 20; i++) {
            HNAExpenseRecordModel *model = [HNAExpenseRecordModel recordeWithAmount:[NSString stringWithFormat:@"%ld",(long)i] date:@"date" state:@"state"];
            [self.records addObject:model];
        }
        /**
         *  加载本月数据
         */
//        [self loadDataWithDate:nil];
    }
    return _records;
}

/**
 *  加载指定日期的数据
 */
- (void)loadDataWithDate:(NSDate *)date{
    [MBProgressHUD showMessage:@"正在加载..."];
    // 1.参数
    HNAExpenseRecordsParam *param = [[HNAExpenseRecordsParam alloc] init];
    param.id = [HNAUserTool user].id;
    if (date != nil) {
        NSDateComponents *components = [date components];
        param.year = components.year;
        param.month = components.month;
    }
    
    // 2.请求数据
    WEAKSELF(weakSelf);
    [HNAInsuranceTool getExpenseRecordsWithParam:param success:^(NSMutableArray<HNAExpenseRecordModel *> *records) {
        [weakSelf.records addObjectsFromArray:records];
        [MBProgressHUD hideHUD];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"获取报销纪录失败:%@", error]];
    }];
    
    // 3.刷新表格
    [self.tableView reloadData];
}

#pragma mark - datePickButtonDelegate
- (void)datePickButton:(HNADatePickButton *)button dateChanged:(NSDate *)date{
    _selectedDate = date;
}

- (void)datePickButton:(HNADatePickButton *)button didFinishSelectDate:(NSDate *)date{
//    [self loadDataWithDate:_selectedDate];
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HNAExpenseRecordModel *model;
    model = self.records[indexPath.row];
    HNAExpensesRecordCell *cell = [HNAExpensesRecordCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAMedicalExpensesDetailController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
@end

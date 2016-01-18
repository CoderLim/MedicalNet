//
//  HNAExpensesRecordsController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 医保报销纪录

#import "HNAExpensesRecordsController.h"
#import "HNAExpensesRecordCell.h"
#import "HNAGetExpenseRecordsResult.h"
#import "HNADatePickButton.h"

#import "HNAInsuranceTool.h"
#import "HNAGetExpenseRecordsParam.h"
#import "MBProgressHUD+MJ.h"
#import "HNAUserTool.h"
#import "HNAUser.h"

/**
 *  报销记录页跳转到记录详情
 */
#define ExpenseRecord2RecordDetailSegue @"expenseRecord2recordDetail"

@interface HNAExpensesRecordsController() <HNADatePickButtonDelegate>{
    NSDate *_selectedDate;
}
/**
 *  报销记录 数据
 */
@property (nonatomic,strong) NSMutableArray *records;

@property (nonatomic,strong) NSMutableArray *filterRecords;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet HNADatePickButton *datePickButton;
@end
@implementation HNAExpensesRecordsController

-(void)viewDidLoad{
    [super viewDidLoad];

    self.title = @"医保报销记录";
    
    self.datePickButton.delegate = self;
    
    // 注册自定义Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HNAExpensesRecordCell" bundle:nil] forCellReuseIdentifier:RecordCellIdentifier];
}

-(NSMutableArray *)records{
    if (_records == nil) {
        _records = [NSMutableArray array];
        //加载本月数据
        [self loadDataWithDate:nil];
//    // 自定义数据
//        for (NSInteger i = 0; i < 20; i++) {
//            HNAExpenseRecordModel *model = [HNAExpenseRecordModel recordeWithAmount:[NSString stringWithFormat:@"%ld",(long)i] date:@"date" state:@"state"];
//            [self.records addObject:model];
//        }
    }
    return _records;
}

/**
 *  加载指定日期的数据
 */
- (void)loadDataWithDate:(NSDate *)date{
    [MBProgressHUD showMessage:@"正在加载..."];
    // 1.参数
    HNAGetExpenseRecordsParam *param = [HNAGetExpenseRecordsParam param];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    date = date?:[NSDate date];
#pragma clang diagnostic pop
    NSDateComponents *components = [date components];
    param.year = components.year;
    param.month = components.month;
    
    // 2.请求数据
    WEAKSELF(weakSelf);
    [HNAInsuranceTool getExpenseRecordsWithParam:param success:^(HNAGetExpenseRecordsResult *result) {
        [weakSelf.records removeAllObjects];
        [weakSelf.records addObjectsFromArray: result.records];
        [self.tableView reloadData];
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
    [self loadDataWithDate:_selectedDate];
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
    [self performSegueWithIdentifier:ExpenseRecord2RecordDetailSegue sender:nil];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
@end

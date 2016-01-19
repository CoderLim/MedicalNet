//
//  HNAHomeController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAHomeController.h"
#import "HNAHomeTipView.h"
#import "UIImage+HNA.h"
#import "HNAChangeCipherController.h"
#import "HNAExpensesRecordsController.h"
#import "HNAExpensesDirectionsController.h"
#import "HNAHealthCheckController.h"
#import "HNAExpensesRecordCell.h"

#import "HNAInsuranceTool.h"
#import "HNAGetExpenseDirectionResult.h"

#import "HNAGetExpenseRecordsParam.h"
#import "HNAGetExpenseRecordsResult.h"

// 主页跳转到报销记录页面
#define Home2MedicalRecordsSegue @"Home2MedicalRecords"
// 主页跳转到报销说明页面
#define Home2MedicalDirectionSegue @"Home2MedicalDirection"
// 主页跳转到修改密码页面
#define Home2ChangeCipherSegue @"home2changeCipher"
// 主页跳转到申请报销页面
#define Home2ApplyExpenseSegue @"home2applyExpense"

@interface HNAHomeController() <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
/**
 *  没记录view的top约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noRecordsViewConstraint_Top;
/**
 *  有记录view的top约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hasRecordsViewConstraint_Top;

/**
 *  修改密码提示 view
 */
@property (nonatomic,weak) HNAHomeTipView *tipView;
/**
 *  没记录 view
 */
@property (weak, nonatomic) IBOutlet UIView *noRecordsView;
/**
 *  有记录 view
 */
@property (weak, nonatomic) IBOutlet UIView *hasRecordsView;
/**
 *  报销记录 数据
 */
@property (weak, nonatomic) IBOutlet UITableView *recordsTableView;
@property (nonatomic, strong) NSMutableArray<HNAExpenseRecordModel *> *records;

/**
 *  申请报销 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *applyExpenseButton;
- (IBAction)applyExpenseButtonClicked:(UIButton *)sender;
/**
 *  商业医保报销说明按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *directionButton;
- (IBAction)expensesDirectionsBtnClicked:(UIButton *)sender;
/**
 *  商业医保报销纪录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *expenseRecordsButton;
- (IBAction)expensesRecordsBtnClicked:(UIButton *)sender;
@end

@implementation HNAHomeController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 1.设置控制器
    self.title = @"医保报销";
    
    // 2.设置tipView
    [self setupTipView];
    
    // 3.设置报销记录tableView
    [self setupRecordsTableView];
    
    // 4.设置通知
    [self setupNotification];
    
    // 5.设置banner
    [self setupBanner];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 显示tipView
    [self.tipView show];
}
/**
 *  设置“修改密码提示”view
 */
- (void)setupTipView{
    // 1.创建tipView
    HNAHomeTipView *tipView = [HNAHomeTipView tipViewWithChangeCipher:^{
        [self performSegueWithIdentifier:Home2ChangeCipherSegue sender:nil];
    }];
    tipView.superViewDuplicate = self.view;
    self.tipView = tipView;
}
/**
 *  设置 报销记录tableView
 */
- (void)setupRecordsTableView {
    // 注册cell
    [self.recordsTableView registerNib:[UINib nibWithNibName:@"HNAExpensesRecordCell" bundle:nil] forCellReuseIdentifier:@"HNAExpensesRecordCell"];
    // 加载数据
    [self loadExpenseRecords];
}
/**
 *  设置通知
 */
- (void)setupNotification {
    // 先移除再添加
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expenseDirectionControllerDidEndDragging) name:ExpenseDirectionControllerDidEndDraggingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expenseDirectionControllerHasNoData) name:ExpenseDierectionControllerHasNoData object:nil];

}
/**
 *  设置申请报销按钮（大图banner）
 */
- (void)setupBanner {
    if ([HNAUserTool user].insuranceCompanyId && [HNAUserTool user].insuranceCompanyId >= 0) {
        [self.applyExpenseButton setBackgroundImage:[UIImage imageWithName:@"home_banner_1"] forState:UIControlStateNormal];
    } else {
        [self.applyExpenseButton setBackgroundImage:[UIImage imageWithName:@"home_banner_2"] forState:UIControlStateNormal];
    }
}
#pragma mark - 响应通知
/**
 *  报销说明控制器 停止拖动
 */
- (void)expenseDirectionControllerDidEndDragging {
    if (![[self.navigationController.childViewControllers lastObject] isKindOfClass:[HNAExpensesDirectionsController class]]) {
        HNAExpensesDirectionsController *vc = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAExpensesDirectionsController"];
        [self.navigationController pushViewController:vc animated:YES];
//        [self performSegueWithIdentifier: Home2MedicalDirectionSegue sender:nil];
    }
}
/**
 *  报销说明控制器 没有数据
 */
- (void)expenseDirectionControllerHasNoData {
    if (![[self.navigationController.childViewControllers lastObject] isKindOfClass:[HNAExpensesDirectionsController class]]) {
        self.noRecordsView.hidden = YES;
        self.hasRecordsViewConstraint_Top.constant = self.noRecordsViewConstraint_Top.constant;
    }
}
#pragma mark - 数据
- (NSMutableArray<HNAExpenseRecordModel *> *)records {
    if (_records == nil) {
        _records = [NSMutableArray array];
    }
    return _records;
}

/**
 *  加载报销记录
 */
- (void)loadExpenseRecords {
    HNAGetExpenseRecordsParam *param = [HNAGetExpenseRecordsParam param];
    [HNAInsuranceTool getExpenseRecordsWithParam:param success:^(HNAGetExpenseRecordsResult *result) {
        if (result == nil || result.records.count < 1) {
            self.hasRecordsView.hidden = YES;
        } else {
            [self.records addObjectsFromArray: result.records];
            [self.recordsTableView reloadData];
            self.hasRecordsView.hidden = NO;
        }
        self.hasRecordsView.hidden = NO;
    } failure:^(NSError *error) {
        self.hasRecordsView.hidden = NO;
        [MBProgressHUD showError:@"加载医保报销记录失败"];
    }];
}

#pragma mark - scrollView事件
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self expensesRecordsBtnClicked:nil];
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.records.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idenfitifer = @"HNAExpensesRecordCell";
    HNAExpensesRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfitifer];
    cell.model = self.records[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - 按钮点击事件
/**
 *  申请医保报销按钮
 */
- (IBAction)applyExpenseButtonClicked:(UIButton *)sender {
    [self performSegueWithIdentifier:Home2ApplyExpenseSegue sender:nil];
}

/**
 *  医保报销说明按钮点击事件
 */
- (IBAction)expensesDirectionsBtnClicked:(UIButton *)sender {
    // 如果有记录view是隐藏的，就直接跳转，而不添加动画
    if (self.hasRecordsView.hidden == YES) {
        // 跳转到医保报销说明页
        [self performSegueWithIdentifier:Home2MedicalDirectionSegue sender:nil];
        return;
    }
    CGFloat hasRecordsViewConstraint_Top = self.hasRecordsViewConstraint_Top.constant;
    CGFloat noRecordsViewConstraint_Top = self.noRecordsViewConstraint_Top.constant;
    self.hasRecordsViewConstraint_Top.constant = self.view.frame.size.height;
    self.noRecordsViewConstraint_Top.constant = 64.0;
    self.tipView.alpha = 0.0;
    self.view.userInteractionEnabled = NO;
    
    WEAKSELF(weakSelf);
    [UIView animateWithDuration:1.0f animations:^{
        [weakSelf.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        // 跳转到医保报销说明页
        [self performSegueWithIdentifier:Home2MedicalDirectionSegue sender:nil];
        // 恢复动画前的相关属性
        weakSelf.hasRecordsViewConstraint_Top.constant = hasRecordsViewConstraint_Top;
        weakSelf.noRecordsViewConstraint_Top.constant = noRecordsViewConstraint_Top;
        weakSelf.view.userInteractionEnabled = YES;
    }];
}
/**
 *  商业医保报销纪录 按钮点击事件
 */
- (IBAction)expensesRecordsBtnClicked:(UIButton *)sender {
    HNALog(@"%ld", (long)self.navigationController.childViewControllers.count);
    [self performSegueWithIdentifier:Home2MedicalRecordsSegue sender:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ExpenseDirectionControllerDidEndDraggingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ExpenseDierectionControllerHasNoData object:nil];
}
@end

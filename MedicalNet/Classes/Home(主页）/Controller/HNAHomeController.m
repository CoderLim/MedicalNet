//
//  HNAHomeController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAHomeController.h"
#import "HNAHomeTipView.h"
#import "HNAChangeCipherController.h"
#import "HNAExpensesRecordsController.h"
#import "HNAExpensesDirectionsController.h"
#import "HNAPortraitButton.h"
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

@interface HNAHomeController() <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate> {
}
/**
 *  tipview的top约束
 */
@property (nonatomic,weak) NSLayoutConstraint *tipViewConstraint_Top;
/**
 *  没记录view的top约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noRecordsViewConstraint_Top;
/**
 *  有记录view的top约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hasRecordsViewConstraint_Top;

/**
 *  导航栏按钮点击
 */
- (IBAction)healthCheckupBtnClick:(UIButton *)sender;
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
 *  头像
 */
@property (weak, nonatomic) IBOutlet HNAPortraitButton *portraitBtn;

/**
 *  商业医保报销说明按钮点击
 */
- (IBAction)expensesDirectionsBtnClicked:(UIButton *)sender;
/**
 *  商业医保报销纪录按钮点击
 */
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expenseRecordsControllerDidEndDragging) name:ExpenseRecordsControllerDidEndDraggingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expenseDirectionControllerDidEndDragging) name:ExpenseDirectionControllerDidEndDraggingNotification object:nil];
}

#pragma mark - 响应通知
/**
 *  报销记录控制器 停止拖动
 */
- (void)expenseRecordsControllerDidEndDragging {
    if (![[self.navigationController.childViewControllers lastObject] isKindOfClass:[HNAExpensesRecordsController class]]) {
        [self performSegueWithIdentifier:Home2MedicalRecordsSegue sender:nil];
    }
}
/**
 *  报销说明控制器 停止拖动
 */
- (void)expenseDirectionControllerDidEndDragging {
    HNALog(@"%ld", (long)self.navigationController.childViewControllers.count);
    if (![[self.navigationController.childViewControllers lastObject] isKindOfClass:[HNAExpensesDirectionsController class]]) {
        [self performSegueWithIdentifier: Home2MedicalDirectionSegue sender:nil];
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
 *  加载医保说明
 */
- (void)loadMedicalDirection {
    NSString *companyId = [HNAUserTool user].companyId;
    [HNAInsuranceTool getExpenseDirectionsWithCompanyId:companyId success:^(HNAGetExpenseDirectionResult *result) {
        if (result != nil) {
            HNALog(@"有报销说明");
            self.noRecordsView.hidden = NO;
        } else {
            self.noRecordsView.hidden = YES;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError: MessageWhenFaild];
    }];
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
    } failure:^(NSError *error) {
        self.hasRecordsView.hidden = YES;
        [MBProgressHUD showError:@"加载医保报销记录失败"];
    }];
}
#pragma mark - 导航栏按钮事件
- (IBAction)healthCheckupBtnClick:(UIButton *)sender {
    UINavigationController *healthCheckupNav = [MainStoryboard instantiateViewControllerWithIdentifier:@"HealthCheckup"];
    KeyWindow.rootViewController = healthCheckupNav;
    
    CATransition *ca = [CATransition animation];
    // 设置过度效果
    ca.type = @"oglFlip";
    // 设置动画的过度方向（向右）
    ca.subtype=kCATransitionFromRight;
    // 设置动画的时间
    ca.duration=.45;
    [KeyWindow.layer addAnimation:ca forKey:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ExpenseRecordsControllerDidEndDraggingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ExpenseDirectionControllerDidEndDraggingNotification object:nil];
}
@end

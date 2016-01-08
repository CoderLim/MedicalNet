//
//  HNAExpensesDirectionsController.m
//  MedicalNet
//
//  Created by gengliming on 15/12/8.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAExpensesDirectionsController.h"
#import "HNAExpenseDirectionModel.h"
#import "HNAProjectCell.h"
#import "MJExtension.h"
#import "HNAInsuranceTool.h"
#import "HNAExpenseDirectionModel.h"
#import "HNAInsuranceTool.h"
#import "HNAUserTool.h"
#import "HNAUser.h"
#import "MBProgressHUD+MJ.h"

// KeyPath
#define KPContentSize @"contentSize"

@interface HNAExpensesDirectionsController () <UITableViewDelegate,UITableViewDataSource>{
    BOOL _showMoreHospital;
}

/**
 *  保障方案
 */
@property (weak, nonatomic) IBOutlet UITableView *projectTableView;
/**
 *  理赔所需材料
 */
@property (weak, nonatomic) IBOutlet UITableView *materialTableView;
/**
 *  可报销医院
 */
@property (weak, nonatomic) IBOutlet UITableView *hospitalTableView;

- (IBAction)moreHospitalBtnClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitButtonClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *projectTableViewConstraint_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *materialTableViewConstraint_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hospitalTableViewConstraint_H;

@property (strong, nonatomic) NSMutableArray *materialArray;
@property (strong, nonatomic) NSMutableArray<HNASecurityProgram *> *projectArray;
@property (strong, nonatomic) NSMutableArray *hospitalArray;

@end

@implementation HNAExpensesDirectionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _showMoreHospital = NO;
    
    // 根据数据量动态调整tableView的高度约束
    [self.materialTableView addObserver:self forKeyPath:KPContentSize options:NSKeyValueObservingOptionNew context:nil];
    [self.projectTableView addObserver:self forKeyPath:KPContentSize options:NSKeyValueObservingOptionNew context:nil];
    [self.hospitalTableView addObserver:self forKeyPath:KPContentSize options:NSKeyValueObservingOptionNew context:nil];
    
    // 加载数据
    [self loadData];
    
    // 再重新布局一遍
    // 因为通过addObserve设置三个tableView后，布局没调整过来
//    [self.view layoutIfNeeded];
    
    // 初始化［提交］按钮
    self.submitButton.layer.cornerRadius = self.submitButton.frame.size.height*0.5;
    self.submitButton.layer.shadowOffset = CGSizeMake(5, 5);
    self.submitButton.layer.shadowOpacity = 0.5;
    self.submitButton.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (NSMutableArray *)materialArray{
    if (_materialArray == nil) {
        _materialArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i++) {
            [_materialArray addObject:[NSString stringWithFormat:@"%ld)1341431431431413431",(long)i]];
        }
    }
    return _materialArray;
}

- (NSMutableArray<HNASecurityProgram *> *)projectArray{
    if (_projectArray == nil) {
        _projectArray = [NSMutableArray array];
        
        HNASecurityProgram *model2 = [[HNASecurityProgram alloc] init];
        model2.item = @"重大疾病";
        model2.amount = @"10万元";
        
        HNASecurityProgram *model3 = [[HNASecurityProgram alloc] init];
        model3.item = @"人身意外伤害责任";
        model3.amount = @"20万元";
        
        HNASecurityProgram *model4 = [[HNASecurityProgram alloc] init];
        model4.item = @"子女团体医疗";
        model4.amount = @"医疗0元，住院400（0元免赔，50%赔付）";
        
        _projectArray = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:model2, model3, model4, nil]];
    }
    return _projectArray;
}

- (NSMutableArray *)hospitalArray{
    if (_hospitalArray == nil) {
        _hospitalArray = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 10; i++) {
            [_hospitalArray addObject: [NSString stringWithFormat:@"医院%ld",(long)i]];
        }
    }
    return _hospitalArray;
}

/**
 *  加载数据
 */
- (void)loadData{
    // 1.参数
    NSString *companyId = [HNAUserTool user].companyId;
    if (companyId == nil) {
        [MBProgressHUD showError:@"companyId为nil"];
        return;
    }
    
    // 2.请求
    WEAKSELF(weakSelf);
    [HNAInsuranceTool getExpenseDirectionsWithCompanyId:companyId success:^(HNAExpenseDirectionModel *direction) {
        if (direction != nil) {
            weakSelf.projectArray = direction.securityPrograms;
            weakSelf.materialArray = direction.materials;
            weakSelf.hospitalArray = direction.hospitals;
            [MBProgressHUD showSuccess:@"获取成功"];
            
            // 3.刷新数据
            [weakSelf.projectTableView reloadData];
            [weakSelf.materialTableView reloadData];
            [weakSelf.hospitalTableView reloadData];
        } else {
            [MBProgressHUD showError:@"没有数据"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求异常"];
    }];
    
    }

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.materialTableView) {
        return self.materialArray.count;
    } else if (tableView == self.projectTableView){
        return self.projectArray.count;
    } else if (tableView == self.hospitalTableView) {
        if (_showMoreHospital == NO) {
            return 3;
        }
        return self.hospitalArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.materialTableView) { // 报销所需材料
        return [self materialCellForRowAtIndexPath:indexPath withTableView:tableView];
    } else if (tableView == self.projectTableView) { // 保障方案
        return [self projectCellForRowAtIndexPath:indexPath withTableView:tableView];
    } else if (tableView == self.hospitalTableView){  // 可报销医院
        return [self hospitalCellForRowAtIndexPath:indexPath withTableView:tableView];
    }
    return nil;
}

// 材料 cell
- (UITableViewCell *)materialCellForRowAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView{
    static NSString *materialIdentifier = @"materialCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:materialIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleDefault reuseIdentifier:materialIdentifier];
    }
    cell.textLabel.text = self.materialArray[indexPath.row];
    return cell;
}

// 保障方案 cell
- (HNAProjectCell *)projectCellForRowAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView{
    static NSString *projectIdentifier = @"projectCell";
    
    HNAProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:projectIdentifier];
    cell.model = self.projectArray[indexPath.row];
    return cell;
}

// 可报销医院 cell
- (UITableViewCell *)hospitalCellForRowAtIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView{
    static NSString *hospitalIdentifier = @"hospitalCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hospitalIdentifier];
    cell.textLabel.text = self.hospitalArray[indexPath.row];
    return cell;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if (![keyPath isEqualToString: KPContentSize])  return;
    
    CGSize contentSize;
    contentSize = [change[NSKeyValueChangeNewKey] CGSizeValue];
    if (object == self.materialTableView) {
        self.materialTableViewConstraint_H.constant = contentSize.height;
    } else if (object == self.projectTableView) {
        self.projectTableViewConstraint_H.constant = contentSize.height;
    } else if  (object == self.hospitalTableView) {
        self.hospitalTableViewConstraint_H.constant = contentSize.height;
    }

    [self.view layoutIfNeeded];
}

- (void)dealloc{
    [self.materialTableView removeObserver:self forKeyPath: KPContentSize];
    [self.projectTableView removeObserver:self forKeyPath: KPContentSize];
    [self.hospitalTableView removeObserver:self forKeyPath: KPContentSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


// 可报销医院－查看更多
- (IBAction)moreHospitalBtnClicked:(UIButton *)sender {
    _showMoreHospital = !_showMoreHospital;
    [self.hospitalTableView reloadData];
}
- (IBAction)submitButtonClicked:(UIButton *)sender {
}
@end

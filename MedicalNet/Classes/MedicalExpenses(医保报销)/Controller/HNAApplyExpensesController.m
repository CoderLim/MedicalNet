//
//  HNAApplyExpensesController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/23.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAApplyExpensesController.h"
#import "HNAImagePickerView.h"
#import "HNAApplyExpenseParam.h"
#import "HNAInsuranceTool.h"
#import "MBProgressHUD+MJ.h"
#import "HNAApplySuccessController.h"
#import "HNAResult.h"
#import "MJExtension.h"
#import "HNAImagePickersScrollView.h"
#import "MedicalNet-swift.h"

#define TextField2KeyboardMargin 40

#define ApplyExpense2ApplySuccessSegue @"applyExpense2applySuccess"


@interface HNAApplyExpensesController() <UITextFieldDelegate,HNAImagePickersScrollViewDelegate>{
    UITextField *_currentEditTextField;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

/**
 *   保险公司名称
 */
@property (weak, nonatomic) IBOutlet UILabel *insuranceComNameLabel;
/**
 *  申请人姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *applicantNameLabel;
/**
 *  联系方式
 */
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;

/**
 *  所有选择图片控件
 */
@property (strong, nonatomic) IBOutletCollection(HNAImagePickersScrollView) NSArray *imagePickersScrollViews;

/**
 *  花费总额
 */
@property (weak, nonatomic) IBOutlet UITextField *amountField;
 /**
 *  银行卡号
 */
@property (weak, nonatomic) IBOutlet UITextField *cardNumField;

/**
 *  提交
 */
- (IBAction)submit:(UIButton *)sender;
@end

@implementation HNAApplyExpensesController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentView:)];
    [self.contentView addGestureRecognizer: tap];
    
    // 监听键盘的弹出与收回
    [DefaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [DefaultCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 按钮事件
/**
 *  提交
 */
- (IBAction)submit:(UIButton *)sender {
    [self performSegueWithIdentifier:ApplyExpense2ApplySuccessSegue sender:nil];
    return;
    // 得到当前user信息
    HNAUser *currentUser = [HNAUserTool user];
    
    // 构造网络请求参数
    HNAApplyExpenseParam *param = [HNAApplyExpenseParam param];
    param.cardNum = self.cardNumField.text;
    param.cardNum = @"00000000";
    
    HNALog(@"%@",param.companyId);
    // 网络请求
    [HNAInsuranceTool applyExpenseWithParam:param success:^(HNAResult *result) {
        if (result.success == HNARequestResultSUCCESS) {
            [self performSegueWithIdentifier:ApplyExpense2ApplySuccessSegue sender:nil];
        } else {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",result.errorInfo]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"error:%@",error]];
    }];
}

#pragma mark - 手势
- (void)tapContentView:(UITapGestureRecognizer *)tap {
    [self.contentView endEditing:YES];
}

#pragma mark - UITextFieldDelegate 
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _currentEditTextField = textField;
}

#pragma mark - HNAImagePickersScrollViewDelegate
- (BOOL)imagePickersScrollViewWillSelectImage:(HNAImagePickersScrollView *)imagePickerScrollView {
    [self.contentView endEditing:YES];
    return YES;
}

#pragma mark - 通知
- (void)keyboardWillShow:(NSNotification *)aNotification{
    self.contentView.transform = CGAffineTransformIdentity;
    
    HNALog(@"%@",NSStringFromCGPoint(self.mainScrollView.contentOffset));
    NSDictionary *userInfo = [aNotification userInfo];
    // 键盘frame
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 当前编辑的输入框frame(self.view坐标系）
    CGRect currentTextFieldFrame = [_currentEditTextField.superview convertRect:_currentEditTextField.frame toView: KeyWindow];
    // 计算self.view需要移动的距离
    CGFloat deltaY = keyboardFrame.origin.y - (currentTextFieldFrame.size.height+currentTextFieldFrame.origin.y) - TextField2KeyboardMargin;
    
    HNALog(@"%f",deltaY);
    self.contentView.transform = CGAffineTransformMakeTranslation(0, deltaY);
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    self.contentView.transform = CGAffineTransformIdentity;
}

- (void)dealloc {
    [DefaultCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [DefaultCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end

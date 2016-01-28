//
//  HNALoginController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNALoginController.h"
#import "HNAHomeController.h"
#import "UIView+HNA.h"
#import "HNAUser.h"
#import "HNAUserTool.h"
#import "MBProgressHUD+MJ.h"
#import "HNALoginInfoParam.h"
#import "HNALoginInfoResult.h"
#import "HNALoginTool.h"
#import "HNAForgetCipherController.h"
#import "HNAImagePickersScrollView.h"

#import "HNATabBarController.h"

#import "HNAHttpTool.h"

#define CurrentTextField2KeyboardPadding 40

#define Login2ForgetCipherSegue @"login2forgetCipher"

@interface HNALoginController() <UITextFieldDelegate,NSURLSessionDelegate>{
    __weak UITextField *_currentEditTextField;
}
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *cipherTextField;
@property (weak, nonatomic) UIView *test;
- (IBAction)loginBtnClick:(UIButton *)sender;
@end

@implementation HNALoginController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 设置导航条
    self.navigationItem.title = @"登录";
    
    // 设置LoginView
    CALayer *loginViewLayer = self.loginView.layer;
    loginViewLayer.cornerRadius = 20;
    loginViewLayer.frame = CGRectInset(self.loginView.frame, 20, 20);
    loginViewLayer.shadowOffset = CGSizeMake(0,5);
    loginViewLayer.shadowRadius = 5.0;
    loginViewLayer.shadowColor = [UIColor blackColor].CGColor;
    loginViewLayer.shadowOpacity = 0.8;
    
    // 监听键盘的弹出与收回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 监听TextField的TextChange
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [self textFieldTextChanged:nil];
}

- (IBAction)loginBtnClick:(UIButton *)sender {
    [MBProgressHUD showMessage:@"正在登录"];
    
    NSString *username = self.phoneTextField.text;
    NSString *password = self.cipherTextField.text;
    
    // 登录参数
    HNALoginInfoParam *param = [[HNALoginInfoParam alloc] init];
    param.username = username;
    param.password = password;
    
    WEAKSELF(weakSelf);
    [HNALoginTool loginWithParam:param success:^(HNALoginInfoResult *result) {
        [MBProgressHUD hideHUD];
        if (result.success == HNARequestResultSUCCESS) {
            HNATabBarController *tabBarController = [MainStoryboard instantiateViewControllerWithIdentifier:@"tabBarController"];
            KeyWindow.rootViewController = tabBarController;
            
            CATransition *ca = [CATransition animation];
            // 设置过度效果
            ca.type= kCATransitionPush;
            // 设置动画的过度方向（向右）
            ca.subtype=kCATransitionFromRight;
            // 设置动画的时间
            ca.duration=.25;
            // 设置动画的起点
            ca.startProgress = 0.5;
            [KeyWindow.layer addAnimation:ca forKey:nil];
        } else {
            [MBProgressHUD showError:@"账号或密码不正确"];
            [weakSelf.loginView shakeWithAmplitude:20];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

#pragma mark - 键盘
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    // 键盘frame
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 键盘动画持续时间
    NSNumber *keyboardAnimationDuration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    // 键盘动画曲线
    NSNumber  *keyboardAnimationCurve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 当前编辑的输入框frame(self.view坐标系）
    // 注意：下面的XX.superview不要写成XX
    CGRect currentTextFieldFrame = [_currentEditTextField.superview convertRect:_currentEditTextField.frame toView: KeyWindow];
    
    // 计算self.view需要移动的距离
    CGRect viewBounds = self.view.bounds;
    CGFloat deltaY = keyboardFrame.origin.y - currentTextFieldFrame.size.height - currentTextFieldFrame.origin.y - CurrentTextField2KeyboardPadding;
    viewBounds.origin.y += -deltaY;
    self.view.bounds = viewBounds;
    
    // 设置动画
    WEAKSELF(weakSelf);
    [UIView setAnimationCurve:[keyboardAnimationCurve intValue]];
    [UIView animateWithDuration:[keyboardAnimationDuration doubleValue] animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    // 键盘动画持续时间
    NSNumber *keyboardAnimationDuration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    // 键盘动画曲线
    NSNumber  *keyboardAnimationCurve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect viewBounds = self.view.bounds;
    viewBounds.origin.y = 0;
    self.view.bounds = viewBounds;
    
    WEAKSELF(weakSelf);
    [UIView setAnimationCurve:[keyboardAnimationCurve intValue]];
    [UIView animateWithDuration:[keyboardAnimationDuration doubleValue] animations:^{
        [weakSelf.view layoutIfNeeded];
    }];
}

#pragma mark - textField 代理
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _currentEditTextField = textField;
}

#pragma mark - textField 通知
- (void)textFieldTextChanged:(NSNotification *)aNotification{
    self.loginBtn.enabled = self.phoneTextField.text.length > 0 && self.cipherTextField.text.length > 0;
}

#pragma mark - view 事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end

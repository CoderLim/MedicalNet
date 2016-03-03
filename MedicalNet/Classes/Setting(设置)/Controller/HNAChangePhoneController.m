//
//  HNAChangePhoneController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAChangePhoneController.h"
#import "HNAChangePhoneParam.h"
#import "HNAUserTool.h"
#import "HNAUser.h"
#import "MBProgressHUD+MJ.h"

@interface HNAChangePhoneController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *validationCodeField;
@property (weak, nonatomic) IBOutlet UIButton *getValidationCodeBtn;
- (IBAction)getValidationCodeBtnClicked:(UIButton *)sender;

@end

@implementation HNAChangePhoneController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 响应键盘Return按钮
    WEAKSELF(weakSelf);
    self.keyboardNextBtnClicked = ^{
        [weakSelf.validationCodeField becomeFirstResponder];
    };
}

#pragma mark - Private
- (void)textFieldTextChanged:(NSNotification *)notification{
    self.getValidationCodeBtn.enabled = self.phoneField.text.length > 0;
    self.navRightBtnEnabled = self.phoneField.text.length > 0 && self.validationCodeField.text.length > 0;
}

- (void)saveOperation{
    [MBProgressHUD showMessage:@"正在修改手机号"];
    // 1.拼修改手机号的参数
    HNAChangePhoneParam *param = [HNAChangePhoneParam param];
    param.theNewPhoneNum = self.phoneField.text;
    
    // 2.请求地址
    [HNAUserTool changePhoneWithParam:param success:^(HNAResult *result) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"修改手机号成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

#pragma mark - IBActions
- (IBAction)getValidationCodeBtnClicked:(UIButton *)sender {
    
}
@end

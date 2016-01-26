//
//  HNAChangeCipherController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/20.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

// 修改密码

#import "HNAChangeCipherController.h"
#import "HNAChangePwdParam.h"
#import "HNAForgetPwdParam.h"
#import "HNAUserTool.h"
#import "HNAUser.h"
#import "MBProgressHUD+MJ.h"

@interface HNAChangeCipherController ()
@property (weak, nonatomic) IBOutlet UITextField *cipherField;
@property (weak, nonatomic) IBOutlet UITextField *confirmCipherField;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *oldCipher;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldCipher_Top;

@end

@implementation HNAChangeCipherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    WEAKSELF(weakSelf);
    self.keyboardNextBtnClicked = ^{
        [weakSelf.confirmCipherField becomeFirstResponder];
    };
    
    if (self.type == HNAChangeCipherControllerTypeViaPhoneValidation) {
        self.oldCipher.hidden = YES;
        self.oldCipher_Top.constant = 0;
    }
}

- (void)textFieldTextChanged:(NSNotification *)notification{
    self.navRightBtnEnabled = self.cipherField.text.length > 0 && self.confirmCipherField.text.length > 0;
}

- (void)saveOperation{
    if (self.type == HNAChangeCipherControllerTypeDefault) {
        [self changePwd];
    } else {
        [self forgetPwd];
    }
}
/**
 *  修改密码
 */
- (void)changePwd {
    // 1.拼修改密码的参数
    HNAChangePwdParam *param = [HNAChangePwdParam param];
    param.theOldPwd = self.oldCipher.text;
    param.theNewPwd = self.cipherField.text;
    
    // 3.请求地址
    [HNAUserTool changePwdWithParam:param success:^(HNAResult *result) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserDefaultsShouldHideTipView];
        
        [MBProgressHUD showSuccess:@"修改成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        [self.cipherField becomeFirstResponder];
    }];
}
/**
 *  忘记密码
 */
- (void)forgetPwd {
    // 拼忘记密码的参数
    HNAForgetPwdParam *param = [HNAForgetPwdParam param];
    param.theNewPwd = self.cipherField.text;
    
    // 调接口
    [HNAUserTool forgetPwdWithParam:param success:^(HNAResult *result) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:UserDefaultsShouldHideTipView];
        [MBProgressHUD showSuccess:@"修改成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        [self.cipherField becomeFirstResponder];
    }];
}

@end

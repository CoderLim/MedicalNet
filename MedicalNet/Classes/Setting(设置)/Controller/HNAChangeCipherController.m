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
#import "HNAUserTool.h"
#import "HNAUser.h"
#import "MBProgressHUD+MJ.h"

@interface HNAChangeCipherController ()
@property (weak, nonatomic) IBOutlet UITextField *cipherField;
@property (weak, nonatomic) IBOutlet UITextField *confirmCipherField;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation HNAChangeCipherController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WEAKSELF(weakSelf);
    self.keyboardNextBtnClicked = ^{
        [weakSelf.confirmCipherField becomeFirstResponder];
    };
}

- (void)textFieldTextChanged:(NSNotification *)notification{
    self.navRightBtnEnabled = self.cipherField.text.length > 0 && self.confirmCipherField.text.length > 0;
}

- (void)saveOperation{
    // 1.获取登录用户信息
    HNAUser *user = [HNAUserTool user];
    if (user == nil) {
        [MBProgressHUD showError:@"账号没有正常登录"];
        return;
    }

    // 2.拼修改密码的参数
    HNAChangePwdParam *param = [[HNAChangePwdParam alloc] init];
    param.id = user.id;
    param.theOldPwd = @"";
    param.theNewPwd = self.cipherField.text;
    
    // 3.请求地址
    [HNAUserTool changePwdWithParam:param success:^(HNAResult *result) {
        [MBProgressHUD showSuccess:@"修改成功"];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        [self.cipherField becomeFirstResponder];
    }];
}

@end

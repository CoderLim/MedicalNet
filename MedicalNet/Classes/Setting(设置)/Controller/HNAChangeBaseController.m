//
//  HNAChangeBaseController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/30.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAChangeBaseController.h"
#import "HNAMutiStateButton.h"
#import "objc/message.h"

@interface HNAChangeBaseController () <UITextFieldDelegate>{
    __weak HNAMutiStateButton *_navRightBtn;
}
@end

@implementation HNAChangeBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航控制器
    HNAMutiStateButton *rightBtn = [HNAMutiStateButton buttonWithType: UIButtonTypeCustom];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor: HNANavDisabledBtnTextColor forState:UIControlStateDisabled];
    [rightBtn setBackgroundColor: HNANavNormalBtnBgColor forState:UIControlStateNormal];
    [rightBtn setBackgroundColor: HNANavNormalBtnBgColor forState:UIControlStateDisabled];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 50, 30);
    [rightBtn addTarget:self action:@selector(saveOperation) forControlEvents : UIControlEventTouchUpInside];
    _navRightBtn = rightBtn;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    _navRightBtn.enabled = NO;
    
    // 添加监听textField文本变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setNavRightBtnEnabled:(BOOL)navRightBtnEnabled{
    [_navRightBtn setEnabled:navRightBtnEnabled];
}

#pragma mark - 通知
- (void)textFieldTextChanged:(NSNotification *)notification{
    
}

#pragma mark - 导航栏按钮事件
- (void)saveOperation{
    HNALog(@"%s %s", class_getName([self class]),__FUNCTION__);
}

#pragma mark - TextField 代理事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.returnKeyType == UIReturnKeyNext) {
        if (self.keyboardNextBtnClicked) {
            self.keyboardNextBtnClicked();
        }
    } else if (textField.returnKeyType == UIReturnKeyDone || textField.returnKeyType == UIReturnKeyGo){
        if (self.keyboardDoneOrGoBtnClicked != nil) {
            self.keyboardDoneOrGoBtnClicked();
        } else {
            [self saveOperation];
        }
    }
    return YES;
}

#pragma mark - 触摸事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"textFieldTextChanged" object:nil];
}
@end

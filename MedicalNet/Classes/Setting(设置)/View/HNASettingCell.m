//
//  HNASettingCell.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNASettingCell.h"
#import "HNASettingItem.h"
#import "HNASettingArrowItem.h"
#import "HNASettingSwitchItem.h"
#import "HNASetMsgNoticeParam.h"
#import "HNAUserTool.h"
#import "HNAUser.h"
#import "MBProgressHUD+MJ.h"
#import "HNAResult.h"


@interface HNASettingCell()

@property (nonatomic,strong) UISwitch *switchView;

@end

@implementation HNASettingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"SettingCell";
    HNASettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    return cell;
}

#pragma mark - Custom Accessors
-(UISwitch *)switchView{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchViewChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (void)setItem:(HNASettingItem *)item{
    _item = item;
    self.textLabel.text = item.title;
    
    if ([item isKindOfClass:[HNASettingArrowItem class]]) {
        
    } else if ([item isKindOfClass:[HNASettingSwitchItem class]]){
        self.accessoryView = self.switchView;
        self.switchView.on = [[NSUserDefaults standardUserDefaults] boolForKey:self.item.title];
    }
}

#pragma mark - Private
- (void)switchViewChanged:(UISwitch *)switchView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:switchView.isOn forKey:self.item.title];
    
    [self setMsgNoticeWithItem:self.item isOn:switchView.isOn];
}

- (void)setMsgNoticeWithItem:(HNASettingItem *)item isOn:(BOOL)on{
    // 1.获取登录用户信息
    HNAUser *user = [HNAUserTool user];
    if (user == nil) {
        [MBProgressHUD showError:@"账号没有正常登录"];
        return;
    }
    // 2.拼修改密码的参数
    HNASetMsgNoticeParam *param = [[HNASetMsgNoticeParam alloc] init];
    param.id = user.id;
    if ([item.title isEqualToString: @"体检通知"]) {
        param.medicalNotice = on ? @"1" : @"0";
    } else if ([item.title isEqualToString: @"报销通知"]){
        param.expenseNotice =  on ? @"1" : @"0";
    }
    // 3.请求地址
    [HNAUserTool setMsgNoticeWithParam:param success:^(HNAResult *result) {
        if (result.success==HNARequestResultSUCCESS) {
            [MBProgressHUD showSuccess:@"修改成功"];
        } else {
            [MBProgressHUD showError:@"修改失败了"];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

@end

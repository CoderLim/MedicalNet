//
//  HNAApplySuccessController.m
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAApplySuccessController.h"
#import "HNAInsuranceTool.h"
#import "HNAGetInsuranceCompanyResult.h"

@interface HNAApplySuccessController()

@property (weak, nonatomic) IBOutlet UIImageView *topBgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *middleBgImageView;

@property (weak, nonatomic) IBOutlet UILabel *insuranceComNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@end
@implementation HNAApplySuccessController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请成功";

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self loadInsuranceCompnayData];
}

/**
 *  加载保险公司数据
 */
- (void)loadInsuranceCompnayData {
    [MBProgressHUD showMessage: MessageWhenLoadingData];
    
    [HNAInsuranceTool getInsuranceCompayWithId:[HNAUserTool user].insuranceCompanyId success:^(HNAGetInsuranceCompanyResult *result) {
        [MBProgressHUD hideHUD];
        if (result.success == HNARequestResultSUCCESS && result.insuranceCompany.insuranceCompanyId!=nil) {
            HNAInsuranceCompanyModel *insuranceCompany = result.insuranceCompany;
            self.insuranceComNameLabel.text = insuranceCompany.name;
            self.addrLabel.text = insuranceCompany.addr;
            self.phoneLabel.text = insuranceCompany.phone;
            self.codeLabel.text = insuranceCompany.code;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:MessageWhenFaild];
    }];
}
@end

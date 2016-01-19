//
//  HNAApplySuccessController.m
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAApplySuccessController.h"
#import "HNAInsuranceTool.h"
#import "HNAInsuranceCompanyModel.h"

@interface HNAApplySuccessController()

@end
@implementation HNAApplySuccessController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

/**
 *  加载保险公司数据
 */
- (void)loadInsuranceCompnayData {
    [HNAInsuranceTool getInsuranceCompayWithId:[HNAUserTool user].insuranceCompanyId success:^(HNAInsuranceCompanyModel *insuranceCompany) {
        
    } failure:^(NSError *error) {
        
    }];
}
@end

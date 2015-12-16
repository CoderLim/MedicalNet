//
//  HNAHealthCheckDetailController.m
//  MedicalNet
//
//  Created by gengliming on 15/11/30.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAHealthCheckDetailController.h"
#import "HNAHCPackageDetailController.h"

@interface HNAHealthCheckDetailController ()
- (IBAction)checkPackageDetail:(UIButton *)sender;

@end

@implementation HNAHealthCheckDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)checkPackageDetail:(UIButton *)sender {
    HNAHCPackageDetailController *packageDetail = [MainStoryboard instantiateViewControllerWithIdentifier:@"HNAHCPackageDetailController"];
    [self.navigationController pushViewController:packageDetail animated:YES];
}
@end

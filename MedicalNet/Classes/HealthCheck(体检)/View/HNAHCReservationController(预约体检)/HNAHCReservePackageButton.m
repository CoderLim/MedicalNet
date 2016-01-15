//
//  HNAHCReservationPackageItem.m
//  MedicalNet
//
//  Created by gengliming on 16/1/11.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAHCReservePackageButton.h"

@implementation HNAHCReservePackageButton

- (void)setModel:(HNAPackageListItem *)model {
    _model = model;
    
    NSString *title = (model.packageName!=nil&&![model.packageName isEqualToString:@""])?model.packageName:@"无";
    [self setTitle:title forState:UIControlStateNormal];
}

+ (instancetype)packageButtonWithModel:(HNAPackageListItem *)model {
    HNAHCReservePackageButton *button  = [HNAHCReservePackageButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    button.model = model;
    return button;
}

@end

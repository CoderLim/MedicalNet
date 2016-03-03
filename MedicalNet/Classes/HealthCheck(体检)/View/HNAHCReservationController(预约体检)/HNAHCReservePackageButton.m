//
//  HNAHCReservationPackageItem.m
//  MedicalNet
//
//  Created by gengliming on 16/1/11.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAHCReservePackageButton.h"

#define BorderWidth 1

@interface HNAHCReservePackageButton()

@end

@implementation HNAHCReservePackageButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = BorderWidth;
    self.layer.borderColor = UIColorWithRGB(244, 244, 244).CGColor;
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
}

#pragma mark - Custom Accessors
- (void)setModel:(HNAPackageListItem *)model {
    _model = model;
    
    NSString *title = (model.packageName!=nil&&![model.packageName isEqualToString:@""])?model.packageName:@"无";
    [self setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Public
+ (instancetype)packageButtonWithModel:(HNAPackageListItem *)model {
    HNAHCReservePackageButton *button  = [HNAHCReservePackageButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:UIColorWithRGB(114, 115, 116) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.model = model;
    return button;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    UIColor *backgroundColor;
    if (selected == YES) {
        backgroundColor = UIColorWithRGB(237, 114, 74);
        self.layer.borderWidth = 0;
    } else {
        backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = BorderWidth;
    }
    [self setBackgroundColor:backgroundColor];
}

@end

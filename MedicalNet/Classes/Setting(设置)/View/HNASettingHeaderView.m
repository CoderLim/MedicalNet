//
//  HNASettingHeaderView.m
//  MedicalNet
//
//  Created by gengliming on 15/11/19.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNASettingHeaderView.h"
#import "HNAPortraitButton.h"
#import "UIButton+WebCache.h"


@interface HNASettingHeaderView()
@property (weak, nonatomic) IBOutlet HNAPortraitButton *portraitButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;

@end
@implementation HNASettingHeaderView
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
}

- (void)awakeFromNib {
    HNAUser *user = [HNAUserTool user];
    
    self.phoneLabel.text = user.phoneNum;
    self.nameLabel.text = user.name;
    self.companyNameLabel.text = user.companyName;
    
    [self refresh];
}

#pragma mark - 公开方法
- (void)refresh {
    NSURL *url = [NSURL URLWithString:[HNAUserTool user].icon];
    [self.portraitButton sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
}

@end

//
//  HNAPortraitButton.m
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAPortraitButton.h"

@interface HNAPortraitButton(){
    CGFloat _radius;
}

@end

@implementation HNAPortraitButton

#pragma mark - 初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.clipsToBounds = YES;
    
    CGSize size = self.bounds.size;
    _radius = MIN(size.width, size.height);
    
    self.layer.cornerRadius = _radius/2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor redColor].CGColor;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.bounds = CGRectMake(0, 0, _radius, _radius);
}

- (void)setHighlighted:(BOOL)highlighted{
}

@end

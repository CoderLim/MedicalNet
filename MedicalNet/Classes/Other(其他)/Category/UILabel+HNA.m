//
//  UILabel+HNA.m
//  MedicalNet
//
//  Created by gengliming on 15/12/18.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "UILabel+HNA.h"

@implementation UILabel (HNA)

- (CGFloat)hna_correctHeight{
    CGSize size = CGSizeMake(self.frame.size.width, INFINITY);
    return [self.text boundingRectWithSize: size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : self.font} context:nil].size.height;
}

- (CGSize)hna_textSize {
    CGSize size = CGSizeMake(self.frame.size.width, INFINITY);
    return [self.text boundingRectWithSize: size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : self.font} context:nil].size;
}

@end

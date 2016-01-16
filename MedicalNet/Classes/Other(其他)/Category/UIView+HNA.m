//
//  UIView+HNA.m
//  MedicalNet
//
//  Created by gengliming on 15/12/2.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "UIView+HNA.h"

@implementation UIView (HNA)

- (void)shakeWithAmplitude:(CGFloat)amplitudu{
    
    CGPoint currentPoint = self.center;
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.duration = 0.25;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    keyFrameAnimation.fillMode = kCAFillModeBoth;
    keyFrameAnimation.values = @[[NSValue valueWithCGPoint:CGPointMake(currentPoint.x - amplitudu, currentPoint.y)],
                                 [NSValue valueWithCGPoint:currentPoint],
                                 [NSValue valueWithCGPoint:CGPointMake(currentPoint.x + amplitudu, currentPoint.y)],
                                 [NSValue valueWithCGPoint:currentPoint],
                                 [NSValue valueWithCGPoint:CGPointMake(currentPoint.x - amplitudu / 2, currentPoint.y)],
                                 [NSValue valueWithCGPoint:currentPoint],
                                 [NSValue valueWithCGPoint:CGPointMake(currentPoint.x + amplitudu / 2, currentPoint.y)],
                                 [NSValue valueWithCGPoint:currentPoint],];
    [self.layer addAnimation:keyFrameAnimation forKey:@"shake"];

}

- (UIViewController *)viewController {
    for (UIView *next = [self superview]; next;next = next.superview) {
        UIResponder *responder = next.nextResponder;
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

@end

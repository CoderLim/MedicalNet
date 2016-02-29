//
//  HNAImagePickerProgressView.m
//  MedicalNet
//
//  Created by gengliming on 16/1/18.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAImagePickerProgressView.h"
#import "UIView+HNA.h"

#define ProgressLineWidth 5
#define ProgressLineColor [UIColor whiteColor].CGColor

@interface HNAImagePickerProgressView() <UIActionSheetDelegate>

@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, weak) CAShapeLayer *shapeLayer;

@end

@implementation HNAImagePickerProgressView

#pragma mark - 初始化
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
    self.backgroundColor = UIColorWithRGBA(0, 0, 0, 0.7f);
    // 添加长按手势
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(activityIndicatorViewLongPressed:)];
    [self addGestureRecognizer: longGesture];
    
    // 添加进度显示
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = ProgressLineColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = ProgressLineWidth;
    shapeLayer.lineCap = @"round";
    [self.layer insertSublayer:shapeLayer atIndex:0];
    self.shapeLayer = shapeLayer;
}

#pragma mark - life cycle
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.shapeLayer.frame = self.bounds;
}


#pragma mark -
- (UIBezierPath *)bezierPath {
    if (_bezierPath == nil) {
        _bezierPath = [UIBezierPath bezierPath];
    }
    return _bezierPath;
}

- (void)updateBezierPathWithProgress:(CGFloat)progress {
    CGFloat radius = MIN(self.frame.size.width, self.frame.size.height) * 0.4;
    CGFloat startAngle = 1.5*M_PI;
    CGFloat endAngle = progress*M_PI*2 + startAngle;
    [self.bezierPath removeAllPoints];
    [self.bezierPath addArcWithCenter:CGPointMake(self.shapeLayer.frame.size.width*0.5, self.shapeLayer.frame.size.height*0.5) radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.shapeLayer.path = self.bezierPath.CGPath;
}

#pragma mark - 公开方法
+ (instancetype)progressView {
    return [[self alloc] init];
}

- (void)setProgress:(float)progress {
    // 如何上传完成，则直接置0
    _progress = progress == 1?0:progress;
    [self updateBezierPathWithProgress: _progress];
}

- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
}

#pragma mark - 手势
- (void)activityIndicatorViewLongPressed:(UILongPressGestureRecognizer *)longGesture {
    if (longGesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否继续上传" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"继续",@"取消", nil];
        [actionSheet showInView: self.viewController.view];
        NSLog(@"%s",__FUNCTION__);
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 继续
    } else if (buttonIndex == 1){
        // 取消
        NSParameterAssert(self.cancelUploadBlock);
        self.cancelUploadBlock();
    }
}

@end

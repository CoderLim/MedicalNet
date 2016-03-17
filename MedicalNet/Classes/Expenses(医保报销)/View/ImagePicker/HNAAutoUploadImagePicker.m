//
//  HNAAutoUploadImagePicker.m
//  MedicalNet
//
//  Created by gengliming on 16/1/15.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "HNAAutoUploadImagePicker.h"
#import "AFNetworking.h"
#import "HNAImagePickerView.h"
#import "HNAImagePickerProgressView.h"
#import "UIView+HNA.h"

#define ProgressKeyPath @"fractionCompleted"

#define MaxFileSize 5*1024*1024

@interface HNAAutoUploadImagePicker() <HNAImagePickerViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) NSProgress *progress;
/**
 *  上传任务
 */
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;
/**
 *  图片选择
 */
@property (nonatomic, weak) HNAImagePickerView *imagePickerView;
/**
 *  进度显示
 */
@property (nonatomic, weak) HNAImagePickerProgressView *progressView;
/**
 *  重传按钮
 */
@property (nonatomic, weak) UIButton *reuploadBtn;

@end

@implementation HNAAutoUploadImagePicker

- (void)dealloc {
    [self.progress removeObserver:self forKeyPath: ProgressKeyPath];
}

#pragma mark - View lifecycle
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
    self.uploadState = HNAAutoUploadImagePickerUploadStateDefault;
    // 添加一个imagePickerView
    HNAImagePickerView *ipv = [HNAImagePickerView imagePicker];
    ipv.delegate = self;
    [self addSubview:ipv];
    self.imagePickerView = ipv;
    // 添加重传控件
    UIButton *reuploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reuploadBtn setTitle:@"重传" forState:UIControlStateNormal];
    [reuploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reuploadBtn setBackgroundColor: UIColorWithRGBA(1.0f, 1.0f, 1.0f, 0.5f)];
    [reuploadBtn addTarget:self action:@selector(reuploadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [reuploadBtn setHidden:YES];
    [self addSubview:reuploadBtn];
    self.reuploadBtn = reuploadBtn;
}

- (void)layoutSubviews {
    self.imagePickerView.frame = self.bounds;
    self.reuploadBtn.frame = self.bounds;
}

#pragma mark - Custom Accessors
- (HNAImagePickerProgressView *)progressView {
    if (_progressView == nil) {
        HNAImagePickerProgressView *progressview = [HNAImagePickerProgressView progressView];
        progressview.frame = self.bounds;
        progressview.cancelUploadBlock = ^() {
            // 移除图片
            self.imagePickerView.image = nil;
            // 取消上传
            NSParameterAssert(_uploadTask);
            [self.uploadTask cancel];
        };
        [self addSubview:progressview];
        _progressView = progressview;
    }
    return _progressView;
}

- (UIImage *)image {
    return self.imagePickerView.image;
}

#pragma mark - Public
+ (instancetype)autoUploadImagePicker {
    return [[HNAAutoUploadImagePicker alloc] init];
}

#pragma mark - HNAImagePickerViewDelegate
- (BOOL)imagePickerViewWillSelectImage:(HNAImagePickerView *)imagePickerView {
    if ([self.delegate respondsToSelector:@selector(autoUploadImagePickerWillSelectImage:)]) {
        return [self.delegate autoUploadImagePickerWillSelectImage:self];
    }
    return YES;
}

- (void)imagePickerViewDidSelectImage:(HNAImagePickerView *)imagePickerView {
    [self.progressView show];
    [self automaticUpload:imagePickerView];
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(autoUploadImagePickerDidSelectImage:)]) {
        [self.delegate autoUploadImagePickerDidSelectImage:self];
    }
}

- (void)imagePickerViewDidRemoveImage:(HNAImagePickerView *)imagePickerView {
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(autoUploadImagePickerDidRemoveImage:)]) {
        [self.delegate autoUploadImagePickerDidRemoveImage:self];
    }
}

#pragma mark - Private
- (void)automaticUpload:(HNAImagePickerView *)imagePickerView {
    NSString *urlStr = [NSString stringWithFormat:@"%@/medical/uploadPic", kRequestUrlDomain];
    NSString *mimeType = @"image/jpeg";
    NSString *extensionName = @".jpg";
    // 数据
    NSData *data = nil;
    if (UIImageJPEGRepresentation(imagePickerView.image, 0.7f)) {
        data = UIImageJPEGRepresentation(imagePickerView.image, 0.7f);
    } else {
        data = UIImagePNGRepresentation(imagePickerView.image);
        mimeType = @"image/png";
        extensionName = @".png";
    }
    if (data.length > MaxFileSize) {
        [MBProgressHUD showError:@"文件太大"];
        [self.progressView hide];
        return;
    }
    NSParameterAssert(data);
    // 文件名
    NSString *filename = [[[NSDate date] hna_stringWithFormat:@"yyyyMMddHHmmss"] stringByAppendingString: extensionName];
    // request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:@{@"picNum":@"1"} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"pic1" fileName:filename mimeType:mimeType];
    } error:nil];
    // 会话配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // sessionManager
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSProgress *progress = nil;
    // 上传task
    NSURLSessionUploadTask *uploadTask = [mgr uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [self.progressView hide];
        
        if (!error) {
            NSMutableArray *picList = responseObject[@"picList"];
            if (picList != nil) {
                self.uploadUrl = [picList firstObject];
            }
            // 修改uploadState
            self.uploadState = HNAAutoUploadImagePickerUploadStateCompleted;
        } else {
            self.uploadState = HNAAutoUploadImagePickerUploadStateFailed;
            // 更新UI
            [self.reuploadBtn setHidden:NO];
            [MBProgressHUD showError: [NSString stringWithFormat:@"error: %@", error]];
        }
    }];
    self.uploadTask = uploadTask;
    self.progress = progress;
    [progress addObserver:self forKeyPath:ProgressKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [uploadTask resume];
}

#pragma mark - UIAlertViewDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) return;
    
    [self.reuploadBtn setHidden:YES];
    
    if (buttonIndex == 0) {
        [self.imagePickerView setImage:nil];
    } else if(buttonIndex == 1) {
        [self automaticUpload:self.imagePickerView];
    }
}

#pragma mark - IBActions
- (void)reuploadBtnClicked:(UIButton *)button {
    // 弹出actionSheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传失败" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重新选择",@"重新上传", nil];
    [actionSheet showInView:self.hna_viewController.view];
}

#pragma mark - NSObject
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:ProgressKeyPath]) {
        double fractionCompleted = [change[NSKeyValueChangeNewKey] doubleValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSThread sleepForTimeInterval:0.02f];
            self.progressView.progress = fractionCompleted;
        });
    }
}

@end

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

#define ProgressKeyPath @"fractionCompleted"

#define MaxFileSize 5*1024*1024

@interface HNAAutoUploadImagePicker() <HNAImagePickerViewDelegate>
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
@end
@implementation HNAAutoUploadImagePicker

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
}

- (void)layoutSubviews {
    self.imagePickerView.frame = self.bounds;
}
#pragma mark - 公开属性方法
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

+ (instancetype)autoUploadImagePicker {
    return [[HNAAutoUploadImagePicker alloc] init];
}

- (UIImage *)image {
    return self.imagePickerView.image;
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
    [self automaticUpload:imagePickerView.image];
    
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
/**
 *  自动上传
 */
- (void)automaticUpload:(UIImage *)image {
    NSString *urlStr = @"http://localhost/upload_file.php";
    NSString *mimeType = @"image/jpeg";
    NSString *extensionName = @".jpg";
    // 数据
    NSData *data = nil;
    if (UIImageJPEGRepresentation(image, 0.7f)) {
        data = UIImageJPEGRepresentation(image, 0.7f);
    } else {
        data = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
        extensionName = @".png";
    }
    NSLog(@"%ld",(long)data.length);
    if (data.length > MaxFileSize) {
        [MBProgressHUD showError:@"文件太大"];
        [self.progressView hide];
        return;
    }
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"big.png"];
    data = [NSData dataWithContentsOfFile:path];
    NSParameterAssert(data);
    // 文件名
    NSString *filename = [[[NSDate date] stringWithFormat:@"yyyyMMddHHmmss"] stringByAppendingString: extensionName];
    // request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:filename mimeType:mimeType];
    } error:nil];
    // 会话配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // sessionManager
    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSProgress *progress = nil;
    // 上传task
    NSURLSessionUploadTask *uploadTask = [mgr uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            // 修改uploadState
            self.uploadState = HNAAutoUploadImagePickerUploadStateCompleted;
            // 更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressView hide];
            });
        } else {
            self.uploadState = HNAAutoUploadImagePickerUploadStateFailed;
            // 更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressView hide];
                [MBProgressHUD showError: [NSString stringWithFormat:@"error: %@", error]];
            });
        }
    }];
    self.uploadTask = uploadTask;
    self.progress = progress;
    [progress addObserver:self forKeyPath:ProgressKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [uploadTask resume];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:ProgressKeyPath]) {
        double fractionCompleted = [change[NSKeyValueChangeNewKey] doubleValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = fractionCompleted;
        });
    }
}

- (void)dealloc {
    [self.progress removeObserver:self forKeyPath: ProgressKeyPath];
}
@end

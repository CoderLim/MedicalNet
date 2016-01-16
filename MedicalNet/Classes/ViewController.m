//
//  ViewController.m
//  MedicalNet
//
//  Created by gengliming on 16/1/16.
//  Copyright © 2016年 HaiHang. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self Upload];
    //
    //
    //
//    NSString *urlStr = @"http://localhost/upload_file.php";
//    
//    //    NSString *urlStr = @"http://www.freeimagehosting.net/upl.php";
//    UIImage *image = [UIImage imageNamed:@"1.jpg"];
//    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    //    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //
    //        [formData appendPartWithFileData:data name:@"name1" fileName:@"filename1" mimeType:@"image/png"];
    //
    //    } error:nil];
    //    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //    NSProgress *progress = nil;
    //    NSURLSessionUploadTask *uploadTask = [mgr uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    //        if (error) {
    //            NSLog(@"error: %@", error);
    //        } else {
    //            NSLog(@"%@ %@",response, responseObject);
    //        }
    //    }];
    //    [uploadTask resume];
    
    //    AFHTTPRequestOperationManager *mgrnew = [AFHTTPRequestOperationManager manager];
    //    [mgrnew POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //        [formData appendPartWithFileData:data name:@"name1" fileName:@"1.png" mimeType:@"image/png"];
    //    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSLog(@"success---%@",responseObject);
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"failure----%@",error);
    //    }];
    
    //    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    //    NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    //
    //    NSString *urlStr = @"http://localhost/upload_file.php";
    ////    NSString *urlStr = @"http://www.freeimagehosting.net/upl.php";
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"text/html" forHTTPHeaderField:@"Accept"];
//    [request setHTTPMethod:@"POST"];
//    [request setCachePolicy: NSURLRequestReloadIgnoringCacheData];
//    [request setTimeoutInterval:20];
    //    [request setHTTPBody:data];
    //
    //    NSURLSession *session = [NSURLSession sharedSession];
    //    NSURLSessionUploadTask * uploadtask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    //        NSString * htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        NSLog(@"%@", htmlString);
    //    }];
    //    [uploadtask resume];
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *mgr = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSProgress *progress = nil;
//    
//    NSURLSessionUploadTask *uploadTask = [mgr uploadTaskWithRequest:request fromData:data progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"error: %@", error);
//        } else {
//            NSLog(@"%@", responseObject);
//        }
//    }];
//    [uploadTask resume];
}

-(void)Upload{
    
    UIImage * image = [UIImage imageNamed:@"iphone.png"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@", str];
    NSDictionary *parameters = @{@"filename":fileName};
    
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    ((AFJSONResponseSerializer *)manager.responseSerializer).readingOptions = NSJSONReadingAllowFragments;
    
    [manager POST:@"http://localhost/upload_file.php" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

@end

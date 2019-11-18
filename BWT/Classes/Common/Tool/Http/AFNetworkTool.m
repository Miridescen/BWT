//
//  AFNetworkTool.m
//  AFNetText3.1.0
//



#import "AFNetworkTool.h"


@implementation AFNetworkTool

#pragma mark 检测网路状态
+ (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    }];
    
}

#pragma mark - JSON方式获取数据
+ (void)JSONDataWithUrl:(NSString *)url success:(void (^)(id json))success fail:(void (^)(NSError *error))fail;
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSDictionary *dict = @{@"format": @"json"};
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    
    
    [manager GET:url parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
//    [manager GET:url parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (fail) {
//            fail(error);
//        }
//    }];
    
}

#pragma mark - xml方式获取数据
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 返回的数据格式是XML
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
//    NSDictionary *dict = @{@"format": @"xml"};
//    [manager GET:urlStr parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (success) {
//            success(responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (fail) {
//            fail(error);
//        }
//    }];
}

#pragma mark - JSON方式post提交数据
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setValue:[NSURL URLWithString:Host_url_Product]  forKey:@"baseURL"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    [manager POST:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:responseObject];
               NSInteger code = [dataDic[@"code"] integerValue];
               NSString *message = dataDic[@"message"];
               id result = dataDic[@"result"];
               
               if (code == 200) {
                   if (success) {
                       success(result);
                   }
               } else if (code == 103 || code == 104) {
                   UIWindow * window = [[UIApplication sharedApplication] windows].lastObject;
                   MSTipView *tipView = [[MSTipView alloc] initWithWindow:window message:message];
                   [tipView show];
                   if ([urlStr isEqualToString:Coupon_get]) {
                       if (success) {
                           success([NSNumber numberWithInteger:code]);
                       }
                   }
                   
                   
               } else {
                   UIWindow * window = [[UIApplication sharedApplication] windows].lastObject;
                   MSTipView *tipView = [[MSTipView alloc] initWithWindow:window message:message];
                   [tipView show];
                   if ([urlStr isEqualToString:Coupon_get]) {
                       if (success) {
                           success([NSNumber numberWithInteger:code]);
                       }
                   }
               }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            UIWindow * window = [[UIApplication sharedApplication] windows].lastObject;
            MSTipView *tipView = [[MSTipView alloc] initWithWindow:window message:@"网络异常"];
            [tipView show];
            fail(error);
        }
    }];
    /*
    [manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        BWTLog(@"%@", responseObject);
        NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:responseObject];
        NSInteger code = [dataDic[@"code"] integerValue];
        NSString *message = dataDic[@"message"];
        id result = dataDic[@"result"];
        
        if (code == 200) {
            if (success) {
                success(result);
            }
        } else if (code == 103 || code == 104) {
            UIWindow * window = [[UIApplication sharedApplication] windows].lastObject;
            MSTipView *tipView = [[MSTipView alloc] initWithWindow:window message:message];
            [tipView show];
            if ([urlStr isEqualToString:Coupon_get]) {
                if (success) {
                    success([NSNumber numberWithInteger:code]);
                }
            }
            
            
        } else {
            UIWindow * window = [[UIApplication sharedApplication] windows].lastObject;
            MSTipView *tipView = [[MSTipView alloc] initWithWindow:window message:message];
            [tipView show];
            if ([urlStr isEqualToString:Coupon_get]) {
                if (success) {
                    success([NSNumber numberWithInteger:code]);
                }
            }
        }
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            UIWindow * window = [[UIApplication sharedApplication] windows].lastObject;
            MSTipView *tipView = [[MSTipView alloc] initWithWindow:window message:@"网络异常"];
            [tipView show];
            fail(error);
        }
    }];
     */
    
    
}

#pragma mark - JSON方式post提交数据
+ (void)getJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setValue:[NSURL URLWithString:Host_url_Product]  forKey:@"baseURL"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:responseObject];
        NSInteger code = [dataDic[@"code"] integerValue];
        NSString *message = dataDic[@"message"];
        id result = dataDic[@"result"];
        
        if (code == 200) {
            if (success) {
                success(result);
            }
        } else if (code == 103 || code == 104) {
            UIWindow * window = [[UIApplication sharedApplication] windows].lastObject;
            MSTipView *tipView = [[MSTipView alloc] initWithWindow:window message:message];
            [tipView show];
            
        } else {
            UIWindow * window = [[UIApplication sharedApplication] windows].lastObject;
            MSTipView *tipView = [[MSTipView alloc] initWithWindow:window message:message];
            [tipView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            UIWindow * window = [[UIApplication sharedApplication] windows].lastObject;
            MSTipView *tipView = [[MSTipView alloc] initWithWindow:window message:@"网络异常"];
            [tipView show];
        }
    }];
    /*
    [manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary:responseObject];
        NSInteger code = [dataDic[@"code"] integerValue];
        NSString *message = dataDic[@"message"];
        id result = dataDic[@"result"];
        
        if (code == 200) {
            if (success) {
                success(result);
            }
        } else if (code == 103 || code == 104) {
            UIWindow * window = [[UIApplication sharedApplication] windows].lastObject;
            MSTipView *tipView = [[MSTipView alloc] initWithWindow:window message:message];
            [tipView show];
            
        } else {
            UIWindow * window = [[UIApplication sharedApplication] windows].lastObject;
            MSTipView *tipView = [[MSTipView alloc] initWithWindow:window message:message];
            [tipView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            UIWindow * window = [[UIApplication sharedApplication] windows].lastObject;
            MSTipView *tipView = [[MSTipView alloc] initWithWindow:window message:@"网络异常"];
            [tipView show];
        }
    }];
     */
    
    
    
}


#pragma mark - Session 下载下载文件
+ (void)sessionDownloadWithUrl:(NSString *)urlStr success:(void (^)(NSURL *fileURL))success fail:(void (^)(NSError *error))fail
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];

    NSString *urlString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        // 指定下载文件保存的路径
        // 将下载文件保存在缓存路径中
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        
        // URLWithString返回的是网络的URL,如果使用本地URL,需要注意
//        NSURL *fileURL1 = [NSURL URLWithString:path];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        
        if (success) {
            success(fileURL);
        }
        
        return fileURL;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (fail) {
            fail(error);
        }
    }];
    
    [task resume];
}


#pragma mark - 文件上传 自己定义文件名
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail
{
    // 本地上传给服务器时,没有确定的URL,不好用MD5的方式处理
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //@"http://localhost/demo/upload.php"
    /*
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        // 要上传保存在服务器中的名称
        // 使用时间来作为文件名 2014-04-30 14:20:57.png
        // 让不同的用户信息,保存在不同目录中
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        // 设置日期格式
        //        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        //        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        
        //@"image/png"
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" fileName:fileName mimeType:fileTye error:NULL];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
     */
    
}

#pragma mark - POST上传文件
+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // AFHTTPSessionManager就是正常的HTTP请求响应结果:NSData
    // 当请求的返回数据不是JSON,XML,PList,UIImage之外,使用AFHTTPResponseSerializer
    // 例如返回一个html,text...
    //
    // 实际上就是AFN没有对响应数据做任何处理的情况
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    /*
    // formData是遵守了AFMultipartFormData的对象
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 将本地的文件上传至服务器
        //        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"头像1.png" withExtension:nil];
        
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" error:NULL];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
     */
    
}

// 获取当前显示的viewController
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end

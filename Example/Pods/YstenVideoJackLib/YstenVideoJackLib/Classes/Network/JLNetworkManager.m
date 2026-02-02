//
//  FCNetworkManager.m
//  GoMaster
//
//  Created by percent on 2024/1/26.
//

#import "JLNetworkManager.h"
#import "JLStorageUtil.h"
#import "JLNetworkConfig.h"

static NSString *const NetworkErrorDomain = @"com.juli.weibu.NetworkErrorDomain";

@interface JLNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end


@implementation JLNetworkManager

+(instancetype)sharedManager {
    static JLNetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[JLNetworkManager alloc] init];
    });
    return sharedManager;
}

- (void)setupNetworkEnvironment:(BOOL)status {
    if (status) {
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.eweibu.com"]];
    }else {
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: @"https://testadminapi.yiimeet.com"]];

    }
    
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.requestSerializer.timeoutInterval = 15;
    self.manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (NSDictionary *)headers:(NSString *)path {
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    [headers setObject:@"ios" forKey:@"x-devicetype"];
    [headers setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"x-versionCode"];
    [headers setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"x-versionName"];
    [headers setObject:@"com.juli.weibu" forKey:@"x-pkg"];
    if (![path isEqualToString:kServerPathLogin] && [JLStorageUtil userToken] != nil) {
        [headers setObject:[JLStorageUtil userToken] forKey:@"Blade-Auth"];
    }
    return headers;
}

- (void)getRequestWithPath:(NSString *)path
                parameters:(NSDictionary * _Nullable)parameters
                   success:(SuccessCallBack)success
                   failure:(FailureCallBack)failure {
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager GET:path parameters:parameters headers:[self headers:path] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] intValue] == 200) {
            success(result);
        }else {
            failure([NSError errorWithDomain:NetworkErrorDomain code:[result[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:result[@"msg"]}]);
            NSLog([NSString stringWithFormat:@"error path = %@, code = %@,msg = %@",path,result[@"code"],result[@"msg"]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)postRequestWithPath:(NSString *)path
                 parameters:(NSDictionary * _Nullable)parameters
                    success:(SuccessCallBack)success
                    failure:(FailureCallBack)failure {
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager POST:path parameters:parameters headers:[self headers:path] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] intValue] == 200) {
            success(result);
        }else {
            failure([NSError errorWithDomain:NetworkErrorDomain code:[result[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:result[@"msg"]}]);
            NSLog([NSString stringWithFormat:@"error path = %@, code = %@,msg = %@",path,result[@"code"],result[@"msg"]]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)postFormRequestWithPath:(NSString *)path
                     parameters:(NSDictionary * _Nullable)parameters
                        success:(SuccessCallBack)success
                        failure:(FailureCallBack)failure{
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self.manager POST:path parameters:parameters headers:[self headers:path] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] intValue] == 200) {
            success(result);
        }else {
            failure([NSError errorWithDomain:NetworkErrorDomain code:[result[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:result[@"msg"]}]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)uploadFileWithPath:(NSString *)path
                  filePath:(NSString *)filePath
                parameters:(NSDictionary * _Nullable)parameters
                   success:(SuccessCallBack)success
                   failure:(FailureCallBack)failure {
    [self.manager POST:path parameters:parameters headers:[self headers:path] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([result[@"code"] intValue] == 200) {
            success(result);
        }else {
            failure([NSError errorWithDomain:NetworkErrorDomain code:[result[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:result[@"msg"]}]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


@end

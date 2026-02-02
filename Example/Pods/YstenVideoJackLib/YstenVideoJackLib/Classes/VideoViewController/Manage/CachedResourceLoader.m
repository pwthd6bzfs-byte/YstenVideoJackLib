//
//  AVAssetResourceLoader.m
//  LJChatSDK
//
//  Created by percent on 2026/1/23.
//

    // CachedResourceLoader.m
#import "CachedResourceLoader.h"
#import "NSString+MD5.h"
@interface CachedResourceLoader()

@property (nonatomic, strong) NSURL *originalURL;
@property (nonatomic, strong) NSMutableData *cachedData;
@property (nonatomic, assign) BOOL isCached;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation CachedResourceLoader

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _originalURL = url;
        _pendingRequests = [NSMutableDictionary dictionary];
        _cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
            // 检查本地缓存
        _isCached = [self checkLocalCacheForURL:url];
    }
    return self;
}

- (BOOL)checkLocalCacheForURL:(NSURL *)url {
    NSString *cachedFilePath = [self cacheFilePathForURL:url];
    return [[NSFileManager defaultManager] fileExistsAtPath:cachedFilePath];
}

- (NSString *)cacheFilePathForURL:(NSURL *)url {
    NSString *filename = [url.absoluteString md5String]; // 需要MD5工具
    return [self.cacheDirectory stringByAppendingPathComponent:filename];
}

#pragma mark - AVAssetResourceLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader
shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    
        // 检查缓存
    if ([self handleCachedRequest:loadingRequest]) {
        return YES;
    }
    
        // 记录请求
    NSString *requestID = [NSUUID UUID].UUIDString;
    self.pendingRequests[requestID] = loadingRequest;
    
        // 发起网络请求
    [self startDownloadForRequest:loadingRequest requestID:requestID];
    
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader
didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
        // 取消对应的下载任务
    [self.dataTask cancel];
}

#pragma mark - 缓存处理

- (BOOL)handleCachedRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    NSString *cachePath = [self cacheFilePathForURL:self.originalURL];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        return NO;
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:cachePath];
    NSUInteger fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:cachePath error:nil] fileSize];
    
        // 设置内容信息
    loadingRequest.contentInformationRequest.contentType = @"video/mp4";
    loadingRequest.contentInformationRequest.contentLength = fileSize;
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    
        // 读取数据
    NSUInteger requestOffset = (NSUInteger)loadingRequest.dataRequest.requestedOffset;
    NSUInteger requestLength = loadingRequest.dataRequest.requestedLength;
    
    [fileHandle seekToFileOffset:requestOffset];
    NSData *data = [fileHandle readDataOfLength:requestLength];
    [fileHandle closeFile];
    
    [loadingRequest.dataRequest respondWithData:data];
    [loadingRequest finishLoading];
    
    return YES;
}

#pragma mark - 网络下载

- (void)startDownloadForRequest:(AVAssetResourceLoadingRequest *)loadingRequest requestID:(NSString *)requestID {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.originalURL];
    
        // 设置Range头
    if (loadingRequest.dataRequest.requestedOffset > 0) {
        NSString *range = [NSString stringWithFormat:@"bytes=%llu-%llu",
                           loadingRequest.dataRequest.requestedOffset,
                           loadingRequest.dataRequest.requestedOffset + loadingRequest.dataRequest.requestedLength - 1];
        [request setValue:range forHTTPHeaderField:@"Range"];
    }
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    __weak typeof(self) weakSelf = self;
    self.dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            [loadingRequest finishLoadingWithError:error];
            [weakSelf.pendingRequests removeObjectForKey:requestID];
            return;
        }
        
            // 填充内容信息
        if (loadingRequest.contentInformationRequest) {
            loadingRequest.contentInformationRequest.contentType = response.MIMEType;
            loadingRequest.contentInformationRequest.contentLength = response.expectedContentLength;
            loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
        }
        
            // 提供数据
        [loadingRequest.dataRequest respondWithData:data];
        [loadingRequest finishLoading];
        
            // 保存到缓存
        [weakSelf cacheData:data forRequest:loadingRequest];
        
        [weakSelf.pendingRequests removeObjectForKey:requestID];
    }];
    
    [self.dataTask resume];
}

- (void)cacheData:(NSData *)data forRequest:(AVAssetResourceLoadingRequest *)request {
    NSString *cachePath = [self cacheFilePathForURL:self.originalURL];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        [[NSFileManager defaultManager] createFileAtPath:cachePath contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:cachePath];
    [fileHandle seekToFileOffset:request.dataRequest.requestedOffset];
    [fileHandle writeData:data];
    [fileHandle closeFile];
}

@end

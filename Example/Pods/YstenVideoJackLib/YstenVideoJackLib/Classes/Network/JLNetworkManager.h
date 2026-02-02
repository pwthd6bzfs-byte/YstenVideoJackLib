//
//  FCNetworkManager.h
//  GoMaster
//
//  Created by percent on 2024/1/26.
//

#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessCallBack)(NSDictionary * _Nullable result);
typedef void(^FailureCallBack)(NSError * _Nullable error);

@interface JLNetworkManager : NSObject

+(instancetype)sharedManager;

- (void)setupNetworkEnvironment:(BOOL)status;

- (void)getRequestWithPath:(NSString *)path
                parameters:(NSDictionary * _Nullable)parameters
                   success:(SuccessCallBack)success
                   failure:(FailureCallBack)failure;


- (void)postRequestWithPath:(NSString *)path
                 parameters:(NSDictionary * _Nullable)parameters
                    success:(SuccessCallBack)success
                    failure:(FailureCallBack)failure;

- (void)postFormRequestWithPath:(NSString *)path
                     parameters:(NSDictionary * _Nullable)parameters
                        success:(SuccessCallBack)success
                        failure:(FailureCallBack)failure;

- (void)uploadFileWithPath:(NSString *)path
                  filePath:(NSString *)filePath
                parameters:(NSDictionary * _Nullable)parameters
                   success:(SuccessCallBack)success
                   failure:(FailureCallBack)failure;

@end

NS_ASSUME_NONNULL_END

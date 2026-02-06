//
//  JLSystemConfigUtil.h
//  LJChatSDK
//
//  Created by percent on 2026/1/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLSystemConfigUtil : NSObject

+ (void)saveInfoWithBaseUrl:(NSString *)baseUrl;

+ (void)saveInfoWithHeartbeatMatchDict:(NSDictionary *)HeartbeatMatchDict;

+ (void)saveInfoWithH5String:(NSString *)h5String;

+ (NSDictionary *)getInfoWithHeartbeatMatchDict:(NSString *)HeartbeatMatchDict;

+ (NSString *)getInfoWithH5String:(NSString *)h5String;

+ (NSString *)getWithBaseUrl:(NSString *)baseUrl;

@end

NS_ASSUME_NONNULL_END

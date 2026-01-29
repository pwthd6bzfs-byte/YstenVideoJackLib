//
//  JLSystemConfigUtil.h
//  LJChatSDK
//
//  Created by percent on 2026/1/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLSystemConfigUtil : NSObject

+ (void)saveInfoWithHeartbeatMatchDict:(NSDictionary *)HeartbeatMatchDict;

+ (void)saveInfoWithH5String:(NSString *)h5String;

+ (NSDictionary *)getInfoWithHeartbeatMatchDict:(NSString *)HeartbeatMatchDict;


+ (NSDictionary *)getInfoWithH5String:(NSString *)h5String;

@end

NS_ASSUME_NONNULL_END

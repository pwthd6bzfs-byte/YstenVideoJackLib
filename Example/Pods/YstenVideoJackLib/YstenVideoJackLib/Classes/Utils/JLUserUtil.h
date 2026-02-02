//
//  FCUserCacheUtil.h
//  ConstellChat
//
//  Created by percent on 2024/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLUserUtil : NSObject

+ (void)saveInfoWithName:(NSString *)name avatar:(NSString *)avatar targetID:(NSInteger)targetID country:(NSString *)country;

+ (NSDictionary *)getInfoWithTargetID:(NSInteger)targetID;

@end

NS_ASSUME_NONNULL_END

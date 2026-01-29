//
//  GMStorageUtil.h
//  Sexolive
//
//  Created by percent on 2023/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLStorageUtil : NSObject

+ (void)saveValue:(NSString *)value forKey:(NSString *)key;

+ (NSString *)getValueForKey:(NSString *)key;

+ (void)saveUserToken:(NSString *)userToken userID:(NSString *)userID userRole:(NSString *)userRole;

+ (NSString *)userToken;

+ (NSString *)userID;

+ (NSString *)userRole;

+ (void)cleanUserInfo;

@end

NS_ASSUME_NONNULL_END

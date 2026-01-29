//
//  GMStorageUtil.m
//  Sexolive
//
//  Created by percent on 2023/12/29.
//

#import "JLStorageUtil.h"
#import <SAMKeychain.h>


static  NSString *kLocalStorageWithService = @"com.guoxin.gomaster";
static  NSString *kLocalStorageWithUserToken = @"kLocalStorageWithUserToken";
static  NSString *kLocalStorageWithUserIdentify =  @"kLocalStorageWithUserIdentify";
static  NSString *kLocalStorageWithUserRole  = @"kLocalStorageWithUserRole";


@implementation JLStorageUtil

+ (void)saveValue:(NSString *)value forKey:(NSString *)key {
    if (value == nil || key == nil || key.length == 0) {
        return;
    }
    [SAMKeychain setPassword:value forService:kLocalStorageWithService account:key];
}

+ (NSString *)getValueForKey:(NSString *)key {
    NSString *value = [SAMKeychain passwordForService:kLocalStorageWithService account:key];
    return value;
}

+ (void)saveUserToken:(NSString *)userToken userID:(NSString *)userID userRole:(NSString *)userRole{
    [JLStorageUtil saveValue:userToken forKey:kLocalStorageWithUserToken];
    [JLStorageUtil saveValue:userID forKey:kLocalStorageWithUserIdentify];
    [JLStorageUtil saveValue:userRole forKey:kLocalStorageWithUserRole];
}

+ (NSString *)userToken {
    return [JLStorageUtil getValueForKey:kLocalStorageWithUserToken];
}

+ (NSString *)userID {
    return [JLStorageUtil getValueForKey:kLocalStorageWithUserIdentify];
}

+ (NSString *)userRole {
    return [JLStorageUtil getValueForKey:kLocalStorageWithUserRole];
}

+ (void)cleanUserInfo {
    [SAMKeychain deletePasswordForService:kLocalStorageWithService account:kLocalStorageWithUserToken];
    [SAMKeychain deletePasswordForService:kLocalStorageWithService account:kLocalStorageWithUserIdentify];
    [SAMKeychain deletePasswordForService:kLocalStorageWithService account:kLocalStorageWithUserRole];
}


@end

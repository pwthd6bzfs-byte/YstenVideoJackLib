//
//  JLUserService.m
//  JuliFramework
//
//  Created by percent on 2025/3/29.
//

#import "JLUserService.h"
#import "JLNetworkTool.h"
#import "JLStorageUtil.h"
#import "Config/Config.h"
#import "JLIMService.h"
#import "JLUserModel.h"
#import "JLUserUtil.h"
#import "JLNetworkManager.h"
#import "SVProgressHUD.h"
#import "YYKit.h"
#import <RongCloudOpenSource/RongIMKit.h>

@implementation JLUserService

static JLUserService *shared = nil;

+ (instancetype)shared {
    @synchronized (self) {
        if (shared == nil) {
            shared = [[self alloc] init];
        }
    }
    return  shared;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (shared == nil) {
            shared = [super allocWithZone: zone];
            return shared;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self; // 返回单例实例，防止复制操作
}



- (void)loginUserId:(NSString *)userID{
    [self initServiceWithUserID:userID success:nil failued:nil];
}



- (void)initServiceWithUserID:(NSString *)userID success:(void(^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    Weakself(ws);
//    [SVProgressHUD show];
    [JLNetworkTool loginWithType:@"6" token:userID success:^(NSDictionary * _Nonnull result) {
        NSDictionary *data = result[@"data"];
        [JLStorageUtil cleanUserInfo];
        [JLStorageUtil saveUserToken:data[@"token"] userID:data[@"id"] userRole:data[@"userCategory"]];
        [[JLIMService shared] initService];
        // 获取用户数据
        [ws fetchUserInfo];
        JLLog(@"User login Success");
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
        failuedBlock(error);
    }];
}

- (void)fetchUserInfo {
    [JLNetworkTool requestUserInfoWithUserID:[[JLStorageUtil userID] integerValue]  success:^(NSDictionary * _Nonnull result) {
        JLUserModel *model = [JLUserModel modelWithJSON:result[@"data"]];
        if (model.country.length == 0) {
            model.country = [NSLocale currentLocale].currencyCode;
        }
        self.userInfo = model;
        
            // 同步个人信息
        RCUserInfo *userInfo = [RCUserInfo new];
        userInfo.userId = [NSString stringWithFormat:@"%ld",(long)[JLUserService shared].userInfo.userID];
        userInfo.name = [JLUserService shared].userInfo.nickName;
        userInfo.portraitUri = [JLUserService shared].userInfo.headFileName;
        
        [RCIM sharedRCIM].currentUserInfo = userInfo;

        JLLog(@"User info fetch Success");
    } failued:^(NSError * _Nonnull error) {
        JLLog(@"User info fetch Failed");
        [self fetchUserInfo];
    }];
}

- (void)saveInfoWithTargetID:(NSInteger)targetID nickname:(NSString *)nickname avatar:(NSString *)avatar country:(NSString *)country {
    [JLUserUtil saveInfoWithName:nickname avatar:avatar targetID:targetID country:country];
}


- (NSDictionary *)getInfoWithTargetID:(NSInteger)targetID {
    return  [JLUserUtil getInfoWithTargetID:targetID];;
}




- (void)logout{
    [JLStorageUtil cleanUserInfo];
    [[JLIMService shared] logout];
}




    /// 赠送礼物
    /// - Parameters:
    ///   - anchorId: 主播id
    ///   - channelId: 主播昵称
    ///   - giftId: 礼物id
    ///   - giveNum: 礼物数量
+ (void)sendGiftInfoWithAnchorId:(NSInteger)anchorId channelId:(NSString *)channelId giftId:(NSString *)giftId giveNum:(NSString *)giveNum success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [JLNetworkTool sendGiftInfoWithAnchorId:anchorId channelId:channelId giftId:giftId giveNum:giveNum success:successBlock failued:failuedBlock];
}


- (void)getUserCoinSuccess:(void(^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [JLNetworkTool getUserCoinSuccess:successBlock failued:failuedBlock];
}

@end

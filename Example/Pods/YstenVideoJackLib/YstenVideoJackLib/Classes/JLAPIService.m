    //
    //  JLAPIService.m
    //  JuliFramework
    //
    //  Created by percent on 2025/3/31.
    //

#import "JLAPIService.h"
#import "JLNetworkTool.h"
#import "JLLocalizationUtil.h"
#import "JLNetworkManager.h"
#import "JLStorageUtil.h"


@implementation JLAPIService

+ (void)environmentSetting:(NSInteger)status {
    bool flag = NO;
    if (status == 1) {
        flag = YES;
    }
    [[JLNetworkManager sharedManager] setupNetworkEnvironment:flag];
}

+ (void)getSystemConfigWithSuccess:(void (^)(NSDictionary *result))successBlock
                           failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool requestSystemConfigWithSuccess:^(NSDictionary * _Nonnull result) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"code"] = @200;
        dic[@"data"] = @{@"recommendFirstDelay" : result[@"data"][@"recommendFirstDelay"],@"heartbeatMatchPrice": result[@"data"][@"heartbeatMatchPrice"],@"heartbeatMatchFreeTime" : result[@"data"][@"heartbeatMatchFreeTime"]};
        dic[@"msg"] = @"";
        dic[@"success"] = @1;
        successBlock([dic copy]);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}

+ (void)getCountrysInfoWithLanguage:(NSString *)language
                              success:(void (^)(NSDictionary *result))successBlock
                              failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool fetchCountrysInfoWithLanguage:language success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}

+ (void)getAnchorListWithCountry:(NSString *)country
                            page:(NSInteger)page
                            size:(NSInteger)size
                         success:(void (^)(NSDictionary *result))successBlock
                         failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool fetchAnchorInfoWithCountry:country nickName:@"" currentPage:page size:size success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}

+ (void)searchAnchorWithKeyword:(NSString *)keyword
                        success:(void (^)(NSDictionary *result))successBlock
                        failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool fetchAnchorInfoWithCountry:@"" nickName:keyword currentPage:1 size:20 success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}


+ (void)getAnchorDetailInfo:(NSInteger)anchorID
                   userCode:(NSString *)userCode
                    success:(void (^)(NSDictionary *result))successBlock
                    failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool requestAnchorDetailInfoWithUserID:anchorID userCode:userCode success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}

+ (void)getFollowStatusWithAnchorID:(NSInteger)anchorID
                            success:(void (^)(NSDictionary *result))successBlock
                            failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool requestFollowFlagWithUserID:anchorID success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}

+ (void)addFollowWithAnchorID:(NSInteger)anchorID success:(void (^)(NSDictionary * _Nonnull))successBlock failued:(void (^)(NSError * _Nonnull))failuedBlock {
    [JLNetworkTool addFollowrWithID:anchorID userRole:@"1" success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}


    /// 获取h5地址路径
+ (void)getH5ConfigDatasuccess:(void (^)(NSDictionary *result))successBlock
                       failued:(void (^)(NSError *error))failuedBlock{
    [JLNetworkTool getH5ConfigDatasuccess:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}



+ (void)cancelFollowWithAnchorID:(NSInteger)anchorID success:(void (^)(NSDictionary * _Nonnull))successBlock failued:(void (^)(NSError * _Nonnull))failuedBlock {
    [JLNetworkTool unfollowWithID:anchorID success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}

+ (void)getGiftListInfoWithGiftType:(NSString *)giftType
                            Success:(void (^)(NSDictionary *result))successBlock
                            failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool fetchGiftListWithType:giftType success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}

+ (void)sendGiftWithAnchorID:(NSInteger)anchorID
                      giftID:(NSInteger)giftID
                     success:(void (^)(NSDictionary *result))successBlock
                     failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool giveGiftWithAnchorId:[NSString stringWithFormat:@"%ld",anchorID] giftId:giftID source:@"0" success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}






+ (void)getGiftWallWithAnchorID:(NSInteger)anchorID
                       userCode:(NSString *)userCode
                        success:(void (^)(NSDictionary *result))successBlock
                        failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool fetchAnchorGiftListWithAnchorId:anchorID userCode:userCode success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}




+ (void)getVideoCallHistoryInfoWithPage:(NSInteger)page
                                   size:(NSInteger)size
                                success:(void (^)(NSDictionary *result))successBlock
                                failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool fetchCallHistoryWithCurrentPage:page success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}


+ (void)delCallHistory:(NSString *)ID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [JLNetworkTool delCallHistory:ID success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}


+ (void)getFreePhotosWithAnchorID:(NSInteger)anchorID
                         userCode:(NSString *)userCode
                          success:(void (^)(NSDictionary *result))successBlock
                          failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool fetchFreePhotoWithAnchorId:anchorID userCode:userCode success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}



    /// 私密解锁
+ (void)getTradePrivacyUnlockWithUnLockId:(NSString *)unLockId
                                  success:(void (^)(NSDictionary *result))successBlock
                                  failued:(void (^)(NSError *error))failuedBlock{
    [JLNetworkTool getTradePrivacyUnlockWithUnLockId:unLockId success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}



+ (void)recommendVideoCallWithSuccess:(void (^)(NSDictionary *result))successBlock
                              failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool getRecommendAnchorWithSuccess:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}


+ (void)rejectRecommendVideoCallWithChannelID:(NSString *)channelID
                                 disableToday:(BOOL)disableToday
                                      success:(void (^)(NSDictionary *result))successBlock
                                      failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool uploadUserVideoHangupWithChannelID:channelID disableToday:disableToday isTimeOutAnswer:NO  success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}

+ (void)getFollowingInfowithWithPage:(NSInteger)page
                                size:(NSInteger)size
                             success:(void (^)(NSDictionary *result))successBlock
                             failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool requestRelationInfoWithUserID:[[JLStorageUtil userID] integerValue] relationType:1 currentPage:page size:size success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}


+ (void)getFansInfowithWithPage:(NSInteger)page
                           size:(NSInteger)size
                        success:(void (^)(NSDictionary *result))successBlock
                        failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool requestRelationInfoWithUserID:[[JLStorageUtil userID] integerValue] relationType:0 currentPage:page size:size success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}

+ (void)getGreetingWithAnchorID:(NSInteger)anchorID
                        success:(void (^)(NSDictionary *result))successBlock
                        failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool getGreetingInfoWithAnchorID:anchorID success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}

+ (void)greetingWithAnchorID:(NSInteger)anchorID
                     greetID:(NSInteger)greetID
                     success:(void (^)(NSDictionary *result))successBlock
                     failued:(void (^)(NSError *error))failuedBlock{
    [JLNetworkTool greetingWithAnchorID:anchorID greetId:greetID success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}

+ (void)heartBeatWithSuccess:(void (^)(NSDictionary *result))successBlock
                     failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool heartBeatWithSuccess:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}

+ (void)cancelHeartBeatWithBatchId:(NSString *)batchId
                           success:(void (^)(NSDictionary *result))successBlock
                           failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool cancelHeartBeatWithBatchId:batchId success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}


+ (void)anchorCallCancel:(NSString *)channelId
                 success:(void (^)(NSDictionary *result))successBlock
                 failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool anchorCallCancel:channelId success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}


+ (void)anchorCallAccept:(NSString *)channelId
                 success:(void (^)(NSDictionary *result))successBlock
                 failued:(void (^)(NSError *error))failuedBlock {
    [JLNetworkTool anchorCallAccept:channelId success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}




    /// 用户手动取消拨打通话
+ (void)userCancalCallChannelID:(NSString *)channelID
                        success:(void (^)(NSDictionary *result))successBlock
                        failued:(void (^)(NSError *error))failuedBlock{
    [JLNetworkTool uploadUserVideoHangupWithChannelID:channelID disableToday:NO isTimeOutAnswer:NO success:^(NSDictionary * _Nonnull result) {
        successBlock(result);
    } failued:^(NSError * _Nonnull error) {
        failuedBlock(error);
    }];
}


@end

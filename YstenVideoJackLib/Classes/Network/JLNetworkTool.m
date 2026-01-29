    //
    //  GMNetworkTool.m
    //  GoMaster
    //
    //  Created by percent on 2024/1/26.
    //

#import "JLNetworkTool.h"
#import "JLNetworkManager.h"
#import "JLNetworkConfig.h"

@implementation JLNetworkTool

+ (void)loginWithType:(NSString *)type token:(NSString *)token success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathLogin parameters:@{@"authId":token,@"type":type,@"userCategory":@""} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestUserInfoWithUserID:(NSInteger)userID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathUserDetailInfo parameters:@{@"id":[NSNumber numberWithInteger:userID]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

    // 上传用户头像
+ (void)uploadFile:(NSString *)filePath success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] uploadFileWithPath:kServerPathUploadFile filePath:filePath parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

    //修改信息
+ (void)updateUserInfo:(NSDictionary *)info  success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathUpdataInfo parameters:info success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)requestRelationInfoWithUserID:(NSInteger)userID relationType:(NSInteger)type currentPage:(NSInteger)page size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    NSString *urlPath = kServerPathUserFollowers;
    if (type == 1) {
        urlPath = kServerPathUserFollowing;
    }
    [[JLNetworkManager sharedManager] postRequestWithPath:urlPath parameters:@{@"userId":[NSNumber numberWithInteger:userID],@"current":[NSNumber numberWithInt:page], @"size":[NSNumber numberWithInt:size]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

    // 获取是否关注
+ (void)requestFollowFlagWithUserID:(NSInteger)userID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postFormRequestWithPath:kServerPathFollowFlag parameters:@{@"id":[NSNumber numberWithInteger:userID]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

    // 关注用户
+ (void)addFollowrWithID:(NSInteger)userID userRole:(NSString *)role success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postFormRequestWithPath:kServerPathAddFollowing parameters:@{@"id":[NSNumber numberWithInteger:userID]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

    // 取消关注用户
+ (void)unfollowWithID:(NSInteger)userID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postFormRequestWithPath:kServerPathCancelFollowing parameters:@{@"id":[NSNumber numberWithInteger:userID]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)requestLevelInfoWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathLevelInfo parameters:@{@"orderTrigger":@"7"} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestWalletRecordWithCurrentPage:(NSInteger)page size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathWalletRecord parameters:@{@"size":[NSNumber numberWithInteger:size],@"current":[NSNumber numberWithInteger:page]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)freeMessageCountSubtractWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathMessageCountSubtract parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)reportVideoTrendsWithUserID:(NSInteger)userID reportContent:(NSString *)reportContent fileURL:(NSString *)fileURL userRole:(NSString *)userRole nickName:(NSString *)nickName avatar:(NSString *)avatar success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathReportVideoTrend parameters:@{@"fileUrlList":@[fileURL],@"reportContent":reportContent,@"reportUserId":[NSNumber numberWithInteger:userID],@"reportUserRole":userRole,@"reportUserNickName":nickName,@"reportUserHeadFileName":avatar} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestReportInfoWithCurrentPage:(NSInteger)page size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathReportingInfo parameters:@{@"size":[NSNumber numberWithInteger:size],@"current":[NSNumber numberWithInteger:page]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)cancelingAccountWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathAccountCanceling parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestAnchorListInfoWithCountry:(NSString *)country currentPage:(NSInteger)currentPage size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathAnchorList parameters:@{@"country":country,@"nickName":@"",@"gender":@"",@"userCode": @"",@"current":[NSNumber numberWithInteger:currentPage],@"size":[NSNumber numberWithInteger:size]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestAnchorDetailInfoWithUserID:(NSInteger)userID userCode:(NSString *)userCode success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    NSDictionary *params = nil;
    if (userID != 0) {
        params = @{@"id":[NSNumber numberWithInteger:userID]};
    }else {
        params = @{@"userCode":userCode};
    }
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathAnchorDetailInfo parameters:params success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)diamondDeductionWithChannelID:(NSString *)channelID firstFlag:(BOOL) firstFlag success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathVideoDeduct parameters:@{@"channelId":channelID,@"firstFlag": firstFlag ? @"1": @"0"} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)uploadUserVideoHangupWithChannelID:(NSString *)channelID disableToday:(BOOL)disableToday isTimeOutAnswer:(BOOL)isTimeOutAnswer success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock; {
    [[JLNetworkManager sharedManager] postFormRequestWithPath:kServerPathVideoHangup parameters:@{@"channelId":channelID, @"disableToday": [NSNumber numberWithBool:disableToday],@"isTimeOut":[NSNumber numberWithBool:isTimeOutAnswer]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)requestHotAnchorInfoWithCountID:(NSInteger)countID currentPage:(NSInteger)currentPage size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathHotAnchorInfo parameters:@{
        @"countId": [NSNumber numberWithInteger:countID],
        @"country": @"",
        @"current": [NSNumber numberWithInteger:currentPage],
        @"size": [NSNumber numberWithInteger:size]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestRechargeProductListWithRateType:(NSString *)rateType success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postFormRequestWithPath:kServerPathRechargeProductList parameters:@{@"rateType":rateType,@"orderTrigger":@"3"} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestSubscribeProductListWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathSubscribeProductList parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestOrderIDWithProductId:(NSString *)productId discountFlag:(BOOL)discountFlag success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathNewOrder parameters:@{@"discountType":discountFlag ? @"1": @"0",@"orderSource":@"2",@"priceId":productId} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}



+ (void)verifyRecepitWithTransactionID:(NSString *)transactionID orderID:(NSString *)orderID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathOrderVerify
                                               parameters:@{@"orderId": [NSNumber numberWithInteger:[orderID integerValue]],
                                                            @"orderSource": @"2",
                                                            @"orderType": @"1",
                                                            @"packageName": @"",
                                                            @"productId": @"",
                                                            @"purchaseToken": @"",
                                                            @"transactionId": transactionID}
                                                  success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestVideoCallTokenWithChannelID:(NSString *)channelID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postFormRequestWithPath:kServerPathAgoraRTCToken parameters:@{@"channelId":channelID} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)createVideoCallChannel:(BOOL)freeFlag sourceType:(NSString *)sourceType userID:(NSInteger)userID sourcePage:(NSString *)sourcePage userRole:(NSString *)userRole success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInteger:userID] forKey:@"userId"];
    if(sourceType){
        [params setObject:sourceType forKey:@"sourceType"];
    }
    
    if(userRole){
        [params setObject:userRole forKey:@"userRole"];
    }
    [params setObject:sourcePage forKey:@"sourcePage"];
    [params setObject:freeFlag? @"1":@"0" forKey:@"freeFlag"];
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathCreateChannel parameters:params success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)pushChannel:(NSString *)channel success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postFormRequestWithPath:kServerPathPushChannel parameters:@{@"channelId":channel} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestRongAppIDWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathRongCloundAppID parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestRongTranslateTokenWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathRongCloundTranslateToken parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestRonngUserTokenWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathRongCloundUserToken parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)randomMatchWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathDataingRandom parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)requestSignInListWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathSignInList parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)userSignInWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathUserSignIn parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)userHotRankInfoWithType:(int)type success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postFormRequestWithPath:kServerPathUserHotRankInfo parameters:@{@"type":[NSNumber numberWithInt:type]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)userHotShowInfoSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathUserHotShow parameters:@{@"countId": @0,
                                                                                              @"country": @"",
                                                                                              @"current": @1,
                                                                                              @"size": @5,
                                                                                              @"unionId": @0} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)requestDiamondRecordInfoWithPage:(NSInteger)page size:(NSInteger)size Success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathWalletRecord parameters:@{@"size":[NSNumber numberWithInteger:size],@"current":[NSNumber numberWithInteger:page]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestAgreementWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathAgreement parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)closlingAccountWithsuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathAccountCanceling parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)fetchCookersInfoWithCoundID:(NSInteger)countID currentPage:(NSInteger)page size:(NSInteger)size success:(void (^)(NSDictionary *))successBlock failued:(void (^)(NSError *))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathCoachAnchorInfo parameters:
     @{
        @"countId": [NSNumber numberWithInteger:countID],
        @"country": @"",
        @"current": [NSNumber numberWithInteger:page],
        @"size": [NSNumber numberWithInteger:size],
        @"unionId":[NSNumber numberWithInt:8888885]
    } success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestVMSettingsWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathVMSettings parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)requestVMStatusWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathVMStatus parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestAibWithPushType:(NSString *)pushType type:(NSString *)type success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathPushVideo parameters:@{@"pullType":pushType, @"type":type} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestTalkWithPushType:(NSString *)pushType type:(NSString *)type scriptId:(NSString *)scriptId anchorId:(NSInteger)anchorId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    NSDictionary *params = nil;
    if (anchorId == 0) {
        params = @{@"pullType":pushType, @"type":type,@"scriptId":scriptId};
    }else {
        params = @{@"pullType":pushType, @"type":type,@"scriptId":scriptId,@"anchorId":[NSNumber numberWithInteger:anchorId]};
    }
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathPushMessage parameters:params success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestRefuseCountWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathRefuseCount parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)requestSystemConfigWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathSystemInfo parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)hangeupOtherWithAnchorID:(NSString *)anchorID success:(void (^)(NSDictionary *))successBlock failued:(void (^)(NSError *))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathHangupOther parameters:@{@"anchorId":anchorID} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)getThirdInfoWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathThirdInfo parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)fetchtMatchListInfoWithCurrentPage:(NSInteger)page size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathMatchList parameters:@{@"current":[NSNumber numberWithInteger:page],@"size":[NSNumber numberWithInteger:size]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)fetchAnchorInfoWithCountry:(NSString *)country nickName:(NSString *)nickName currentPage:(NSInteger)page size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathAnchorSearch parameters:@{@"country":country,@"nickName":nickName,@"current":[NSNumber numberWithInteger:page], @"size":[NSNumber numberWithInteger:size]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)fetchGiftListWithType:(NSString *)giftType success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;{
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathGiftList parameters:@{@"giftType":giftType} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)giveGiftWithAnchorId:(NSString *)anchorId giftId:(NSInteger)giftId source:(NSString *)source success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathGiveGift parameters:@{@"anchorId":anchorId,@"giveNum":@1,@"id":[NSNumber numberWithInteger:giftId],@"source":source, @"userRole":@"1"} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)fetchCallHistoryWithCurrentPage:(NSInteger)current success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathCallHistory parameters:@{@"current":[NSNumber numberWithInteger:current],@"size":@"20"} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}



+ (void)delCallHistory:(NSString *)ID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathDelCallHistory parameters:@{@"id":ID} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)fetchMypackgeInfoWithType:(NSString *)type success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postFormRequestWithPath:kServerPathMyPack parameters:@{@"type":type} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)randomMatchSaveWithAnchorId:(NSString *)anchorId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock
{
    [[JLNetworkManager sharedManager] postFormRequestWithPath:kServerPathRandomMatchSave parameters:@{@"anchorId":anchorId} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)fetchSigninInfoWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager]  getRequestWithPath:kServerPathSignInInfo parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)signInTodayWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathSignIn parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)vipSignInWithDiamondNum:(NSInteger)num success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postFormRequestWithPath:kServerPathVipSignIn parameters:@{@"num":[NSNumber numberWithInteger:num]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)vipDaysNumWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathVipDaysNum parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)fetchAnchorGiftListWithAnchorId:(NSInteger)anchorId userCode:(NSString *)userCode success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    NSDictionary *params = nil;
    if (anchorId != 0) {
        params = @{@"anchorId":[NSNumber numberWithInteger:anchorId]};
    }else {
        params = @{@"userCode":userCode};
    }
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathAnchorGiftList parameters:params success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)fetchMatchRecordWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathMatchRecord parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)fetchCallResultWithChannelID:(NSString *)channelID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathCallResult parameters:@{@"channelId":channelID} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
    
}

+ (void)fetchFreePhotoWithAnchorId:(NSInteger)anchorId userCode:(NSString *)userCode success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    NSDictionary *params = nil;
    if (anchorId != 0) {
        params = @{@"anchorId":[NSNumber numberWithInteger:anchorId],@"current":[NSNumber numberWithInt:1],@"size": [NSNumber numberWithInt:20]};
    }else {
        params = @{@"userCode":userCode,@"current":[NSNumber numberWithInt:1],@"size": [NSNumber numberWithInt:20]};
    }
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathFreePhotoResult parameters:params success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}



+ (void)getTradePrivacyUnlockWithUnLockId:(NSString *)unLockId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    
    NSDictionary *params = nil;
    params = @{@"unLockId":unLockId};
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathTradePrivacyUnlock parameters:params success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}




+ (void)fetchCountrysInfoWithLanguage:(NSString *)language success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathCountrysInfo parameters:@{@"language":language} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)getRecommendAnchorWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathAnchorRecommend parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)getGreetingInfoWithAnchorID:(NSInteger)anchorId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathGreetListInfo parameters:@{@"anchorId": [NSNumber numberWithInteger:anchorId]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)greetingWithAnchorID:(NSInteger)anchorId greetId:(NSInteger)greetId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathGreeting parameters:@{@"anchorId":[NSNumber numberWithInteger:anchorId],@"greetId":[NSNumber numberWithInteger:greetId]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)heartBeatWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathHeartBeat parameters:nil success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)cancelHeartBeatWithBatchId:(NSString *)batchId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    if (batchId == nil) {
        batchId = @"";
    }
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathHeartBeatCancel parameters:@{@"batchId": batchId} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)anchorCallCancel:(NSString *)channelId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathAnchorCallCancel parameters:@{@"channelId":channelId} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}

+ (void)anchorCallAccept:(NSString *)channelId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathAnchorCallAccept parameters:@{@"channelId":channelId} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


+ (void)abnormalReport:(NSString *)channelId errorCode:(NSInteger)errorCode success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathExceptionReport parameters:@{@"channelId":channelId,@"code": [NSNumber numberWithInteger:errorCode]} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}




+ (void)sendGiftInfoWithAnchorId:(NSInteger)anchorId channelId:(NSString *)channelId giftId:(NSString *)giftId giveNum:(NSString *)giveNum success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock{
    [[JLNetworkManager sharedManager] postRequestWithPath:kServerPathSdkGice
                                               parameters:@{@"anchorId":[NSString stringWithFormat:@"%ld",anchorId],
                                                            @"channelId":channelId,
                                                            @"giftId":giftId,
                                                            @"giveNum":giveNum} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}




+ (void)getUserCoinSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathUserCoin parameters:@{} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}



+ (void)getH5ConfigDatasuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    [[JLNetworkManager sharedManager] getRequestWithPath:kServerPathH5Path parameters:@{} success:^(NSDictionary * _Nullable result) {
        successBlock(result);
    } failure:^(NSError * _Nullable error) {
        failuedBlock(error);
    }];
}


@end

    //
    //  GMNetworkTool.h
    //  GoMaster
    //
    //  Created by percent on 2024/1/26.
    //

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLNetworkTool : NSObject

+ (void)loginWithType:(NSString *)type token:(NSString *)token success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestUserInfoWithUserID:(NSInteger)userID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;
    // 上传用户头像
+ (void)uploadFile:(NSString *)filePath success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;
    //修改信息
+ (void)updateUserInfo:(NSDictionary *)info success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

    // 获取关注和粉丝列表
+ (void)requestRelationInfoWithUserID:(NSInteger)userID relationType:(NSInteger)type currentPage:(NSInteger)page size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

    // 获取是否关注
+ (void)requestFollowFlagWithUserID:(NSInteger)userID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

    // 关注用户
+ (void)addFollowrWithID:(NSInteger)userID userRole:(NSString *)role success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;
    // 取消关注用户
+ (void)unfollowWithID:(NSInteger)userID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;


+ (void)requestLevelInfoWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;


+ (void)requestWalletRecordWithCurrentPage:(NSInteger)page size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)freeMessageCountSubtractWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)reportVideoTrendsWithUserID:(NSInteger)userID reportContent:(NSString *)reportContent fileURL:(NSString *)fileURL userRole:(NSString *)userRole nickName:(NSString *)nickName avatar:(NSString *)avatar success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestReportInfoWithCurrentPage:(NSInteger)page size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)cancelingAccountWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestAnchorListInfoWithCountry:(NSString *)country currentPage:(NSInteger)currentPage size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestAnchorDetailInfoWithUserID:(NSInteger)userID userCode:(NSString *)userCode success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)diamondDeductionWithChannelID:(NSString *)channelID firstFlag:(BOOL) firstFlag success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)uploadUserVideoHangupWithChannelID:(NSString *)channelID disableToday:(BOOL)disableToday isTimeOutAnswer:(BOOL)isTimeOutAnswer success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;


+ (void)requestHotAnchorInfoWithCountID:(NSInteger)countID currentPage:(NSInteger)currentPage size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestRechargeProductListWithRateType:(NSString *)rateType success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestSubscribeProductListWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestOrderIDWithProductId:(NSString *)productId discountFlag:(BOOL)discountFlag success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;


+ (void)verifyRecepitWithTransactionID:(NSString *)transactionID orderID:(NSString *)orderID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestVideoCallTokenWithChannelID:(NSString *)channelID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)createVideoCallChannel:(BOOL)freeFlag sourceType:(NSString *)sourceType userID:(NSInteger)userID sourcePage:(NSString *)sourcePage userRole:(NSString *)userRole success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)pushChannel:(NSString *)channel success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestRongAppIDWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestRongTranslateTokenWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestRonngUserTokenWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)randomMatchWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;


+ (void)requestSignInListWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)userSignInWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)userHotRankInfoWithType:(int)type success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)userHotShowInfoSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestAgreementWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)fetchCookersInfoWithCoundID:(NSInteger)countID currentPage:(NSInteger)page size:(NSInteger)size success:(void (^)(NSDictionary *))successBlock failued:(void (^)(NSError *))failuedBlock;

+ (void)requestVMSettingsWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestVMStatusWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestAibWithPushType:(NSString *)pushType type:(NSString *)type success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestTalkWithPushType:(NSString *)pushType type:(NSString *)type scriptId:(NSString *)scriptId anchorId:(NSInteger)anchorId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestRefuseCountWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)requestSystemConfigWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;


+ (void)hangeupOtherWithAnchorID:(NSString *)anchorID success:(void (^)(NSDictionary *))successBlock failued:(void (^)(NSError *))failuedBlock;

+ (void)getThirdInfoWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)fetchtMatchListInfoWithCurrentPage:(NSInteger)page size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)fetchAnchorInfoWithCountry:(NSString *)country nickName:(NSString *)nickName currentPage:(NSInteger)page size:(NSInteger)size success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)fetchGiftListWithType:(NSString *)giftType success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)giveGiftWithAnchorId:(NSString *)anchorId giftId:(NSInteger)giftId source:(NSString *)source success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)fetchCallHistoryWithCurrentPage:(NSInteger)current success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)delCallHistory:(NSString *)ID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;


+ (void)fetchMypackgeInfoWithType:(NSString *)type success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)randomMatchSaveWithAnchorId:(NSString *)anchorId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)fetchSigninInfoWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)signInTodayWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)vipSignInWithDiamondNum:(NSInteger)num success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)vipDaysNumWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)fetchAnchorGiftListWithAnchorId:(NSInteger)anchorId userCode:(NSString *)userCode success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)fetchMatchRecordWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)fetchCallResultWithChannelID:(NSString *)channelID success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)fetchFreePhotoWithAnchorId:(NSInteger)anchorId userCode:(NSString *)userCode success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)getTradePrivacyUnlockWithUnLockId:(NSString *)unLockId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)fetchCountrysInfoWithLanguage:(NSString *)language success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)getRecommendAnchorWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)getGreetingInfoWithAnchorID:(NSInteger)anchorId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)greetingWithAnchorID:(NSInteger)anchorId greetId:(NSInteger)greetId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)heartBeatWithSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)cancelHeartBeatWithBatchId:(NSString *)batchId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)anchorCallCancel:(NSString *)channelId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)anchorCallAccept:(NSString *)channelId success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)abnormalReport:(NSString *)channelId errorCode:(NSInteger)errorCode success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)sendGiftInfoWithAnchorId:(NSInteger)anchorId channelId:(NSString *)channelId giftId:(NSString *)giftId giveNum:(NSString *)giveNum success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

+ (void)getUserCoinSuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;

// 获取H5配置
+ (void)getH5ConfigDatasuccess:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;
@end

NS_ASSUME_NONNULL_END

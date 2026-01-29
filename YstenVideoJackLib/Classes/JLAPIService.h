//
//  JLAPIService.h
//  JuliFramework
//
//  Created by percent on 2025/3/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLAPIService : NSObject

/// 环境设置
+ (void)environmentSetting:(NSInteger)status;    // 0:开发测试环境   1:生产环境



/// 获取系统配置参数
/// - Parameters:
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)getSystemConfigWithSuccess:(void (^)(NSDictionary *result))successBlock
                           failued:(void (^)(NSError *error))failuedBlock;

///  国家信息列表
+ (void)getCountrysInfoWithLanguage:(NSString *)language
                      success:(void (^)(NSDictionary *result))successBlock
                      failued:(void (^)(NSError *error))failuedBlock;

/// 获取主播列表
/// - Parameters:
///   - country: 国家（"": 全部，"VN": 越南,"PH": 泰国 , "BR": 巴西 , "MA": 摩洛哥, "CL": 智利, "PE": 秘鲁, "VE": 委内瑞拉）
///   - page: 当前页码
///   - size: 每页大小
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)getAnchorListWithCountry:(NSString *)country
                            page:(NSInteger)page
                         size:(NSInteger)size
                      success:(void (^)(NSDictionary *result))successBlock
                      failued:(void (^)(NSError *error))failuedBlock;


/// 搜索主播
/// - Parameters:
///   - keyword: 关键字 （目前只支持Nickname和User_code 全匹配查询，不支持模糊查询）
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)searchAnchorWithKeyword:(NSString *)keyword
                        success:(void (^)(NSDictionary *result))successBlock
                        failued:(void (^)(NSError *error))failuedBlock;


/// 获取主播详情
/// - Parameters:
///   - anchorID: 主播id
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)getAnchorDetailInfo:(NSInteger)anchorID
                   userCode:(NSString *)userCode
                    success:(void (^)(NSDictionary *result))successBlock
                    failued:(void (^)(NSError *error))failuedBlock;



/// 获取关注状态
/// - Parameters:
///   - anchorID: 主播id
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)getFollowStatusWithAnchorID:(NSInteger)anchorID
                            success:(void (^)(NSDictionary *result))successBlock
                            failued:(void (^)(NSError *error))failuedBlock;

/// 关注主播
/// - Parameters:
///   - anchorID: 主播id
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)addFollowWithAnchorID:(NSInteger)anchorID
                      success:(void (^)(NSDictionary *result))successBlock
                      failued:(void (^)(NSError *error))failuedBlock;


    /// 获取h5地址路径
+ (void)getH5ConfigDatasuccess:(void (^)(NSDictionary *result))successBlock
                      failued:(void (^)(NSError *error))failuedBlock;


/// 取消关注主播
/// - Parameters:
///   - anchorID: 主播id
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)cancelFollowWithAnchorID:(NSInteger)anchorID
                         success:(void (^)(NSDictionary *result))successBlock
                         failued:(void (^)(NSError *error))failuedBlock;


/// 获取礼物列表
/// - Parameters:
///   - giftType: 礼物类型  1=平台礼物；3=私密解锁礼物
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)getGiftListInfoWithGiftType:(NSString *)giftType Success:(void (^)(NSDictionary *result))successBlock
                            failued:(void (^)(NSError *error))failuedBlock;

        

/// 赠送礼物
/// - Parameters:
///   - anchorID: 主播id
///   - giftID: 礼物id
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)sendGiftWithAnchorID:(NSInteger)anchorID
                      giftID:(NSInteger)giftID
                    success:(void (^)(NSDictionary *result))successBlock
                    failued:(void (^)(NSError *error))failuedBlock;




    /// 获取视频通话金币单价
    /// - Parameters:
+ (void)getVideoCoinSuccess:(void (^)(NSDictionary *result))successBlock
                            failued:(void (^)(NSError *error))failuedBlock;




/// 获取主播礼物墙
/// - Parameters:
///   - anchorID: 主播id
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)getGiftWallWithAnchorID:(NSInteger)anchorID
                       userCode:(NSString *)userCode
                        success:(void (^)(NSDictionary *result))successBlock
                        failued:(void (^)(NSError *error))failuedBlock;


/// 获取视频通话记录
/// - Parameters:
///   - page: 当前页
///   - size: 分页大小
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)getVideoCallHistoryInfoWithPage:(NSInteger)page
                               size:(NSInteger)size
                            success:(void (^)(NSDictionary *result))successBlock
                            failued:(void (^)(NSError *error))failuedBlock;



/// 删除通话历史
+ (void)delCallHistory:(NSString *)ID
               success:(void (^)(NSDictionary *result))successBlock
               failued:(void (^)(NSError *error))failuedBlock;


/// 获取主播免费照片
/// - Parameters:
///   - anchorID: 主播id
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)getFreePhotosWithAnchorID:(NSInteger)anchorID
                         userCode:(NSString *)userCode
                          success:(void (^)(NSDictionary *result))successBlock
                          failued:(void (^)(NSError *error))failuedBlock;



/// 私密解锁
+ (void)getTradePrivacyUnlockWithUnLockId:(NSString *)unLockId
                          success:(void (^)(NSDictionary *result))successBlock
                          failued:(void (^)(NSError *error))failuedBlock;




/// 请求推荐主播视频拨打
/// - Parameters:
///   - successBlock: 成功回调                       recommendFrequency:  下一次请求时间间隔  0: 不需要开启定时任务获取下一次
///   - failuedBlock: 失败回调
+ (void)recommendVideoCallWithSuccess:(void (^)(NSDictionary *result))successBlock
                              failued:(void (^)(NSError *error))failuedBlock;





/// 拒接接听推荐视频
/// - Parameters:
///   - channelID: 房间号
///   - disableToday: 今日推荐功能是否关闭
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)rejectRecommendVideoCallWithChannelID:(NSString *)channelID
                                 disableToday:(BOOL)disableToday
                                      success:(void (^)(NSDictionary *result))successBlock
                                      failued:(void (^)(NSError *error))failuedBlock;



/// 获取关注列表
/// - Parameters:
///   - page: 当前分页
///   - size: 分页大小
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)getFollowingInfowithWithPage:(NSInteger)page
                                size:(NSInteger)size
                             success:(void (^)(NSDictionary *result))successBlock
                             failued:(void (^)(NSError *error))failuedBlock;



/// 获取粉丝列表
/// - Parameters:
///   - page: 当前分页
///   - size: 分页大小
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)getFansInfowithWithPage:(NSInteger)page
                                size:(NSInteger)size
                             success:(void (^)(NSDictionary *result))successBlock
                             failued:(void (^)(NSError *error))failuedBlock;



/// 获取问候语
/// - Parameters:
///   - anchorID: 主播ID
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)getGreetingWithAnchorID:(NSInteger)anchorID
                        success:(void (^)(NSDictionary *result))successBlock
                        failued:(void (^)(NSError *error))failuedBlock;



/// 打招呼
/// - Parameters:
///   - anchorID: 主播ID
///   - greetID: 招呼ID
///   - successBlock: 成功回到
///   - failuedBlock: 失败回调
+ (void)greetingWithAnchorID:(NSInteger)anchorID
                     greetID:(NSInteger)greetID
                     success:(void (^)(NSDictionary *result))successBlock
                     failued:(void (^)(NSError *error))failuedBlock;


/// 心动速配
/// - Parameters:
///   - successBlock: 成功回到     anchors: 为空数组是需按轮询间隔时长进行下一次请求，如果不为空则不需要下次请求
///                            heartbeatMatchTimeOut: 超时未速配到主播，退出速配界面
///                            heartbeatMatchWaitTime：轮询间隔时长
///   - failuedBlock: 失败回调
+ (void)heartBeatWithSuccess:(void (^)(NSDictionary *result))successBlock
                     failued:(void (^)(NSError *error))failuedBlock;



/// 用户取消心动速配
/// - Parameters:
///   - batchId: 心动速配接口返回值带有该值
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)cancelHeartBeatWithBatchId:(NSString *)batchId
                             success:(void (^)(NSDictionary *result))successBlock
                             failued:(void (^)(NSError *error))failuedBlock;


/// 主播拨打，用户拒绝接听
/// - Parameters:
///   - channelId: 房间号
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)anchorCallCancel:(NSString *)channelId
                 success:(void (^)(NSDictionary *result))successBlock
                 failued:(void (^)(NSError *error))failuedBlock;



/// 主播拨打，用户接听
/// - Parameters:
///   - channelId: 房间号
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
+ (void)anchorCallAccept:(NSString *)channelId
                 success:(void (^)(NSDictionary *result))successBlock
                 failued:(void (^)(NSError *error))failuedBlock;



/// 用户手动取消拨打通话
+ (void)userCancalCallChannelID:(NSString *)channelID
                      success:(void (^)(NSDictionary *result))successBlock
                      failued:(void (^)(NSError *error))failuedBlock;




@end

NS_ASSUME_NONNULL_END

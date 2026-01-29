//
//  JLUserService.h
//  JuliFramework
//
//  Created by percent on 2025/3/29.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcKit.h>
#import "JLAnchorUserModel.h"
#import "JLUserModel.h"
#import "JLStorageUtil.h"
NS_ASSUME_NONNULL_BEGIN

@interface JLUserService : NSObject

@property (nonatomic, strong) JLUserModel *userInfo;

+ (instancetype)shared;


///  用户登录
- (void)loginUserId:(NSString *)userID;


///  用户退出
- (void)logout;




    /// 用户登录
    /// - Parameter userID: 用户唯一标识符
    /// - Parameter successBlock: 成功回调
    /// - Parameter failuedBlock: 失败回调
- (void)initServiceWithUserID:(NSString *)userID success:(void(^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;



/// 缓存主播信息
/// - Parameters:
///   - targetID: 主播id
///   - nickname: 主播昵称
///   - avatar: 主播头像
///   - country: 主播国家
- (void)saveInfoWithTargetID:(NSInteger)targetID nickname:(NSString *)nickname avatar:(NSString *)avatar country:(NSString *)country;


/// 获取主播信息
/// - Parameter targetID: 主播id
- (NSDictionary *)getInfoWithTargetID:(NSInteger)targetID;


    /// 赠送礼物
    /// - Parameters:
    ///   - anchorId: 主播id
    ///   - channelId: 主播昵称
    ///   - giftId: 礼物id
    ///   - giveNum: 礼物数量
+ (void)sendGiftInfoWithAnchorId:(NSInteger)anchorId channelId:(NSString *)channelId giftId:(NSString *)giftId giveNum:(NSString *)giveNum success:(void (^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;


    /// 查询威步用户金币
- (void)getUserCoinSuccess:(void(^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;



@end

NS_ASSUME_NONNULL_END

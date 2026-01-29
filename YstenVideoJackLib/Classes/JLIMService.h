//
//  JLIMService.h
//  JuliFramework
//
//  Created by percent on 2025/3/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RCMessage;
@class JLIMService;

@protocol JLIMServiceDelegate <NSObject>



/// 监听接收到融云消息 (客户端使用)
/// - Parameters:
///   - service: service
///   - message: 融云消息
- (void)didReceiveMessage:(RCMessage *)message;



// 跳转用户个人中心界面
- (void)pushPresonCenter:(NSString *)userId;



// 弹出去充值(AlertView)
- (void)showRechargeAlertView;







/// 监听接收到融云消息 (SDK使用)
/// - Parameters:
///   - service: service
///   - message: 融云消息
- (void)imService:(JLIMService *)service didReceiveMessage:(RCMessage *)message;

@end

@interface JLIMService : NSObject

// 设置代理，接收融云消息
@property(nonatomic, weak) id<JLIMServiceDelegate> delegate;

+ (instancetype)shared;


// 初始化
- (void)initSystem;



// 连接IM服务器
- (void)initService;



/// 融云登出
- (void)logout;
























/// 发送视频通话状态消息
/// - Parameters:
///   - status: 3: 通话异常  4:用户取消  5: 主播拒绝      8:主播未接听超时    9:主播忙线
///   - anchorID: 主播id
///   - channelID: 用户id
- (void)sendVideoStatusMessage:(NSString *)status
                      anchorID:(NSString *)anchorID
                     channelID:(NSString *)channelID;


/// 心动速配发送用户进入房间消息
/// - Parameters:
///   - channelID: 房间号
///   - anchorID: 主播id
///   - anchorRtcToken: 主播进入房间token
- (void)sendJoinHeartBeatMessageWithChannelID:(NSString *)channelID
                                     anchorID:(NSString *)anchorID
                               anchorRtcToken:(NSString *)anchorRtcToken;




///  设置消息拓展字段状态 用于解锁私密视频或者图片
/// - Parameters:
///   - status: 0: 未解锁     1: 已解锁    2:超时未解锁
///   - messageId: 消息ID
- (void)setMessageExtraStatus:(NSString *)status
                    messageId:(NSInteger)messageId
                     callback:(void (^) (BOOL result))callback;


@end

NS_ASSUME_NONNULL_END

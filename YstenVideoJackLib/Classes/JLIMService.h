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





// 弹出去充值提示弹窗(AlertView)
- (void)showRechargeAlertView:(UIViewController *)vc;



// 去解锁vip
- (void)JumpToUnlockVIP;



// 开启全局IQkeyboard键盘
- (void)openIQKeyboard;


// 关闭全局IQkeyboard键盘
- (void)closeIQKeyboard;


// 视频通话结束 (开启全局IQkeyborad键盘)
- (void)cancelRoomVideo;



// 弹出设备控制面板弹窗(AlertView)
/// - Parameter anchorID: 主播id
/// - Parameter userCode: 主播userCode
/// - Parameter roomID: 房间roomID
- (void)showDiveceControlPanelAlertView:(NSString *)anchorID userCode:(NSString *)userCode roomID:(NSString *)roomID;



// 弹出主播邀请设备控制面板弹窗(AlertView)
/// - Parameter anchorID: 主播id
/// - Parameter userCode: 主播userCode
/// - Parameter roomID: 房间roomID
- (void)showAnchorInviteDiveceControlPanelAlertView:(NSString *)anchorID userCode:(NSString *)userCode roomID:(NSString *)roomID;




/// 监听接收到融云消息 (SDK使用)
/// - Parameters:
///   - service: service
///   - message: 融云消息
- (void)imService:(JLIMService *)service didReceiveMessage:(RCMessage *)message;



@end


@interface JLIMService : NSObject

// 设置代理，接收融云消息
@property (nonatomic, weak) id<JLIMServiceDelegate> delegate;

// 是否开启跟随系统颜色模式
@property (nonatomic, assign) BOOL isInterfaceStyle;
// 本地颜色模式 model  (白色1 暗黑2)
@property (nonatomic, copy) NSString *model;

+ (instancetype)shared;


// 初始化
- (void)initSystem;


// 连接IM服务器
- (void)initService;





/// 跳转深度聊天
/// - Parameter UINavigationViewConller: nav
 - (void)pushChatViewController:(UIViewController *)viewController;
    

    
/// 拨打视频通话
/// - Parameter jlAnchorId: 主播id
- (void)pushCallVideoViewController:(NSString *)jlAnchorId;



// 获取所有未读消息
- (void)updateAllUnreadMessages:(nullable void (^)(int unreadCount))completion;




/// 系统颜色模式开关 和 初始颜色模式Model值
/// - Parameter interfaceStyle: 是否开启跟随系统颜色模式
/// - Parameter model: 自定义颜色模式值
- (void)getIsOverrideUserInterfaceStyle:(BOOL)interfaceStyle model:(NSString *)model;




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

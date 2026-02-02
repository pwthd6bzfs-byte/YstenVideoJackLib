//
//  DCCustomMessage.h
//  GoMaster
//
//  Created by percent on 2024/1/27.
//

#import <RongIMLibCore/RongIMLibCore.h>
NS_ASSUME_NONNULL_BEGIN

#define RCCustomMessageIdentifier @"mikchat"
#define RCVideoMessageIdentifier @"mikchat:videocall"
#define RCAibMessageIdentifier @"mikchat:privateAib"
#define RCGiftMessageIdentifier @"mikchat:gift"
#define RCAskGiftMessageIdentifier @"mikchat:askgift"
#define RCDeviceControlMessageIdentifier @"mikchat:devicecontrol"
#define RCDeviceOrderMessageIdentifier @"mikchat:deviceorder"
#define RCDeviceInviteMessageIdentifier @"mikchat:deviceInvite"
#define RCRecommendMessageIdentifier @"mikchat:recommend"
#define RCHeartBeatMessageIdentifier @"mikchat:joinHeartBeat"
#define RCJoinHeartBeatMessageIdentifier @"mikchat:hasJoin"
#define RCPrivateMediaMessageIdentifier @"mikchat:unlockPrivacyInvite"
#define RCAnchorCallMessageIdentifier @"mikchat:call"


// 拨打视频通话（挂断）消息
@interface JLCustomMessage : RCMessageContent

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *giftCode;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userCategory;
@property (nonatomic, strong) NSString *headFileName;
@property (nonatomic, strong) NSString *giveNum;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *followFlag;
@property (nonatomic, strong) NSString *userRole;

@property (nonatomic, strong) NSString *tendsId;

+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                       giftCode:(NSString *)giftCode
                         userId:(NSString *)userId
                   userCategory:(NSString *)userCategory
                   headFileName:(NSString *)headFileName
                        giveNum:(NSString *)giveNum
                       nickName:(NSString *)nickName
                     followFlag:(NSString *)followFlag
                       userRole:(NSString *)userRole
                        tendsId:(NSString *)tendsId;

@end


// 视频通话记录消息
@interface JLVideoMessage : RCMessageContent

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userCategory;
@property (nonatomic, strong) NSString *headFileName;
@property (nonatomic, strong) NSString *giveNum;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *followFlag;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *subStatus; // ("201": "主播挂断"), ("202", "用户挂断"),("203", "系统结束-余额不足"),("402", "超时未接听"),("406", "主播拒绝"),("5", "已拒接")
@property (nonatomic, strong) NSString *videoStatus;      // ("0": "待接通"), ("1", "通话中"),("2", "通话完成"),("3", "通话异常"),("4", "已取消"),("5", "已拒接"),("7", "销毁回调");  废弃

@property (nonatomic, strong) NSString *anchorId;

+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                       duration:(NSString *)duration
                         userId:(NSString *)userId
                   userCategory:(NSString *)userCategory
                   headFileName:(NSString *)headFileName
                        giveNum:(NSString *)giveNum
                       nickName:(NSString *)nickName
                     followFlag:(NSString *)followFlag
                       userRole:(NSString *)userRole
                       anchorId:(NSString *)anchorId
                    videoStatus:(NSString *)videoStatus;

@end


// 礼物消息
@interface JLGiftMessage : RCMessageContent

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *giftId;
@property (nonatomic, strong) NSString *giftCode;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *userCategory;
@property (nonatomic, strong) NSString *giveNum;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *giftUrl;
@property (nonatomic, strong) NSString *giftName;
@property (nonatomic, strong) NSString *giftPrice;
@property (nonatomic, strong) NSString *giftSvgaUrl;


+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                         giftId:(NSString *)giftId
                       giftCode:(NSString *)giftCode
                         userId:(NSNumber *)userId
                   userCategory:(NSString *)userCategory
                        giveNum:(NSString *)giveNum
                       nickName:(NSString *)nickName
                       userRole:(NSString *)userRole
                        giftUrl:(NSString *)giftUrl
                       giftName:(NSString *)giftName
                      giftPrice:(NSString *)giftPrice
                    giftSvgaUrl:(NSString *)giftSvgaUrl;

@end

// 索要礼物消息
@interface JLAskGiftMessage : RCMessageContent

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *giftId;
@property (nonatomic, strong) NSString *giftCode;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userCategory;
@property (nonatomic, strong) NSString *giveNum;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *giftUrl;
@property (nonatomic, strong) NSString *giftName;
@property (nonatomic, strong) NSString *giftPrice;
@property (nonatomic, strong) NSString *giftSvgaUrl;

+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                         giftId:(NSString *)giftId
                       giftCode:(NSString *)giftCode
                         userId:(NSString *)userId
                   userCategory:(NSString *)userCategory
                        giveNum:(NSString *)giveNum
                       nickName:(NSString *)nickName
                       userRole:(NSString *)userRole
                        giftUrl:(NSString *)giftUrl
                       giftName:(NSString *)giftName
                      giftPrice:(NSString *)giftPrice
                    giftSvgaUrl:(NSString *)giftSvgaUrl;

@end


@interface JLDeviceControlMessage : RCMessageContent

@property (nonatomic, strong) NSString *type;           // ("0": "控制关"， "1": "控制开")
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userCategory;
@property (nonatomic, strong) NSString *headFileName;
@property (nonatomic, strong) NSString *giveNum;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *followFlag;
@property (nonatomic, strong) NSString *userRole;

    ///初始化
+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                       giftCode:(NSString *)giftCode
                         userId:(NSString *)userId
                   userCategory:(NSString *)userCategory
                   headFileName:(NSString *)headFileName
                        giveNum:(NSString *)giveNum
                       nickName:(NSString *)nickName
                     followFlag:(NSString *)followFlag
                       userRole:(NSString *)userRole;


@end

///
@interface JLDeviceOrderMessage : RCMessageContent

@property (nonatomic, strong) NSString *type;         // 默认传 ”0“
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userCategory;
@property (nonatomic, strong) NSString *headFileName;
@property (nonatomic, strong) NSString *giveNum;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *followFlag;
@property (nonatomic, strong) NSString *userRole;
@property (nonatomic, strong) NSString *command;        // 控制命令

+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                         userId:(NSString *)userId
                   userCategory:(NSString *)userCategory
                   headFileName:(NSString *)headFileName
                        giveNum:(NSString *)giveNum
                       nickName:(NSString *)nickName
                     followFlag:(NSString *)followFlag
                       userRole:(NSString *)userRole
                        command:(NSString *)command;

@end


/// 设备邀请消息
@interface JLDeviceInviteMessage : RCMessageContent

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;

+ (instancetype)messageWithType:(NSString *)type
                        content:(NSString *)content;

@end


@interface JLRecommendMessage : RCMessageContent

@property (nonatomic, strong) NSString *type;          // 消息类型
@property (nonatomic, strong) NSString *channelId;     // 房间ID
@property (nonatomic, assign) NSInteger anchorId;        // 主播id
@property (nonatomic, strong) NSString *userCode;      // 主播code
@property (nonatomic, strong) NSString *headFileName;  // 主播头像
@property (nonatomic, strong) NSString *showVideoUrl;  // 主播视频地址
@property (nonatomic, strong) NSString *nickName;      // 主播头像
@property (nonatomic, strong) NSString *gender;        // 性别
@property (nonatomic, strong) NSString *age;           // 年龄
@property (nonatomic, strong) NSString *country;       // 国家
@property (nonatomic, strong) NSString *showText;      // 显示文本
@property (nonatomic, strong) NSString *token;         // 视频通话token
@property (nonatomic, assign) NSInteger price;         // 视频通话价格
@property (nonatomic, strong) NSString *nationFlag;    // 国旗


+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                       anchorId:(NSInteger )anchorId
                       userCode:(NSString *)userCode
                   headFileName:(NSString *)headFileName
                   showVideoUrl:(NSString *)showVideoUrl
                       nickName:(NSString *)nickName
                         gender:(NSString *)gender
                            age:(NSString *)age
                        country:(NSString *)country
                       showText:(NSString *)showText
                          token:(NSString *)token
                          price:(NSInteger )price
                     nationFlag:(NSString *)nationFlag;

@end


@interface JLHeartBeatMessage : RCMessageContent

@property (nonatomic, strong) NSString *type;          // 消息类型
@property (nonatomic, strong) NSString *channelId;     // 房间ID
@property (nonatomic, strong) NSString *noticeTime;    // 创建时间

@property (nonatomic, assign) NSInteger anchorId;        // 主播id
@property (nonatomic, strong) NSString *anchorCode;      // 主播code
@property (nonatomic, strong) NSString *anchorHeadFileName;      //  主播头像
@property (nonatomic, strong) NSString *anchorNickName;  // 主播昵称
@property (nonatomic, strong) NSString *anchorCountry;  // 主播国家
@property (nonatomic, strong) NSString *anchorRtcToken;      // 房间token
@property (nonatomic, strong) NSString *anchorNationalFlagUrl;        // 主播国旗

@property (nonatomic, assign) NSInteger userId;        // 用户id
@property (nonatomic, strong) NSString *userHeadFileName;      // 用户头像
@property (nonatomic, strong) NSString *userNickName;  // 用户昵称
@property (nonatomic, strong) NSString *userCountry;  // 用户国家
@property (nonatomic, strong) NSString *userRtcToken;      // 房间token
@property (nonatomic, strong) NSString *userNationalFlagUrl;        // 用户国旗
@property (nonatomic, assign) NSInteger followFlag;
@property (nonatomic, assign) NSInteger coinVideoPrice;
@property (nonatomic, assign) NSInteger devicesNum;

+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                     noticeTime:(NSString *)noticeTime
                       anchorId:(NSInteger )anchorId
                     anchorCode:(NSString *)anchorCode
             anchorHeadFileName:(NSString *)anchorHeadFileName
                 anchorNickName:(NSString *)anchorNickName
                  anchorCountry:(NSString *)anchorCountry
                 anchorRtcToken:(NSString *)anchorRtcToken
          anchorNationalFlagUrl:(NSString *)anchorNationalFlagUrl
                         userId:(NSInteger )userId
               userHeadFileName:(NSString *)userHeadFileName
                   userNickName:(NSString *)userNickName
                    userCountry:(NSString *)userCountry
                   userRtcToken:(NSString *)userRtcToken
            userNationalFlagUrl:(NSString *)userNationalFlagUrl
                     followFlag:(NSInteger )followFlag
                 coinVideoPrice:(NSInteger )coinVideoPrice
                     devicesNum:(NSInteger )devicesNum;

@end


@interface JLJoinHeartBeatMessage : RCMessageContent

@property (nonatomic, strong) NSString *type;          // 消息类型
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *anchorRtcToken;


+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                 anchorRtcToken:(NSString *)anchorRtcToken;

@end



///  私密照解锁邀请消息
///  当收到该消息内容时，需要查看RCMessage中的extra字段，用于判断该媒体消息是否解锁
///  每次获取聊天消息时，需要查看expirationTime字段，用于判断该消息是否过期，当过期后不可调用解锁接口
///  当调用解锁接口并获得成功回调时，需要调用[JLIMService setMessageExtraStatus]更新该消息状态，
@interface JLMediaPrivateMessage : RCMessageContent

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *inviteTime;
@property (nonatomic, assign) NSInteger expirationTime;
@property (nonatomic, assign) NSInteger unlockId;
@property (nonatomic, strong) NSString *giftCode;
@property (nonatomic, strong) NSString *giftUrl;
@property (nonatomic, strong) NSString *giftName;
@property (nonatomic, assign) NSInteger giftPrice;
@property (nonatomic, assign) NSInteger giftId;
@property (nonatomic, strong) NSString *giftSvgaUrl;
@property (nonatomic, strong) NSString *privacyUrl;
@property (nonatomic, strong) NSString *firstFrameImageUrl;
@property (nonatomic, assign) NSInteger duration;


+ (instancetype)messageWithType:(NSString *)type
                     inviteTime:(NSString *)inviteTime
                 expirationTime:(NSInteger )expirationTime
                       unlockId:(NSInteger )unlockId
                       giftCode:(NSString *)giftCode
                        giftUrl:(NSString *)giftUrl
                       giftName:(NSString *)giftName
                      giftPrice:(NSInteger )giftPrice
                         giftId:(NSInteger )giftId
                    giftSvgaUrl:(NSString *)giftSvgaUrl
                     privacyUrl:(NSString *)privacyUrl
             firstFrameImageUrl:(NSString *)firstFrameImageUrl
                       duration:(NSInteger)duration;

@end


/// 新增主播主动拨打功能
/// 用户端监听该消息，当接收到该消息是，弹出接听界面
/// 在界面界面，当用户点击接收时，调用JLAPIService的anchorCallAccept接口
/// 在界面界面，当用户点击拒绝时，调用JLAPIService的anchorCallCancel接口
@interface JLAnchorCallMessage : RCMessageContent

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *headFileName;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *rtcToken;


+ (instancetype)messageWithType:(NSString *)type
                   headFileName:(NSString *)headFileName
                         userId:(NSInteger )userId
                       nickName:(NSString *)nickName
                      channelId:(NSString *)channelId
                       rtcToken:(NSString *)rtcToken;

@end


NS_ASSUME_NONNULL_END

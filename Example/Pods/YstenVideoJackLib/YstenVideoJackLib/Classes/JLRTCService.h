//
//  JLRTCService.h
//  JuliFramework
//
//  Created by percent on 2025/3/29.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcKit.h>
#import "JLAnchorUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JLRTCService;
@class  RCMessage;
@protocol JLRTCServiceDelegate <NSObject>

@optional

/// 拨打视频电话发生异常
/// - Parameters:
///   - service: 视频模块
///   - error: 异常错误
- (void)rtcService:(JLRTCService *)service didOccurError:(NSError *)error;


/// 用户加入房间
/// - Parameters:
///   - service: 视频模块
///   - channel: 房间号
///   - uid: 用户id
- (void)rtcService:(JLRTCService *)service didJoinChannel:(NSString *)channel withUid:(NSInteger)uid;


/// 主播加入房间
/// - Parameters:
///   - service: 视频模块
///   - uid: 主播id
- (void)rtcService:(JLRTCService *)service didJoinOfUid:(NSUInteger)uid;


/// 用户重新加入房间
/// - Parameters:
///   - service: 视频模块
///   - channel: 房间号
///   - uid: 用户端id
- (void)rtcService:(JLRTCService *)service didRejoinChannel:(NSString *)channel withUid:(NSInteger)uid;


///  主播离线
/// - Parameters:
///   - service: 视频模块
///   - uid: 主播id
- (void)rtcService:(JLRTCService *)service didOfflineOfUid:(NSUInteger)uid;


- (void)rtcService:(JLRTCService *)service didVideoStatusMessage:(RCMessage *)message;


- (void)rtcService:(JLRTCService *)service didJoinHeartBeatRoom:(NSString *)channel;

@end

@interface JLRTCService : NSObject

@property (nonatomic,strong) AgoraRtcEngineKit *agoraKit;
@property (nonatomic, weak) id<JLRTCServiceDelegate> delegate;

+ (instancetype)shared;


/// 拨打视频电话
/// - Parameters:
///   - anchorID: 主播id
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
- (void)videoCallWithAnchorID:(NSInteger)anchorID success:(void(^)(NSString *channel,NSString *token,JLAnchorUserModel *anchorUserInfo))successBlock failued:(void (^)(NSError *error))failuedBlock;


/// 用户加入声网房间
/// - Parameters:
///   - channel: 房间号
///   - token: 房间token
///   - needPush: 是否需要向主播推送房间信息，目前心动速配功能不需要推送，其余功能均需推送
- (void)joinChannel:(NSString *)channel token:(NSString *)token needPush:(BOOL)needPush;


/// 结束通话
/// - Parameters:
///   - successBlock: 成功回调
///   - failuedBlock: 失败回调
- (void)endVideoCallWithSuccess:(void(^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock;


- (void)recommendVideoCallInitAnchorID:(NSInteger)anchorID channelID:(NSString *)channelID;

@end

NS_ASSUME_NONNULL_END

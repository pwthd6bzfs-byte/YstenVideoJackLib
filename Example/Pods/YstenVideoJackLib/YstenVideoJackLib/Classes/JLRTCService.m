//
//  JLRTCService.m
//  JuliFramework
//
//  Created by percent on 2025/3/29.
//

#import "JLRTCService.h"
#import <AgoraRtcKit/AgoraRtcKit.h>
#import "JLNetworkTool.h"
#import "Config/Config.h"
#import "JLUserService.h"
#import "JLUserModel.h"
#import "JLIMService.h"
#import "JLCustomMessage.h"
#import "SVProgressHUD.h"
#import "Config.h"
#import "UIColor+HexColor.h"
#import <RongCloudOpenSource/RongIMKit.h>

static NSString *const JLErrorDomain = @"com.juli.framework.error";

@interface JLRTCService ()<AgoraRtcEngineDelegate>

@property (nonatomic, strong) NSString *channelID;
@property (nonatomic, assign) BOOL isFirstRecharge;
@property (nonatomic, strong) NSTimer *videoTimer;
@property (nonatomic, assign) NSInteger videoDuration;
@property (nonatomic, assign) BOOL isJoined;
@property (nonatomic, strong) NSString *currentAnchorID;

@end

@implementation JLRTCService

static JLRTCService *shared = nil;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didVideoCallRefuseAction:) name:kNotificationVideoCallRefuse object:nil];
        
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)videoCallWithAnchorID:(NSInteger)anchorID success:(void(^)(NSString *channel,NSString *token,JLAnchorUserModel *anchorUserInfo))successBlock failued:(void (^)(NSError *error))failuedBlock {
    
    AgoraRtcEngineConfig *config = [[AgoraRtcEngineConfig alloc] init];
    config.appId = @"29c17b4bd3e540b088b60c61c79214d0";
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithConfig:config delegate:self];

    _isJoined = NO;
    _isFirstRecharge = YES;
    _videoDuration = 0;
    
    __block NSError *error = nil;
    __block NSString *channel = nil;
    __block NSString *token = nil;
        
    self.currentAnchorID = [NSString stringWithFormat:@"%ld", anchorID];
    dispatch_group_t group= dispatch_group_create();
    
    [SVProgressHUD show];
    dispatch_group_enter(group);
    [JLNetworkTool createVideoCallChannel:NO sourceType:@"1" userID:anchorID sourcePage:@"5" userRole:@"1" success:^(NSDictionary * _Nonnull result) {
        channel = result[@"data"][@"channelId"];
        dispatch_group_leave(group);
    } failued:^(NSError * _Nonnull err) {
        error = err;
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (error != nil) {
            [SVProgressHUD dismiss];
            NSString *msg = error.userInfo[@"NSLocalizedDescription"];
            if ([msg length] > 0) {
                [SVProgressHUD showImage:nil status:msg];
            }

            if (error.code == 4000) {
                [[JLIMService shared] sendVideoStatusMessage:@"9" anchorID:self.currentAnchorID channelID:self.channelID];
            }
            failuedBlock(error);
            return;
        }
        self.channelID = channel;
        // 获取RCT token
        [JLNetworkTool requestVideoCallTokenWithChannelID:channel success:^(NSDictionary * _Nonnull result) {
            token = result[@"data"];
//            successBlock(channel,token);
            
            // 获取主播信息(最新的视频通话费用)
            [JLNetworkTool requestAnchorDetailInfoWithUserID:anchorID userCode:@"" success:^(NSDictionary * _Nonnull resultOne) {
                
                [SVProgressHUD dismiss];
                JLAnchorUserModel *userInfo = [JLAnchorUserModel modelWithJSON:resultOne[@"data"]];
                RCUserInfo *info = [RCUserInfo new];
                info.name = userInfo.nickName;
                info.portraitUri = userInfo.headFileName;
                info.userId = [NSString stringWithFormat:@"%ld",(long)userInfo.userID];
                [[RCIM sharedRCIM] refreshUserInfoCache:info withUserId:info.userId];
                successBlock(channel,token,userInfo);

            } failued:^(NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                failuedBlock(error);
            }];
            
        } failued:^(NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            [[JLIMService shared]  sendVideoStatusMessage:@"3" anchorID:self.currentAnchorID channelID:self.channelID];
            failuedBlock(error);
        }];
    });
}

- (void)recommendVideoCallInitAnchorID:(NSInteger)anchorID channelID:(NSString *)channelID {
    [self leaveRoom];
    AgoraRtcEngineConfig *config = [[AgoraRtcEngineConfig alloc] init];
    config.appId = @"29c17b4bd3e540b088b60c61c79214d0";
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithConfig:config delegate:self];
    
    _isJoined = NO;
    _isFirstRecharge = YES;
    _videoDuration = 0;
    
    self.currentAnchorID = [NSString stringWithFormat:@"%ld", anchorID];
    self.channelID = channelID;
}

- (void)joinChannel:(NSString *)channel token:(NSString *)token needPush:(BOOL)needPush {
    AgoraRtcChannelMediaOptions *options = [[AgoraRtcChannelMediaOptions alloc] init];
    options.channelProfile = AgoraChannelProfileLiveBroadcasting;
    options.clientRoleType = AgoraClientRoleBroadcaster;
    
    JLUserModel *userInfo = [JLUserService shared].userInfo;
    
    [self.agoraKit joinChannelByToken:token channelId:channel uid:[userInfo.userCode intValue] mediaOptions:options joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        if (needPush == YES) {
            [JLNetworkTool pushChannel:channel success:^(NSDictionary * _Nonnull result) {
                NSLog(@"");
            } failued:^(NSError * _Nonnull error) {
                NSLog(@"");
            }];
        } else{
//            [[JLIMService shared] sendVideoStatusMessage:@"11" anchorID:self.currentAnchorID channelID:self.channelID];

//            if (self.delegate && [self.delegate respondsToSelector:@selector(rtcService:didJoinHeartBeatRoom:)]) {
//                [self.delegate rtcService:self didJoinHeartBeatRoom:channel];
//            }
        }
        [self.videoTimer fire];
    }];
    
}

- (void)leaveRoom {
    [self.agoraKit stopPreview];
    [self.agoraKit disableAudio];
    [self.agoraKit disableVideo];
    [self.agoraKit leaveChannel: nil];
    [self pauseCallTimer];
}


- (void)endVideoCallWithSuccess:(void(^)(NSDictionary *result))successBlock failued:(void (^)(NSError *error))failuedBlock {
    if (self.channelID == nil) {
        [self leaveRoom];
        failuedBlock([NSError errorWithDomain:@"JLRTCService.domin" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Channel is nil"}]);
        return;
    }
    
    [self leaveRoom];
    
    BOOL isTimeout = NO;
    if (self.isJoined == NO && self.videoDuration < 30) {
        isTimeout = true;
        [[JLIMService shared]  sendVideoStatusMessage:@"4" anchorID:self.currentAnchorID channelID:self.channelID];
    }
    
    [JLNetworkTool uploadUserVideoHangupWithChannelID:self.channelID disableToday:NO isTimeOutAnswer:isTimeout success:^(NSDictionary * _Nonnull result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock(result);
        });
    } failued:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failuedBlock(error);
        });
    }];
}


// 前端计费(废弃)
- (void)diamondDeduction {
    Weakself(ws);
    [JLNetworkTool diamondDeductionWithChannelID:self.channelID firstFlag:self.isFirstRecharge success:^(NSDictionary * _Nonnull result) {
        ws.isFirstRecharge = NO;
    } failued:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (ws.delegate && [ws.delegate respondsToSelector:@selector(rtcService:didOccurError:)]) {
                [ws.delegate rtcService:ws didOccurError:[NSError errorWithDomain:JLErrorDomain code:6001 userInfo:error.userInfo]];
            }
        });
    }];
}


- (void)didVideoCallRefuseAction:(NSNotification *)noti {
    [self leaveRoom];
//    [[JLIMService shared]  sendVideoStatusMessage:@"5" anchorID:self.currentAnchorID channelID:self.channelID];
    if (self.delegate && [self.delegate respondsToSelector:@selector(rtcService:didOccurError:)]) {
        [self.delegate rtcService:self didOccurError:[NSError errorWithDomain:JLErrorDomain code:6002 userInfo:@{NSLocalizedDescriptionKey:@"The anchor refused to answer"}]];
    }
}


- (NSTimer *)videoTimer {
    if(!_videoTimer) {
        _videoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            self.videoDuration ++;
            if (self.isJoined == NO && self.videoDuration >= 30) {
                    [self pauseCallTimer];
//                [[JLIMService shared]  sendVideoStatusMessage:@"8" anchorID:self.currentAnchorID channelID:self.channelID];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(rtcService:didOccurError:)]) {
                        [self.delegate rtcService:self didOccurError:[NSError errorWithDomain:JLErrorDomain code:6003 userInfo:@{NSLocalizedDescriptionKey:@"The anchor did not answer the call due to timeout."}]];
                    }
                
                [JLNetworkTool uploadUserVideoHangupWithChannelID:self.channelID disableToday:NO isTimeOutAnswer:NO success:^(NSDictionary * _Nonnull result) {
                    NSLog(@"客户端倒计时取消拨打电话成功");
                } failued:^(NSError * _Nonnull error) {
                    NSLog(@"客户端倒计时取消拨打电话失败");
                }];
                return;
            }
//            if(self.videoDuration % 60 == 0) {
//                JLLog(@"Recharge");
//                [self diamondDeduction];
//            }
        }];
    }
    return _videoTimer;
}

- (void)pauseCallTimer {
    if(self.videoTimer) {
        [self.videoTimer invalidate];
        self.videoTimer = nil;
    }
}

- (void)abnormalReport:(NSInteger)errorCode {
    [JLNetworkTool abnormalReport:self.channelID errorCode:errorCode success:^(NSDictionary * _Nonnull result) {
        NSLog(@"Report Success");
    } failued:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self abnormalReport:errorCode];
        });
    }];
}

#pragma mark - AgoraRtcEngineDelegate
- (void)rtcEngine:(AgoraRtcEngineKit *)engine didOccurError:(AgoraErrorCode)errorCode {
    // 移除
//    [self abnormalReport:errorCode];
    [self leaveRoom];
    if (self.delegate && [self.delegate respondsToSelector:@selector(rtcService:didOccurError:)]) {
        [self.delegate rtcService:self didOccurError:[NSError errorWithDomain:JLErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:@"Agora error. For details, refer to AgoraErrorCode based on errorCode."}]];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didJoinChannel:(NSString * _Nonnull)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rtcService:didJoinChannel:withUid:)]) {
        [self.delegate rtcService:self didJoinChannel:channel withUid:uid];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    self.isJoined = YES;
    _videoDuration = 0;
//    [self diamondDeduction];
    if (self.delegate && [self.delegate respondsToSelector:@selector(rtcService:didJoinOfUid:)]) {
        [self.delegate rtcService:self didJoinOfUid:uid];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didRejoinChannel:(NSString * _Nonnull)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rtcService:didRejoinChannel:withUid:)]) {
        [self.delegate rtcService:self didRejoinChannel:channel withUid:uid];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    [self leaveRoom];
    if (self.delegate && [self.delegate respondsToSelector:@selector(rtcService:didOfflineOfUid:)]) {
        [self.delegate rtcService:self didOfflineOfUid:uid];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit* _Nonnull)engine connectionChangedToState:(AgoraConnectionState)state reason:(AgoraConnectionChangedReason)reason {
    if (state == AgoraConnectionStateDisconnected || state == AgoraConnectionStateFailed) {
        [self leaveRoom];
        if (reason == AgoraConnectionChangedReasonBannedByServer) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(rtcService:didOccurError:)]) {
                [self.delegate rtcService:self didOccurError:[NSError errorWithDomain:JLErrorDomain code:6000 userInfo:@{NSLocalizedDescriptionKey:@"The connection between the SDK and Agora's edge server is banned by Agora's edge server."}]];
            }
        }
    }
}


@end

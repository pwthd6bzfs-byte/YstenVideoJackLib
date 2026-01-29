//
//  JLIMService.m
//  JuliFramework
//
//  Created by percent on 2025/3/29.
//

#import "JLIMService.h"
#import "JLNetworkTool.h"
#import "Config/Config.h"
#import "JLStorageUtil.h"
#import "JLUserUtil.h"
#import <RongCloudOpenSource/RongIMKit.h>
#import <RongIMLibCore/RongIMLibCore.h>
#import "JLCustomMessage.h"
#import "JLUserService.h"
#import "JLuserModel.h"
#import "JLRTCService.h"
#import "JLAPIService.h"
#import "SVProgressHUD.h"
#import "JLSystemConfigUtil.h"
#import "VideoViewController.h"
#import "NSObject+CurrentViewController.h"

@interface JLIMService ()<RCIMReceiveMessageDelegate,RCIMUserInfoDataSource>


@end

@implementation JLIMService

static JLIMService *shared = nil;

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

//- (void)initService{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRongCloudServiceInit:) name:kNotificationLoginSuccess object:nil];
//}
//

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}


- (void)initSystem{
    
    [JLAPIService getH5ConfigDatasuccess:^(NSDictionary * _Nonnull result) {
        
        NSString *h5String =  result[@"data"][@"downloadH5Address"];
        if (h5String) {
            [JLSystemConfigUtil saveInfoWithH5String:h5String];
        }
        
    } failued:^(NSError * _Nonnull error) {
        
    }];
    
    
    [JLAPIService getSystemConfigWithSuccess:^(NSDictionary * _Nonnull result) {
        NSDictionary *heartbeatMatchDict=  result[@"data"];
        if (heartbeatMatchDict) {
            [JLSystemConfigUtil saveInfoWithHeartbeatMatchDict:heartbeatMatchDict];
        }
        
    } failued:^(NSError * _Nonnull error) {
        
    }];
    
}



- (void)initService {
    
    Weakself(ws);
    [JLNetworkTool requestRongAppIDWithSuccess:^(NSDictionary * _Nonnull result) {
        NSString *rongAppID = result[@"data"];
        [ws rongCloundEngineInit:rongAppID];
    } failued:^(NSError * _Nonnull error) {
        JLLog(@"%@",error.userInfo[NSLocalizedDescriptionKey]);
    }];
    
    [JLNetworkTool requestRonngUserTokenWithSuccess:^(NSDictionary * _Nonnull result) {
        [ws rongCloundConnect:result[@"data"]];
        [SVProgressHUD dismiss];
        [SVProgressHUD showImage:nil status:@"登录成功"];
    } failued:^(NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [self initService];
        });
    }];
}

- (void)rongCloundEngineInit:(NSString *)rongAppID {
    RCInitOption *initOption = nil;
    
    // 注册自定义消息
    [[RCIM sharedRCIM]  initWithAppKey:rongAppID option:initOption];
    [[RCIM sharedRCIM]  registerMessageType:[JLCustomMessage class]];
    [[RCIM sharedRCIM]  registerMessageType:[JLVideoMessage class]];
    [[RCIM sharedRCIM]  registerMessageType:[JLGiftMessage class]];
    [[RCIM sharedRCIM]  registerMessageType:[JLAskGiftMessage class]];
    [[RCIM sharedRCIM]  registerMessageType:[JLDeviceControlMessage class]];
    [[RCIM sharedRCIM]  registerMessageType:[JLDeviceOrderMessage class]];
    [[RCIM sharedRCIM]  registerMessageType:[JLRecommendMessage class]];
    [[RCIM sharedRCIM]  registerMessageType:[JLHeartBeatMessage class]];
    [[RCIM sharedRCIM]  registerMessageType:[JLJoinHeartBeatMessage class]];
    [[RCIM sharedRCIM]  registerMessageType:[JLDeviceInviteMessage class]];
    [[RCIM sharedRCIM]  registerMessageType:[JLMediaPrivateMessage class]];
    
    __weak __typeof(self)weakSelf = self;
    // 消息拦截器
//    [RCCoreClient sharedCoreClient].messageInterceptor = (id)weakSelf;
    
    
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES; // 消息传递携带用户消息
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES; // 缓存用户信息
    [RCIM sharedRCIM].userInfoDataSource = self; // 用户信息提供者代理
    
        // IM全局UI及基础配置
    RCKitConfigCenter.font.secondLevel = 15;  // 全局二级文本大小
    RCKitConfigCenter.message.enableEditMessage = NO; // 是否开启消息编辑
    RCKitConfigCenter.ui.globalConversationAvatarStyle = RC_USER_AVATAR_RECTANGLE;
    
}

- (void)rongCloundConnect:(NSString *)rongcloundTonken {
    if(!rongcloundTonken || rongcloundTonken.length == 0 || [rongcloundTonken isKindOfClass:[NSNull class]]) {
        return;
    }
    
    // 先登出
    [[RCIM sharedRCIM] logout];
    
    // 再连接
    [[RCIM sharedRCIM] connectWithToken:rongcloundTonken timeLimit:5
                                           dbOpened:^(RCDBErrorCode code) {
            //消息数据库打开，可以进入到主页面
    } success:^(NSString *userId) {
            //连接成功
        JLLog(@"RC_CONNECT_SUCCESS");
        [[RCIM sharedRCIM] addReceiveMessageDelegate:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateUnreadMessageCount object: nil];
        });
        
    } error:^(RCConnectErrorCode status) {
        if (status == RC_CONN_TOKEN_INCORRECT) {
            JLLog(@"RC_CONN_TOKEN_INCORRECT");
                //Token 错误，可检查客户端 SDK 初始化与 App 服务端获取 Token 时所使用的 App Key 是否一致
        } else if(status == RC_CONNECT_TIMEOUT) {
                //连接超时，弹出提示，可以引导用户等待网络正常的时候再次点击进行连接
            JLLog(@"RC_CONNECT_TIMEOUT，5s后重试");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self rongCloundConnect:rongcloundTonken];
            });
        } else if(status == RC_CONNECTION_EXIST){
            
        }else {
                //无法连接 IM 服务器，请根据相应的错误码作出对应处理
            JLLog(@"RC_CONNECT_FAUILED");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self rongCloundConnect:rongcloundTonken];
            });
        }
    }];
}

- (void)destroyRonglloudService {
    [[RCIM sharedRCIM] disconnect];
}

    /// 融云登出
- (void)logout {
    [JLStorageUtil cleanUserInfo];
    [[RCIM sharedRCIM] logout];
}



- (void)sendVideoStatusMessage:(NSString *)status
                      anchorID:(NSString *)anchorID
                     channelID:(NSString *)channelID {
    if (anchorID == nil || channelID == nil) {
        return;
    }
    
    JLUserModel *userInfo = [JLUserService shared].userInfo;
    
    JLCustomMessage *customMessage = [JLCustomMessage messageWithType:@"4" channelId:channelID giftCode:@"" userId:[NSString stringWithFormat:@"%ld",userInfo.userID] userCategory:@"" headFileName:@"" giveNum:@"" nickName:@"" followFlag:@"" userRole:@"" tendsId:@""];

    
    RCMessage *message = [[RCMessage alloc] init];
    message.targetId = anchorID;
    message.content = customMessage;
    message.messageDirection = MessageDirection_SEND;
    message.senderUserId = [NSString stringWithFormat:@"%ld",[JLUserService shared].userInfo.userID];
    message.conversationType = ConversationType_PRIVATE;
    
    [[RCIM sharedRCIM] sendMessage:message pushContent:nil pushData:nil successBlock:^(RCMessage * _Nonnull successMessage) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imService:didReceiveMessage:)]) {
            [self.delegate imService:self didReceiveMessage:successMessage];
        }
    } errorBlock:^(RCErrorCode nErrorCode, RCMessage * _Nonnull errorMessage) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imService:didReceiveMessage:)]) {
            [self.delegate imService:self didReceiveMessage:errorMessage];
        }
    }];
    
}

- (void)sendJoinHeartBeatMessageWithChannelID:(NSString *)channelID
                                     anchorID:(NSString *)anchorID
                               anchorRtcToken:(NSString *)anchorRtcToken {
    if (anchorID == nil) {
        return;
    }
    JLJoinHeartBeatMessage *joinHeartBeatMessge = [JLJoinHeartBeatMessage messageWithType:@"100" channelId:channelID anchorRtcToken:anchorRtcToken];
    
    RCMessage *message = [[RCMessage alloc] init];
    message.targetId = anchorID;
    message.content = joinHeartBeatMessge;
    message.messageDirection = MessageDirection_SEND;
    message.senderUserId = [NSString stringWithFormat:@"%ld",[JLUserService shared].userInfo.userID];
    message.conversationType = ConversationType_PRIVATE;
    
    [[RCIM sharedRCIM] sendMessage:message pushContent:nil pushData:nil successBlock:^(RCMessage * _Nonnull successMessage) {
        NSLog(@"%@",successMessage);
    } errorBlock:^(RCErrorCode nErrorCode, RCMessage * _Nonnull errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}



#pragma mark - RCIMReceiveMessageDelegate
- (void)onRCIMReceived:(RCMessage *)message
                  left:(int)nLeft
               offline:(BOOL)offline
            hasPackage:(BOOL)hasPackage{
    NSLog(@"%@",message);

    if (nLeft == 0 && hasPackage == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationMessageRecive" object: nil];
    }
    
    
    // 代理消息(客户端使用)
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReceiveMessage:)]) {
        [self.delegate didReceiveMessage:message];
    }

    // 传递1v1视频聊天消息
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRcMessageSuccess object:message];
    
    
    
    if([message.content isKindOfClass:[JLCustomMessage class]]) {
        JLCustomMessage *customMessage = (JLCustomMessage *)message.content;
        if([customMessage.type integerValue] == 5) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVideoCallRefuse object: customMessage];
            });
        }
        return;
    }
    
    
    
    if ([message.content isKindOfClass:[JLRecommendMessage class]]) {
        JLRecommendMessage *recommendMessage = (JLRecommendMessage *)message.content;
        [[JLRTCService shared] recommendVideoCallInitAnchorID:recommendMessage.anchorId channelID:recommendMessage.channelId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(imService:didReceiveMessage:)]) {
                [self.delegate imService:self didReceiveMessage:message];
            }
        });
        return;
    }

    
    
//    NSString *extraString = message.content.extra;
//    if (extraString && extraString.length > 0) {
//        NSData *extraData = [extraString dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:extraData options:NSJSONReadingMutableContainers error:nil];
//        [JLUserUtil saveInfoWithName:[json objectForKey:@"nickName"] avatar:[json objectForKey:@"headFileName"] targetID:[message.senderUserId integerValue] country:[json objectForKey:@"country"]];
//    }
    
    if ([message.content isKindOfClass:[JLHeartBeatMessage class]]) {
        JLHeartBeatMessage *heartBeatMessage = (JLHeartBeatMessage *)message.content;
        [[JLRTCService shared] recommendVideoCallInitAnchorID:heartBeatMessage.anchorId channelID:heartBeatMessage.channelId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(imService:didReceiveMessage:)]) {
                [self.delegate imService:self didReceiveMessage:message];
            }
                            
            if ([message.content isKindOfClass:[JLHeartBeatMessage class]]) {
                JLHeartBeatMessage *recommendMessage = (JLHeartBeatMessage *)message.content;
                VideoViewController *controller = [[VideoViewController alloc] init];
                controller.modalPresentationStyle = 0;
                controller.channel = recommendMessage.channelId;
                controller.token = recommendMessage.userRtcToken;
                controller.isNeedPush = NO;
                controller.isHeartMatch = YES;
                controller.anchorID = recommendMessage.anchorId;
                controller.anchorRtcToken = recommendMessage.anchorRtcToken;
                
                JLAnchorUserModel *anchorUserInfo = [[JLAnchorUserModel alloc] init];
                anchorUserInfo.userID = recommendMessage.anchorId;
                anchorUserInfo.nickName = recommendMessage.anchorNickName;
                anchorUserInfo.userCode = recommendMessage.anchorCode;
                anchorUserInfo.headFileName = recommendMessage.anchorHeadFileName;
                anchorUserInfo.country = recommendMessage.anchorCountry;
                anchorUserInfo.nationalFlagUrl = recommendMessage.anchorNationalFlagUrl;
                anchorUserInfo.coinVideoPrice = recommendMessage.coinVideoPrice;
                controller.anchorUserInfo = anchorUserInfo;
                [[NSObject currentViewController] presentViewController:controller animated:YES completion:nil];
            }
            
        });
        return;
    }


    if ([message.content isKindOfClass:[JLVideoMessage class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(imService:didReceiveMessage:)]) {
                [self.delegate imService:self didReceiveMessage:message];
            }
        });
        return;
    }
}

- (void)setMessageExtraStatus:(NSString *)status
                    messageId:(NSInteger)messageId
                     callback:(void (^) (BOOL result))callback{
    [[RCCoreClient sharedCoreClient] setMessageExtra:messageId value:status completion:^(BOOL ret) {
        callback(ret);
    }];
}


#pragma mark -- RCIMMessageInterceptor
    // 配置其他用户的用户信息
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *_Nullable userInfo))completion{
    
    [JLAPIService getAnchorDetailInfo:[userId integerValue] userCode:@"" success:^(NSDictionary * _Nonnull result) {
        NSLog(@"%@",result);
        
        JLUserModel *model = [JLUserModel modelWithJSON:result[@"data"]];
        RCUserInfo *info = [RCUserInfo new];
        info.name = model.nickName;
        info.portraitUri = model.headFileName;
        info.userId = [NSString stringWithFormat:@"%ld",(long)model.userID];
        
        [[RCIM sharedRCIM] refreshUserInfoCache:info withUserId:info.userId];
        
        completion(info);
    } failued:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
        completion(nil);
    }];
    
}


- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
    NSLog(@"%ld",(long)status);
}


@end

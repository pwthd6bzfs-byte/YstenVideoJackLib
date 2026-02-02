//
//  DCNetworkHeader.h
//  GoMaster
//
//  Created by percent on 2024/1/26.
//

#import <Foundation/Foundation.h>
#import "Config.h"

#ifndef DCNetworkHeader_h
#define DCNetworkHeader_h


#define kServerPathThirdInfo @"/jlwbau/auth/third/token/twin"
#define kServerPathSystemInfo   @"/jlwbau/auth/sys/param/twin" // 系统配置数据
#define kServerPathLogin @"/jlwbau/open-api/sdkLogin/twin" // 登入获取用户数据
#define kServerPathRongCloundAppID @"/jlwbau/auth/rongclound/appId/twin" // 获取融云appId
#define kServerPathRongCloundUserToken   @"/jlwbmk/message/rongcloud/token/twin" // 获取融云token
#define kServerPathAgoraRTCToken   @"/jlwbmk/video/rtc/token/twin"  // 获取声网应用token
#define kServerPathCreateChannel   @"/jlwbmk/video/channel/twin" // 创建声网视频频道
#define kServerPathPushChannel   @"/jlwbmk/video/push/twin"  // 进退工频道给主播
#define kServerPathRongCloundTranslateToken   @"/jlwbmk/message/rongcloud/translate/token/twin"


#define kServerPathUserCoin   @"/blade-auth/user/wb-coins" // 查询威步用户金币
#define kServerPathSdkGice   @"/ks-mikchat/gift/sdkGive" // SDK赠送礼物
#define kServerPathVideoCoin   @"/ks-mikchat/open-api/videoCoin" // 获取视频通话金币单价
#define kServerPathH5Path   @"/blade-auth/app/h5Config" // 获取H5地址路径

#define kServerPathVideoHangup   @"/jlwbmk/video/push/cancel/twin"  // 用户端取消拨打

#define kServerPathHeartBeat @"/ks-mikchat/video/heartbeat/match" // 心动速配

#define kServerPathHeartBeatCancel @"/jlwbmk/video/heartbeat/exit/twin"  // 用户取消心动速配


#define kServerPathAnchorList @"/jlwbmk/anchor/major/list/twin"
#define kServerPathFollowAnchorList   @"/jlwbmk/anchor/follow/twin"

#define kServerPathAnchorDetailInfo   @"/jlwbmk/anchor/detail/twin"
#define kServerPathUploadFile   @"/jlwbre/resource/upload/twin"
#define kServerPathUpdataInfo   @"/jlwbau/user/update/twin"
#define kServerPathUserDetailInfo   @"/jlwbau/user/detail/twin"

#define kServerPathVideoDeduct   @"/jlwbmk/video/deduct/twin"

#define kServerPathHotAnchorInfo   @"/jlwbmk/anchor/show/twin"


#define kServerPathUserFollowers   @"/jlwbau/user/fans/twin"  // 关注我的
#define kServerPathUserFollowing   @"/jlwbau/user/follows/twin"  // 我关注的
#define kServerPathFollowFlag   @"/jlwbau/user/follow/flag/twin"  // 是否关注
#define kServerPathAddFollowing   @"/jlwbau/user/follow/twin"  // 关注用户
#define kServerPathCancelFollowing   @"/jlwbau/user/unfollow/twin"  // 取消关注用户


#define kServerPathCallHistory @"/jlwbmk/video/history/list/twin" // 通话历史
#define kServerPathDelCallHistory @"/jlwbmk/video/del/record" // 通话历史
#define kServerPathTradePrivacyUnlock @"/jlwbmk/trade/privacyUnlock"// 私密解锁

#define kServerPathRechargeProductList   @"/jlwbod/order/price/twin"
#define kServerPathSubscribeProductList   @"/jlwbod/order/price/sub/twin"
#define kServerPathNewOrder   @"/jlwbod/order/save/twin"
#define kServerPathLevelInfo   @"/jlwbau/diamond/level/list/twin"

#define kServerPathWalletRecord   @"/jlwbau/diamond/record/page/twin"
#define kServerPathMessageCountSubtract   @"/jlwbau/user/subtract/msg/send/twin"
#define kServerPathReportVideoTrend   @"/jlwbau/user/report/twin"
#define kServerPathReportingInfo   @"/jlwbau/user/report/list/twin"

#define kServerPathAccountCanceling   @"/jlwbau/auth/cancellation/twin"

#define kServerPathTrendCommont @"/jlwbmk/comment/save/twin"

#define kServerPathDataingRandom @"/jlwbmk/video/random/anchor/twin"

#define kServerPathSignInList @"/jlwbau/user/signIn/list/twin"

#define kServerPathUserSignIn @"/jlwbau/user/signIn/twin"

#define kServerPathUserHotRankInfo @"/jlwbmk/anchor/charts/twin"

#define kServerPathUserHotShow @"/jlwbmk/anchor/show/twin"

#define kServerPathAgreement @"/jlwbod/order/agreement/url/twin"

#define kServerPathCoachAnchorInfo @"/jlwbmk/anchor/type/other/twin"

#define kServerPathOrderVerify  @"/jlwbod/order/pay/check/twin"

#define kServerPathVMSettings @"/jlwbpb/user/script/config/list/twin"

#define kServerPathVMStatus @"/jlwbpb/user/push/status/twin"

#define kServerPathPushVideo @"/jlwbpb/user/push/condition/data/twin"

#define kServerPathPushMessage @"/jlwbpb/user/push/script/data/twin"

#define kServerPathRefuseCount @"/jlwbpb/user/reject/aib/twin"

#define kServerPathHangupOther @"/jlwbpb/user/hangup/other/aib/twin"

#define kServerPathMatchList @"/jlwbmk/anchor/random/spinner/list/twin"

#define kServerPathAnchorSearch @"/jlwbmk/anchor/major/list/twin"

#define kServerPathGiftList @"/jlwbmk/gift/list/twin"

#define kServerPathGiveGift @"/jlwbmk/gift/give/twin"


#define kServerPathMyPack @"/jlwbau/user/bag/list/twin"

#define kServerPathRandomMatchSave @"/jlwbmk/anchor/random/video/add/twin"

#define kServerPathSignInInfo @"/jlwbau/user/signIn/list/twin"

#define kServerPathSignIn @"/jlwbau/user/signIn/major/twin"

#define kServerPathVipSignIn @"/jlwbau/user/vip/add/diamond/twin"

#define kServerPathVipDaysNum @"/jlwbau/user/vip/days/twin"

#define kServerPathAnchorGiftList @"/jlwbmk/gift/list/anchor/twin"

#define kServerPathMatchRecord @"/jlwbmk/user/card/list/dis/twin"

#define kServerPathCallResult @"/jlwbmk/video/call/time/major/twin"

#define kServerPathFreePhotoResult @"/jlwbau/user/anchor/photo/list/twin"

#define kServerPathCountrysInfo @"/jlwbau/user/countryTabList/twin"

#define kServerPathCountrysInfo @"/jlwbau/user/countryTabList/twin"

#define kServerPathAnchorRecommend @"/jlwbmk/video/recommend/twin"

#define kServerPathGreetListInfo @"/jlwbpb/greet/list/twin"

#define kServerPathGreeting @"/jlwbpb/greet/record/add/twin"

#define kServerPathAnchorCallCancel @"/jlwbmk/video/cancel/twin"

#define kServerPathAnchorCallAccept @"/jlwbmk/video/accept/twin"

#define kServerPathExceptionReport @"/jlwbmk/open-api/rtc/event/twin"

#endif /* DCNetworkHeader_h */

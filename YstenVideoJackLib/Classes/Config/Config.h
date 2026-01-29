//
//  Config.h
//  GoMaster
//
//  Created by percent on 2024/1/26.
//

#import <Foundation/Foundation.h>

#ifndef Config_h
#define Config_h

//#define WeakSelf(type) __weak typeof(type) weak##type = type
//#define StrongSelf(type) __strong typeof(type) strong##type = type

#define JLLog(format, ...) NSLog(@"====Juli Log: %@=====",[NSString stringWithFormat:(format), ##__VA_ARGS__])


//#define kNotificationAccessTokenFailure @"kNotificationAccessTokenFailure"
#define kNotificationVideoCallRefuse  @"kNotificationVideoCallRefuse"
#define kNotificationMessageRecive  @"kNotificationMessageRecive"
#define kNotificationUserInfoUpdate  @"kNotificationUserInfoUpdate"
#define kNotificationUpdateUnreadMessageCount  @"kNotificationUpdateUnreadMessageCount"
#define kNotificationFollowInfoUpdate  @"kNotificationFollowInfoUpdate"
#define kNotificationUserInfoUpdateSuccess  @"kNotificationUserInfoUpdateSuccess"
#define kNotificationFreeCallUsed  @"kNotificationFreeCallUsed"

#define kNotificationVideoAibPush @"kNotificationVideoAibPush"
#define kNotificationVideoAibCancel @"kNotificationVideoAibCancel"

#define kNotificationCheckInInfoUpdate @"kNotificationCheckInInfoUpdate"
#define kNotificationUserLogout @"kNotificationUserLogout"

#define kNotificationUserInitSuccess @"kNotificationUserInitSuccess"





// 回赠礼物(私聊)
#define kNotificationAskGiftSuccess @"kNotificationAskGiftSuccess"

// 回赠礼物(1v1视频)
#define kNotificationVideoViewAskGiftSuccess @"kNotificationVideoViewAskGiftSuccess"

// 更新某条消息状态
#define kNotificationRcMessageUpdateSuccess @"kNotificationRcMessageUpdateSuccess"


// 监听融云消息
#define kNotificationRcMessageSuccess @"kNotificationRcMessageSuccess"


#define Weakself(weakSelf)  __weak __typeof(&*self)weakSelf = self;

    ////屏幕宽度
#define kScreenWidth ([[UIScreen mainScreen]bounds].size.width)
    //屏幕高度
#define kScreenHeight ([[UIScreen mainScreen]bounds].size.height)


    /// 状态栏高度
#define kStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)

    // 状态栏高度大于20（热点被连接时/接电话、微信语音等）
#define STATUS_BAR_BIGGER_THAN_20 ([UIApplication sharedApplication].statusBarFrame.size.height > 20)

    /// 状态栏 + 导航栏 的高度
#define kOldNavigationBar_Height 44
#define kNavigationBar_Height    ( kStatusBarHeight + kOldNavigationBar_Height )



#endif /* Config_h */

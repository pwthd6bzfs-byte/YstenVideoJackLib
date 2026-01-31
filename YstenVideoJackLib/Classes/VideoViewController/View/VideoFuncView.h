//
//  VideoFuncView.h
//  LJChatSDK
//
//  Created by percent on 2026/1/19.
//

#import <UIKit/UIKit.h>
#import "JLAnchorUserModel.h"
#import "CountdownLabel.h"
#import "VideoViewButtomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoFuncView : UIButton

// 主播信息详情
@property (nonatomic, strong) JLAnchorUserModel *anchorUserInfo;

// 频道ID
@property (nonatomic, copy) NSString *channel;

// 倒计时文本
@property (nonatomic, strong) CountdownLabel *countdownLab;

// 输入消息控制器
@property (nonatomic, strong) VideoViewButtomView *videoViewButtomView;

// 是否接收消息
@property (nonatomic, assign) BOOL isGetMeesage;

// 是否属于心动速配
@property (nonatomic, assign) BOOL isHeartMatch;

// 点击退出回调
@property (nonatomic, copy) void(^clickLogoutBlock)();

// 点击蒙层回调
@property (nonatomic, copy) void(^clickMaskViewBlock)();


// 发送文本消息成功回调
@property (nonatomic, copy) void(^sendMessageSuccessBlock)();


// 不再接收IM消息
- (void)noGetImMessage;

- (void)showMask;

- (void)hideMask;



// 设置目标时间为当前时间
- (void)startCountdown;


// 移除定时器
- (void)removeTimer;

@end

NS_ASSUME_NONNULL_END

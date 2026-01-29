//
//  VideoCallView.h
//  LJChatSDK
//
//  Created by percent on 2026/1/15.
//

#import <UIKit/UIKit.h>
#import "VideoCallView.h"
#import "PlayerManager.h"
#import "CachedResourceLoader.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AgoraRtcKit/AgoraRtcKit.h>
#import "JLUserService.h"
#import "JLRTCService.h"
#import "JLRTCService.h"
#import <SVProgressHUD/SVProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoCallView : UIView


@property (nonatomic,copy) void (^clickCameraBlock)(BOOL);

@property (nonatomic,copy) void (^clickMicroPhoneBlock)(BOOL);

@property (nonatomic,copy) void (^clickReverseBlock)(BOOL);

@property (nonatomic,copy) void (^clickCancelBlock)(void);

// 摄像头像开关按钮
@property (nonatomic, strong) UIButton *cameraBtn;
// 麦克风开关按钮
@property (nonatomic, strong) UIButton *microphoneBtn;
// 摄像头反转按钮
@property (nonatomic, strong) UIButton *reverseBtn;
// 通话每分钟金币
@property (nonatomic, strong) UILabel *priceLab;
// 主播信息详情
@property (nonatomic, strong) JLAnchorUserModel *anchorUserInfo;

- (void)clickCameraBtnEvnet;

- (void)clickMicrophoneBtnEvnet;

- (void)clickReverseBtnEvnet;

@end

NS_ASSUME_NONNULL_END

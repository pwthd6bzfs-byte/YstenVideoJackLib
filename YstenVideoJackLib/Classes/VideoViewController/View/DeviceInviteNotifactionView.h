//
//  DeviceInviteNotifaction.h
//  YstenVideoJackLib
//
//  Created by percent on 2026/2/3.
//

#import <UIKit/UIKit.h>
#import "JLUserService.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInviteNotifactionView : UIImageView


    // 点击关闭邀请视图回调
@property (nonatomic, copy) void(^clickCloseBlock)(void);

    // 点击接收邀请视图回调
@property (nonatomic, copy) void(^clickReceiveBlock)(void);


    // 主播信息详情
@property (nonatomic, strong) JLAnchorUserModel *anchorUserInfo;

- (void)show;

- (void)hide;


@end

NS_ASSUME_NONNULL_END

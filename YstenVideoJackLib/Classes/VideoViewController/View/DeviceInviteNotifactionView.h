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
@property (nonatomic, copy) void(^clickCloseBlock)();


- (void)show:(JLAnchorUserModel *)anchorUserInfo;

- (void)hide;


@end

NS_ASSUME_NONNULL_END

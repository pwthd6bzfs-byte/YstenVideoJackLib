//
//  CountdownLabel.h
//  LJChatSDK
//
//  Created by percent on 2026/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountdownLabel : UILabel

    /// 开始倒计时，目标时间是targetDate（一个未来的时间）
- (void)startCountdown;

    /// 停止倒计时
- (void)stopCountdown;

@end

NS_ASSUME_NONNULL_END

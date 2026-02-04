//
//  JLMoreViewComponent.h
//  LJChatSDK
//
//  Created by percent on 2026/1/20.
//

#import <UIKit/UIKit.h>
#import "JLDiviceVideoView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JLDviceVideoViewComponent : UIView


+ (JLDiviceVideoView *)initDeviceList:(NSArray *)DeviceList WitCliclStarVideoBtnBlock:(void(^)(void))starVideoBtnBlock;


@end

NS_ASSUME_NONNULL_END

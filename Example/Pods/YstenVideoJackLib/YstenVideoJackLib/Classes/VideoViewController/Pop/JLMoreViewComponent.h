//
//  JLMoreViewComponent.h
//  LJChatSDK
//
//  Created by percent on 2026/1/20.
//

#import <UIKit/UIKit.h>
#import "JLMoreView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JLMoreViewComponent : UIView


+ (JLMoreView *)initWithCamera:(BOOL)isCamera microphone:(BOOL)isMicrophone ClickSelectCameraBlock:(void(^)())cameraClock clickSelectMicroPhoneBlock:(void(^)())microPhoneBlock;

@end

NS_ASSUME_NONNULL_END

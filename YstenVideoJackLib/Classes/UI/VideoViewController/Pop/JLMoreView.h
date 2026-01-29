//
//  JLMoreView.h
//  LJChatSDK
//
//  Created by percent on 2026/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLMoreView : UIButton


- (instancetype)initWithCamera:(BOOL)isCamera microphone:(BOOL)isMicrophone ClickSelectCameraBlock:(void(^)())cameraClock clickSelectMicroPhoneBlock:(void(^)())microPhoneBlock;

- (void)show;

- (void)hide;


@end

NS_ASSUME_NONNULL_END

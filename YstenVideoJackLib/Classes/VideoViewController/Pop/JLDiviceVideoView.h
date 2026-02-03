//
//  JLMoreView.h
//  LJChatSDK
//
//  Created by percent on 2026/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLDiviceVideoView : UIButton


- (instancetype)initWitCliclStarVideoBtnBlock:(void(^)(void))starVideoBtnBlock;

- (void)show;

- (void)hide;


@end

NS_ASSUME_NONNULL_END

//
//  RemoteView.h
//  LJChatSDK
//
//  Created by percent on 2026/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemoteView : UIView

@property (nonatomic, strong) UIView *contentView;


- (void)startHeadView;

- (void)stopHeadView;


@end

NS_ASSUME_NONNULL_END

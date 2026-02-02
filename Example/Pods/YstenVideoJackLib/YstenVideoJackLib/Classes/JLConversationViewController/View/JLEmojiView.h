//
//  JLEmojiView.h
//  LJChatSDK
//
//  Created by percent on 2026/1/9.
//

#import <UIKit/UIKit.h>
#import "YYLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLEmojiView : UIView

@property (nonatomic,copy) void (^clickSelectEmojiBlock)(NSString *);

@property (nonatomic,copy) void (^clickDelEmojiBlock)(void);

@end

NS_ASSUME_NONNULL_END



NS_ASSUME_NONNULL_BEGIN

@interface JLEmojiViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *emojiLabel;

@end

NS_ASSUME_NONNULL_END

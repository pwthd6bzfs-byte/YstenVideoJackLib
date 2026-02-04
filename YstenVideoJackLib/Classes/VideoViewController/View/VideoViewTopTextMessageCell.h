//
//  VideoViewTopTextMessageCell.h
//  YstenVideoJackLib
//
//  Created by percent on 2026/2/3.
//

#import <UIKit/UIKit.h>
#import "RongIMKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoViewTopTextMessageCell : UITableViewCell

@property (nonatomic, strong) RCMessage *message;

@property (nonatomic, copy) void(^clickRemoteBtnBlock)(void);

@end

NS_ASSUME_NONNULL_END

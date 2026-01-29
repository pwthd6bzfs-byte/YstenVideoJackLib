//
//  JLFollowCell.h
//  LJChatSDK
//
//  Created by percent on 2026/1/26.
//

#import <UIKit/UIKit.h>
#import "JLFollowListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JLFollowCell : UITableViewCell


@property (nonatomic, strong) JLFollowModel *model;

@property (nonatomic, copy) void(^clickFollowBtnBlock)(void);


@end

NS_ASSUME_NONNULL_END

//
//  JLFansCell.h
//  LJChatSDK
//
//  Created by percent on 2026/1/26.
//

#import <UIKit/UIKit.h>
#import "JLFansListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JLFansCell : UITableViewCell

@property (nonatomic, strong) JLFansModel *model;

@property (nonatomic, copy) void(^clickFansBtnBlock)(BOOL,NSString *);

@end

NS_ASSUME_NONNULL_END

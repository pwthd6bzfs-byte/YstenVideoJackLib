//
//  JLMoreView.h
//  LJChatSDK
//
//  Created by percent on 2026/1/20.
//

#import <UIKit/UIKit.h>
#import "JLUserService.h"
#import "JLDeviceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JLDiviceVideoView : UIButton


- (instancetype)initDeviceList:(NSArray *)DeviceList WitCliclStarVideoBtnBlock:(void(^)(void))starVideoBtnBlock;

- (void)show;

- (void)hide;


@end




@interface JLDeviceCell : UITableViewCell

@property (nonatomic, strong) UIView *vline;

@property (nonatomic, strong) JLDeviceModel *model;

@end


NS_ASSUME_NONNULL_END

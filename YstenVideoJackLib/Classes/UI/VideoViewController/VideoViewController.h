//
//  VideoViewController.h
//  JuliFrameworkDemo
//
//  Created by percent on 2025/4/1.
//

#import <UIKit/UIKit.h>
#import "JLAnchorUserModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VideoViewController : UIViewController

@property (nonatomic, assign) BOOL isNeedPush;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSInteger anchorID;
@property (nonatomic, copy) NSString *anchorRtcToken;
@property (nonatomic, assign) BOOL isHeartMatch; // 是否属于心动速配
    /// 主播信息详情
@property (nonatomic, strong) JLAnchorUserModel *anchorUserInfo;

@end

NS_ASSUME_NONNULL_END

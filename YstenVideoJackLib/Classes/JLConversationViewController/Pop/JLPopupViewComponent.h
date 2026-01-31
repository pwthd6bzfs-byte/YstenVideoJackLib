//
//  JLPopupViewComponent.h
//  LJChatSDK
//
//  Created by percent on 2026/1/12.
//

#import <Foundation/Foundation.h>
#import "JLGiftListView.h"
#import "JLPrivatePhotoView.h"
#import "JLPrivateVideoView.h"
#import "RCMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JLPopupViewComponent : NSObject


    /// 礼物弹窗
+ (JLGiftListView *)popupTableiViewWithModel:(JLGiftListModel *)model returnModel:(void(^)(JLGiftModel *model,NSString *count))block;



    /// 解锁照片弹窗
+ (JLPrivatePhotoView *)initPhotoWithModel:(RCMessageModel *)model;



    /// 解锁视频弹窗
+ (JLPrivateVideoView *)initVideoWithModel:(RCMessageModel *)model rootViewController:(UIViewController *)vc;


@end

NS_ASSUME_NONNULL_END

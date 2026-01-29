//
//  JLPopupViewComponent.m
//  LJChatSDK
//
//  Created by percent on 2026/1/12.
//

#import "JLPopupViewComponent.h"
#import <Masonry/Masonry.h>
#import "Config.h"
#import "RCMessageModel.h"

@implementation JLPopupViewComponent


+ (JLGiftListView *)popupTableiViewWithModel:(JLGiftListModel *)model returnModel:(void(^)(JLGiftModel *model,NSString *count))block{
    JLGiftListView *view = [[JLGiftListView alloc] initWithModel:model returnModel:block];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(window);
        make.size.mas_offset(CGSizeMake(kScreenWidth, kScreenHeight));
    }];
    
    [view show];
    return view;
}






+ (JLPrivatePhotoView *)initPhotoWithModel:(RCMessageModel *)model{
    JLPrivatePhotoView *view = [[JLPrivatePhotoView alloc] initWithModel:model];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(window);
        make.size.mas_offset(CGSizeMake(kScreenWidth, kScreenHeight));
    }];
    
    [view show];
    return view;
}




+ (JLPrivateVideoView *)initVideoWithModel:(RCMessageModel *)model rootViewController:(UIViewController *)vc{
    JLPrivateVideoView *view = [[JLPrivateVideoView alloc] initWithModel:model];
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [vc.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(vc.view);
        make.size.mas_offset(CGSizeMake(kScreenWidth, kScreenHeight));
    }];
    
    [view show];
    return view;
}


@end

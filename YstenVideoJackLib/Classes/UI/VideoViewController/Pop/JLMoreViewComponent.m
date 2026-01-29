//
//  JLMoreViewComponent.m
//  LJChatSDK
//
//  Created by percent on 2026/1/20.
//

#import "JLMoreViewComponent.h"
#import <Masonry/Masonry.h>
#import "config.h"

@implementation JLMoreViewComponent

+ (JLMoreView *)initWithCamera:(BOOL)isCamera microphone:(BOOL)isMicrophone ClickSelectCameraBlock:(void(^)())cameraClock clickSelectMicroPhoneBlock:(void(^)())microPhoneBlock{
    JLMoreView *view = [[JLMoreView alloc] initWithCamera:isCamera microphone:isMicrophone ClickSelectCameraBlock:cameraClock clickSelectMicroPhoneBlock:microPhoneBlock];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(window);
        make.size.mas_offset(CGSizeMake(kScreenWidth, kScreenHeight));
    }];
    
    [view show];
    return view;
}

@end
    

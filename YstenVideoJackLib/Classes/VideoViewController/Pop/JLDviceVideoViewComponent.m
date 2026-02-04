//
//  JLMoreViewComponent.m
//  LJChatSDK
//
//  Created by percent on 2026/1/20.
//

#import "JLDviceVideoViewComponent.h"
#import <Masonry/Masonry.h>
#import "JLUserService.h"
#import "Config.h"

@implementation JLDviceVideoViewComponent

+ (JLDiviceVideoView *)initDeviceList:(NSArray *)DeviceList WitCliclStarVideoBtnBlock:(void(^)(void))starVideoBtnBlock{
    JLDiviceVideoView *view = [[JLDiviceVideoView alloc] initDeviceList:DeviceList WitCliclStarVideoBtnBlock:starVideoBtnBlock];
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
    

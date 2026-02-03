    //
    //  JLGiftListView.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/12.
    //

#import "JLDiviceVideoView.h"
#import "Config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JLUserService.h"
#import "UIImage+Add.h"

@interface JLDiviceVideoView()
/// 视图容器
@property (nonatomic, strong) UIView *vContainer;

    /// 点击开始视频回调方法
@property (nonatomic, copy) void(^cliclStarVideoBtnBlock)(void);


@end

@implementation JLDiviceVideoView


- (instancetype)initWitCliclStarVideoBtnBlock:(void(^)(void))starVideoBtnBlock{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
        self.cliclStarVideoBtnBlock = starVideoBtnBlock;
        [self setup];
    }
    return self;
}


- (void)setup{
    
//    [self addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *vContainer = [[UIView alloc] init];
    vContainer.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.9];
    vContainer.layer.cornerRadius = 16;
    self.vContainer = vContainer;
    [self addSubview:vContainer];
    Weakself(ws)
    [vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(234));
        make.width.equalTo(@(285));
        make.center.equalTo(ws);
    }];
    
    
    
    UILabel *labTitle = [[UILabel alloc] init];
    labTitle.text = @"Unlock toy fun together";
    labTitle.textColor = [UIColor colorWithHexString:@"#000000"];
    labTitle.font = [UIFont systemFontOfSize:16];
    [vContainer addSubview:labTitle];

    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage jl_name:@"jl_close_gray" class:self] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseEvent) forControlEvents:UIControlEventTouchUpInside];
    [vContainer addSubview:closeBtn];

    
    UIView *viewContainer = [[UIView alloc] init];
    viewContainer.backgroundColor = [UIColor whiteColor];
    viewContainer.layer.cornerRadius = 16;
    viewContainer.layer.masksToBounds = YES;
    [vContainer addSubview:viewContainer];

    
    UIImageView *imgIcon = [[UIImageView alloc] init];
//    imgIcon.image = [UIImage jl_name:@"" class:self];
    imgIcon.backgroundColor = [UIColor redColor];
    imgIcon.contentMode = UIViewContentModeScaleAspectFill;
    [vContainer addSubview:imgIcon];

    
    UILabel *labVibratorTitle = [[UILabel alloc] init];
    labVibratorTitle.text = @"Vibrator";
    labVibratorTitle.textColor = [UIColor blackColor];
    labVibratorTitle.font = [UIFont systemFontOfSize:14];
    [vContainer addSubview:labVibratorTitle];

    
    
    
    UILabel *labMark = [[UILabel alloc] init];
    labMark.text = @"I have prepared the toy and want to\n experience it with you. Start a video now~";
    labMark.textColor = [UIColor colorWithHexString:@"#888888"];
    labMark.font = [UIFont systemFontOfSize:12];
    labMark.numberOfLines = 2;
    [vContainer addSubview:labMark];
    
    
    
    UIButton *starVideoBtn = [[UIButton alloc] init];
    [starVideoBtn setTitle:@"Star Video" forState:UIControlStateNormal];
    [starVideoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    starVideoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    starVideoBtn.layer.cornerRadius = 24;
    starVideoBtn.backgroundColor = [UIColor colorWithHexString:@"#FE006B"];
    [starVideoBtn addTarget:self action:@selector(cliclStarVideoBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
    [vContainer addSubview:starVideoBtn];

    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.vContainer).offset(16);
        make.centerX.equalTo(ws.vContainer);
    }];
    
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labTitle);
        make.right.equalTo(vContainer).offset(-10);
        make.size.mas_offset(CGSizeMake(24, 24));
    }];

    
    [viewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle.mas_bottom).offset(14);
        make.left.equalTo(ws.vContainer).offset(17);
        make.right.equalTo(ws.vContainer).offset(-17);
        make.height.equalTo(@48);
    }];

    
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewContainer);
        make.left.equalTo(viewContainer).offset(10);
        make.size.mas_offset(CGSizeMake(28, 28));
    }];

    
    [labVibratorTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewContainer);
        make.left.equalTo(imgIcon.mas_right).offset(10);
    }];
    
    
    [labMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vContainer);
        make.top.equalTo(viewContainer.mas_bottom).offset(19);
    }];
    
    
    [starVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labMark.mas_bottom).offset(17);
        make.centerX.equalTo(vContainer);
        make.size.mas_offset(CGSizeMake(241, 48));
    }];

}



- (void)cliclStarVideoBtnEvnet{
    [self hide];
    if (self.cliclStarVideoBtnBlock) {
        self.cliclStarVideoBtnBlock();
    }
}



- (void)clickCloseEvent{
    [self hide];
}



- (void)show{
    Weakself(ws)
    [self layoutIfNeeded];
    [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(234));
        make.width.equalTo(@(285));
        make.center.equalTo(ws);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        [self layoutIfNeeded];
    }];
}



- (void)hide{
    Weakself(ws)
//    [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(@(0));
//        make.top.equalTo(ws.mas_bottom);
//        make.height.equalTo(@(175));
//    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end



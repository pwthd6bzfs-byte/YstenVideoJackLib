    //
    //  JLGiftListView.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/12.
    //

#import "JLMoreView.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JLUserService.h"
#import "UIImage+Add.h"

@interface JLMoreView()
/// 视图容器
@property (nonatomic, strong) UIView *vContainer;

/// 相机视图
@property (nonatomic, strong) UIView *vCameraContainer;

/// 麦克风视图
@property (nonatomic, strong) UIView *vMicroContainer;

/// 选择相机回调方法
@property (nonatomic, copy) void(^clickSelectCameraBlock)();

/// 选择没麦克风回调方法
@property (nonatomic, copy) void(^clickSelectMicroPhoneBlock)();


@property (nonatomic, assign) BOOL isCamera;
@property (nonatomic, assign) BOOL isMicrophone;

@end

@implementation JLMoreView


- (instancetype)initWithCamera:(BOOL)isCamera microphone:(BOOL)isMicrophone ClickSelectCameraBlock:(void(^)())cameraClock clickSelectMicroPhoneBlock:(void(^)())microPhoneBlock{
    self = [super init];
    if (self) {
        self.isCamera = isCamera;
        self.isMicrophone = isMicrophone;
        self.clickSelectCameraBlock = cameraClock;
        self.clickSelectMicroPhoneBlock = microPhoneBlock;
        [self setup];
    }
    return self;
}


- (void)setup{
    
    [self addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *vContainer = [[UIView alloc] init];
    vContainer.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    vContainer.layer.cornerRadius = 10;
    self.vContainer = vContainer;
    [self addSubview:vContainer];
    Weakself(ws)
    [vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(175));
        make.left.right.equalTo(@(0));
        make.top.equalTo(ws.mas_bottom);
    }];
    
    
    
    UIView *vCameraContainer = [[UIView alloc] init];
    vCameraContainer.backgroundColor = [UIColor whiteColor];
    vCameraContainer.layer.cornerRadius = 16;
    self.vCameraContainer = vCameraContainer;
    [self.vContainer addSubview:vCameraContainer];
    
    
    UIImageView *imgCamera = [[UIImageView alloc] init];
    imgCamera.image = [UIImage jl_name:@"jl_camera_video" class:self];
    imgCamera.contentMode = UIViewContentModeScaleAspectFill;
    [self.vCameraContainer addSubview:imgCamera];

    
    UILabel *labCameraTitle = [[UILabel alloc] init];
    labCameraTitle.text = @"Camera";
    labCameraTitle.textColor = [UIColor blackColor];
    labCameraTitle.font = [UIFont systemFontOfSize:14];
    [self.vCameraContainer addSubview:labCameraTitle];
    
    
    UIButton *swcCamera = [[UIButton alloc] init];
    swcCamera.selected = self.isCamera;
    [swcCamera setImage:[UIImage jl_name:@"jl_switch_on" class:self] forState:UIControlStateNormal];
    [swcCamera setImage:[UIImage jl_name:@"jl_switch_off" class:self] forState:UIControlStateSelected];
    [swcCamera addTarget:self action:@selector(clickCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.vCameraContainer addSubview:swcCamera];

    
    [vCameraContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(ws.vContainer).offset(16);
        make.right.equalTo(ws.vContainer).offset(-16);
        make.height.equalTo(@56);
    }];
    
    
    [imgCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vCameraContainer);
        make.left.equalTo(ws.vCameraContainer).offset(16);
        make.size.mas_offset(CGSizeMake(32, 32));
    }];

    
    [labCameraTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vCameraContainer);
        make.left.equalTo(imgCamera.mas_right).offset(8);
    }];

    
    [swcCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vCameraContainer);
        make.right.equalTo(ws.vCameraContainer).offset(-16);
        make.size.mas_offset(CGSizeMake(40, 24));
    }];

    

    
    UIView *vMicroContainer = [[UIView alloc] init];
    vMicroContainer.backgroundColor = [UIColor whiteColor];
    vMicroContainer.layer.cornerRadius = 16;
    self.vMicroContainer = vMicroContainer;
    [self.vContainer addSubview:vMicroContainer];
    
    
    UIImageView *imgMicro = [[UIImageView alloc] init];
    imgMicro.image = [UIImage jl_name:@"jl_microphone_video" class:self];
    imgMicro.contentMode = UIViewContentModeScaleAspectFill;
    [self.vMicroContainer addSubview:imgMicro];
    
    
    UILabel *labMicroTitle = [[UILabel alloc] init];
    labMicroTitle.text = @"Microphone";
    labMicroTitle.textColor = [UIColor blackColor];
    labMicroTitle.font = [UIFont systemFontOfSize:14];
    [self.vMicroContainer addSubview:labMicroTitle];
    
    
    UIButton *swcMicro = [[UIButton alloc] init];
    swcMicro.selected = self.isMicrophone;
    [swcMicro setImage:[UIImage jl_name:@"jl_switch_on" class:self] forState:UIControlStateNormal];
    [swcMicro setImage:[UIImage jl_name:@"jl_switch_off" class:self] forState:UIControlStateSelected];
    [swcMicro addTarget:self action:@selector(clickMicrophone) forControlEvents:UIControlEventTouchUpInside];
    [self.vMicroContainer addSubview:swcMicro];
    
    
    [vMicroContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.vCameraContainer.mas_bottom).offset(12);
        make.left.equalTo(ws.vContainer).offset(16);
        make.right.equalTo(ws.vContainer).offset(-16);
        make.height.equalTo(@56);
    }];
    
    
    [imgMicro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vMicroContainer);
        make.left.equalTo(ws.vMicroContainer).offset(16);
        make.size.mas_offset(CGSizeMake(32, 32));
    }];
    
    
    [labMicroTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vMicroContainer);
        make.left.equalTo(imgMicro.mas_right).offset(8);
    }];
    
    
    [swcMicro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(vMicroContainer);
        make.right.equalTo(ws.vMicroContainer).offset(-16);
        make.size.mas_offset(CGSizeMake(40, 24));
    }];

    
}



- (void)clickCamera{
    if (self.clickSelectCameraBlock) {
        self.clickSelectCameraBlock();
    }
}



- (void)clickMicrophone{
    if (self.clickSelectMicroPhoneBlock) {
        self.clickSelectMicroPhoneBlock();
    }
}



- (void)show{
    Weakself(ws)
    [self layoutIfNeeded];
    [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws);
        make.left.right.equalTo(@(0));
        make.height.equalTo(@(175));
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        [self layoutIfNeeded];
    }];
}



- (void)hide{
    Weakself(ws)
    [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(ws.mas_bottom);
        make.height.equalTo(@(175));
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end



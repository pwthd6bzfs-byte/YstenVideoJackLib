//
//  VideoCallView.m
//  LJChatSDK
//
//  Created by percent on 2026/1/15.
//

#import "VideoCallView.h"
#import "PlayerManager.h"
#import "CachedResourceLoader.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AgoraRtcKit/AgoraRtcKit.h>
#import "JLUserService.h"
#import "JLRTCService.h"
#import "JLRTCService.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIImage+Add.h"

@interface VideoCallView ()

// 视频视图
@property (nonatomic, strong) CachedResourceLoader *resourceLoader;
// 背景图
@property (nonatomic, strong) UIImageView *bgImageView;
// 分钟提示语
@property (nonatomic, strong) UILabel *minuteLab;
// 金币图
@property (nonatomic, strong) UIImageView *coinImageView;
// 消耗金币提示语
@property (nonatomic, strong) UILabel *explainLab;
// 取消通话按钮
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation VideoCallView


- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
           
           
- (void)initialize{
    
    
    [self addSubview:self.bgImageView];
//    [self addSubview:self.vMask];
    [self addSubview:self.priceLab];
    [self addSubview:self.coinImageView];
    [self addSubview:self.minuteLab];
    [self addSubview:self.priceLab];
    [self addSubview:self.explainLab];
    [self addSubview:self.cameraBtn];
    [self addSubview:self.microphoneBtn];
    [self addSubview:self.reverseBtn];
    [self addSubview:self.cancelBtn];

    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
        
    
//    [self.vMask mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.bgImageView);
//    }];

    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coinImageView);
        make.right.equalTo(self.coinImageView.mas_left).offset(-5);
    }];
    
    
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    
    [self.minuteLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coinImageView);
        make.left.equalTo(self.coinImageView.mas_right).offset(5);
    }];

    
    [self.explainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.priceLab.mas_bottom).offset(10);
    }];
    
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.microphoneBtn);
        make.left.equalTo(self).offset(48);
        make.size.mas_offset(CGSizeMake(60, 60));
        make.bottom.equalTo(self.microphoneBtn);
    }];

    
    [self.microphoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(60, 60));
        make.bottom.equalTo(self.cancelBtn.mas_top).offset(-40);
    }];

    
    [self.reverseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-48);
        make.centerY.equalTo(self.microphoneBtn);
        make.size.mas_offset(CGSizeMake(60, 60));
        make.bottom.equalTo(self.microphoneBtn);

    }];

    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(60, 60));
        make.bottom.equalTo(self).offset(-87);
    }];
    
    


    // 默认前置摄像头
    AgoraCameraCapturerConfiguration *config = [[AgoraCameraCapturerConfiguration alloc] init];
    config.cameraDirection = AgoraCameraDirectionFront;
    [[JLRTCService shared].agoraKit setCameraCapturerConfiguration:config];
    
    
        // 创建UIBlurEffect对象，使用UIBlurEffectStyleLight样式
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        // 创建UIVisualEffectView对象，并初始化其effect为blurEffect
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

        // 设置blurEffectView的frame，使其覆盖整个背景图片
    blurEffectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    blurEffectView.alpha = 0.8;
    
        // 将blurEffectView添加到背景图片上
    [self.bgImageView addSubview:blurEffectView];
}




- (void)setAnchorUserInfo:(JLAnchorUserModel *)anchorUserInfo{
    _anchorUserInfo = anchorUserInfo;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:anchorUserInfo.headFileName]];
    
    [self setupPlayerWithCacheManager];
}


- (void)setupPlayerWithCacheManager {
    if (!self.anchorUserInfo.showVideoUrl) {
        return;
    }
    
    NSURL *videoURL = [NSURL URLWithString:self.anchorUserInfo.showVideoUrl];
    // 方法2: 使用自定义ResourceLoader实现缓存
    NSURL *originalURL = [NSURL URLWithString:videoURL.absoluteString];
    
        // 创建自定义scheme的URL
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:originalURL resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    
        // 创建ResourceLoader
    self.resourceLoader = [[CachedResourceLoader alloc] initWithURL:originalURL];
    
        // 创建AVURLAsset
    AVURLAsset *asset = [AVURLAsset assetWithURL:components.URL];
    [asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
    
        // 创建PlayerItem
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    player.volume = NO;

    
    // 循环播放
    [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:playerItem // 监听这个播放项
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
            // 视频播完时，系统会自动调用这个Block
        [player seekToTime:kCMTimeZero]; // 1. 跳转到时间零点（即开头）
        [player play]; // 2. 重新开始播放
    }];

    
        // 创建PlayerLayer
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; // 填满，可能裁剪
    [self.bgImageView.layer addSublayer:playerLayer];
    
    [player play];
}




- (void)clickCameraBtnEvnet{
    [self clickCameraBtnEvnet:self.cameraBtn];
}


- (void)clickCameraBtnEvnet:(UIButton *)sender{
        
    // 摄像头是否打开
    sender.selected = !sender.isSelected; // 更新按钮状态
    // 根据按钮状态开关摄像头
    [[JLRTCService shared].agoraKit enableLocalVideo:!sender.isSelected];
        // 通常也需要同时停止/开始本地预览
    if (sender.isSelected) {
        [[JLRTCService shared].agoraKit stopPreview];
    } else {
        [[JLRTCService shared].agoraKit startPreview];
    }

    if (self.clickCameraBlock) {
        self.clickCameraBlock(sender.selected);
    }
}


- (void)clickMicrophoneBtnEvnet{
    [self clickMicrophoneBtnEvnet:self.microphoneBtn];
}


- (void)clickMicrophoneBtnEvnet:(UIButton *)sender{
    sender.selected = !sender.isSelected; // 更新按钮状态
    if (sender.isSelected) {
        [[JLRTCService shared].agoraKit muteLocalAudioStream:YES];
    } else {
        [[JLRTCService shared].agoraKit muteLocalAudioStream:NO];
    }

    
    if (self.clickMicroPhoneBlock) {
        self.clickMicroPhoneBlock(sender.selected);
    }
}



- (void)clickReverseBtnEvnet{
    [self clickReverseBtnEvnet:self.reverseBtn];
}



- (void)clickReverseBtnEvnet:(UIButton *)sender{
    
    if (self.cameraBtn.selected == YES) {
        [SVProgressHUD showImage:nil status:@"The current camera is closed please open the camera first"];
        return;
    }
    
    sender.selected = !sender.isSelected; // 更新按钮状态
    
    // 前后置摄像头切换
    [[JLRTCService shared].agoraKit switchCamera];
    
    if (self.clickReverseBlock) {
        self.clickReverseBlock(sender.selected);
    }
}






- (void)clickCancelBtnEvnet{
    if (self.clickCancelBlock) {
        self.clickCancelBlock();
    }
}



//- (UIView *)vMask{
//    if (!_vMask) {
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
//        
//        _vMask = view;
//    }
//    return  _vMask;
//}



- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.backgroundColor = [UIColor blackColor];
        _bgImageView = view;
    }
    return  _bgImageView;
}



- (UILabel *)priceLab{
    if (!_priceLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor whiteColor];
        view.text = @"0 ";
        view.font = [UIFont systemFontOfSize:16];
        view.textAlignment = UITextAlignmentCenter;
        _priceLab = view;
    }
    return  _priceLab;
}



- (UILabel *)minuteLab{
    if (!_minuteLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor whiteColor];
        view.text = @"/Min";
        view.font = [UIFont systemFontOfSize:16];
        view.textAlignment = UITextAlignmentCenter;
        _minuteLab = view;
    }
    return  _minuteLab;
}


- (UIImageView *)coinImageView{
    if (!_coinImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage jl_name:@"jl_coin" class:self];
        view.contentMode = UIViewContentModeScaleAspectFill;
        _coinImageView = view;
    }
    return  _coinImageView;
}





- (UILabel *)explainLab{
    if (!_explainLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5];
        view.text = @"Billing begins after the other party accepts; any time less than 1 minute will be billed as 1 minute.";
        view.font = [UIFont systemFontOfSize:14];
        view.textAlignment = UITextAlignmentCenter;
        _explainLab = view;
    }
    return  _explainLab;
}



- (UIButton *)cameraBtn{
    if (!_cameraBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setImage:[UIImage jl_name:@"jl_camera" class:self] forState:UIControlStateNormal];
        [view setImage:[UIImage jl_name:@"jl_camera_no" class:self] forState:UIControlStateSelected];
        [view addTarget:self action:@selector(clickCameraBtnEvnet:) forControlEvents:UIControlEventTouchUpInside];
        _cameraBtn = view;
    }
    return  _cameraBtn;
}



- (UIButton *)microphoneBtn{
    if (!_microphoneBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setImage:[UIImage jl_name:@"jl_microphone" class:self] forState:UIControlStateNormal];
        [view setImage:[UIImage jl_name:@"jl_microphone_no" class:self] forState:UIControlStateSelected];
        [view addTarget:self action:@selector(clickMicrophoneBtnEvnet:) forControlEvents:UIControlEventTouchUpInside];
        _microphoneBtn = view;
    }
    return  _microphoneBtn;
}



- (UIButton *)reverseBtn{
    if (!_reverseBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setImage:[UIImage jl_name:@"jl_reverse" class:self] forState:UIControlStateNormal];
        [view setImage:[UIImage jl_name:@"jl_reverse_no" class:self] forState:UIControlStateSelected];
        [view addTarget:self action:@selector(clickReverseBtnEvnet:) forControlEvents:UIControlEventTouchUpInside];
        _reverseBtn = view;
    }
    return  _reverseBtn;
}



- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setImage:[UIImage jl_name:@"jl_call_cancel" class:self] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(clickCancelBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn = view;
    }
    return  _cancelBtn;
}



           
           
@end

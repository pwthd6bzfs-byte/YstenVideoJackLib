    //
    //  JLPrivatePhotoView.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/27.
    //

#import "JLPrivateVideoView.h"
#import "RCMessageModel.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "JLUserService.h"
#import "NSObject+CurrentViewController.h"
#import "JLIMService.h"
#import "JLAPIService.h"
#import "UIImage+Add.h"

@interface JLPrivateVideoView()
    /// 背景图片视图
@property (nonatomic, strong) UIView *bgImage;

@property (nonatomic, strong) UIVisualEffectView *blurEffectView;

    /// 视图容器
@property (nonatomic, strong) UIView *vContainer;


@property (nonatomic, strong) RCMessageModel *model;

@property (nonatomic, strong) JLMediaPrivateMessage *message;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, assign) BOOL isCheckVideo;


@end

@implementation JLPrivateVideoView


- (instancetype)initWithModel:(RCMessageModel *)model{
    self = [super init];
    if (self) {
        self.model = model;
        JLMediaPrivateMessage *message = (JLMediaPrivateMessage *)model.content;
        [self setupModel:message];
    }
    return self;
}


- (void)setupModel:(JLMediaPrivateMessage *)message{
    
    self.message = message;
    
    
    
        //    [self addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *bgImage = [[UIImageView alloc] init];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    [bgImage sd_setImageWithURL:[NSURL URLWithString:message.firstFrameImageUrl]];
    self.bgImage = bgImage;
    [self addSubview:bgImage];
    
    
        // 播放按钮
    UIButton *playBtn = [[UIButton alloc] init];
    [playBtn setImage:[UIImage jl_name:@"jl_play" class:self] forState:UIControlStateNormal];
    playBtn.backgroundColor = [UIColor clearColor];
    [playBtn addTarget:self action:@selector(clickPlayBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
    playBtn.userInteractionEnabled = NO;
    self.playBtn = playBtn;
    [self addSubview:playBtn];

    
    
        // 备注
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage jl_name:@"jl_navBackBlackIcon" class:self] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]; // 可选: Light, Dark, ExtraLight等
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.blurEffectView = effectView;
    [bgImage addSubview:effectView];
    
    
    
    
    UIView *vContainer = [[UIView alloc] init];
    vContainer.backgroundColor = [UIColor whiteColor];
    vContainer.layer.cornerRadius = 10;
    self.vContainer = vContainer;
    [self addSubview:vContainer];
    
    
    
        // 备注
    UIButton *markBtn = [[UIButton alloc] init];
    [markBtn setImage:[UIImage jl_name:@"jl_mark" class:self] forState:UIControlStateNormal];
    [markBtn addTarget:self action:@selector(clickMarkBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
    [vContainer addSubview:markBtn];
    
    
    
        // 礼物
    UIImageView *giftImage = [[UIImageView alloc] init];
    giftImage.contentMode = UIViewContentModeScaleAspectFit;
    [giftImage sd_setImageWithURL:[NSURL URLWithString:message.giftUrl]];
    [vContainer addSubview:giftImage];
    
    
    
        // 名称
    UILabel *labTitle = [[UILabel alloc] init];
    labTitle.text = message.giftName;
    labTitle.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    labTitle.font = [UIFont systemFontOfSize:14];
    [vContainer addSubview:labTitle];
    
    
    
    
        // 金币
    UILabel *labCoin = [[UILabel alloc] init];
    labCoin.text = [NSString stringWithFormat:@"%ld",message.giftPrice];
    labCoin.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
    labCoin.font = [UIFont systemFontOfSize:14];
    [vContainer addSubview:labCoin];
    
    
    
        // 金币图
    UIImageView *iconView = [[UIImageView alloc] init];
    giftImage.contentMode = UIViewContentModeScaleAspectFit;
    iconView.image = [UIImage jl_name:@"jl_coin" class:self];
    [vContainer addSubview:iconView];
    
    
    
    UIButton *unlockBtn = [[UIButton alloc] init];
    [unlockBtn setTitle:@"UNLOCK WITH GIFT" forState:UIControlStateNormal];
    [unlockBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    unlockBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    unlockBtn.backgroundColor = [UIColor colorWithHexString:@"#FE006B"];
    unlockBtn.layer.cornerRadius = 8;
    unlockBtn.layer.masksToBounds = YES;
    [unlockBtn addTarget:self action:@selector(clickUnlockBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
    [vContainer addSubview:unlockBtn];
    
    
    
    
    Weakself(ws)
    [vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(332));
        make.left.right.equalTo(@(0));
        make.top.equalTo(ws.mas_bottom);
    }];
    
    
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kStatusBarHeight+6);
        make.left.equalTo(self).offset(16);
        make.size.mas_offset(CGSizeMake(32, 32));
    }];
    
    
    
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_offset(CGSizeMake(60, 60));
    }];

    
    [markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vContainer).offset(20);
        make.right.equalTo(vContainer).offset(-20);
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    
    
    
    [giftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(markBtn.mas_bottom).offset(6);
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(80, 80));
    }];
    
    
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(giftImage.mas_bottom).offset(26);
        make.centerX.equalTo(self);
    }];
    
    
    
    [labCoin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.centerX.equalTo(self).offset(-13);
    }];
    
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle.mas_bottom).offset(20);
        make.centerX.equalTo(self).offset(13);
    }];
    
    
    
    [unlockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconView.mas_bottom).offset(23);
        make.height.equalTo(@(48));
        make.left.equalTo(vContainer).offset(32);
        make.right.equalTo(vContainer).offset(-32);
    }];
}






    /// 取消当前视图
- (void)clickCloseBtnEvnet{
    if (self.isCheckVideo == YES) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips"
                                                                       message:@"To protect privacy, you cannot view it again after returning to chat"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *goToSettings = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self hide];
        }];
        [alert addAction:goToSettings];
        [alert addAction:cancel];
        [[NSObject currentViewController] presentViewController:alert animated:YES completion:nil];
    }else{
        [self hide];
    }
}





// 点击播放按钮
- (void)clickPlayBtnEvnet{
            // 视频URL，可以是本地或远程
        NSString *videoURLString = self.message.privacyUrl; // 替换为你的视频URL
        NSURL *videoURL = [NSURL URLWithString:videoURLString];
                
            // 创建 AVPlayer 和 AVPlayerViewController
        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
        playerViewController.player = player;
        
            // 设置播放器属性
        playerViewController.showsPlaybackControls = YES;
        playerViewController.exitsFullScreenWhenPlaybackEnds = NO; // 播放结束时退出全屏
        playerViewController.allowsPictureInPicturePlayback = NO; // 允许画中画
        
            // 监听播放结束通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerDidFinishPlaying:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:player.currentItem];
        
    [NSObject currentViewController].modalPresentationStyle = UIModalPresentationOverFullScreen;
            // 弹出播放器
        [[NSObject currentViewController] presentViewController:playerViewController animated:YES completion:^{
            [player play];
        }];
}


- (void)playerDidFinishPlaying:(NSNotification *)notification {
    NSLog(@"播放完成");
    // 可以在这里处理播放完成后的逻辑，比如关闭播放器
}





    // 点击备注
- (void)clickMarkBtnEvnet{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips"
                                                                   message:@"1. You can unlock and view intimate photos/videos shared by others by sending gifts \n2. To protect privacy, intimate photos/videos cannot be saved, screenshotted or recorded. They can only be viewed once after unlocking, and cannot be viewed again after returning to chat"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleCancel handler:nil];
        //    UIAlertAction *goToSettings = [UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //
        //    }];
    [alert addAction:cancel];
        //    [alert addAction:goToSettings];
    [[NSObject currentViewController] presentViewController:alert animated:nil completion:nil];
}




- (void)clickUnlockBtnEvnet{
    Weakself(ws)
    [SVProgressHUD show];
    [JLAPIService getTradePrivacyUnlockWithUnLockId:[NSString stringWithFormat:@"%ld",self.message.unlockId] success:^(NSDictionary * _Nonnull result) {
        NSLog(@"解锁私密成功");
        [SVProgressHUD dismiss];

        
        [self.blurEffectView removeFromSuperview];
        
        self.isCheckVideo = YES;
        self.playBtn.userInteractionEnabled = YES;
        self.vContainer.hidden = YES;
        
        
        [[JLIMService shared] setMessageExtraStatus:@"1" messageId:self.model.messageId callback:^(BOOL result) {
            ws.model.extra = @"1";
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRcMessageUpdateSuccess object:self];
            NSLog(@"解锁私密状态更新成功 (解锁)");
        }];
            //        [JLIMService setMessageExtraStatus]
    } failued:^(NSError * _Nonnull error) {
        NSLog(@"解锁私密失败");
        [SVProgressHUD dismiss];
        if (error.code == 123 || error.code == 124) {
            [SVProgressHUD showImage:nil status:@"The record has expired."];
            [[JLIMService shared] setMessageExtraStatus:@"2" messageId:self.model.messageId callback:^(BOOL result) {
                ws.model.extra = @"2";
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRcMessageUpdateSuccess object:self];
                NSLog(@"解锁私密状态更新成功 (过期)");
            }];
        }
    }];
    
}







- (void)show{
    Weakself(ws)
    [self layoutIfNeeded];
    [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws);
        make.left.right.equalTo(@(0));
        make.height.equalTo(@(332));
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
        make.height.equalTo(@(332));
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

    //
    //  JLGiftMessageCell.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/13.
    //

#import "JLPrivatePhotoMessageCell.h"
#import "JLCustomMessage.h"
#import "JLPopupViewComponent.h"
#import "JLUserService.h"
#import "JLCustomMessage.h"
#import "JLGiftListModel.h"
#import "JLUserService.h"
#import "JLUserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIColor+HexColor.h"
#import <Masonry/Masonry.h>
#import "Config.h"
#import "JLIMService.h"
#import "NSObject+CurrentViewController.h"
#import "UIImage+Add.h"

@interface JLPrivatePhotoMessageCell ()

@property (nonatomic, strong) JLMediaPrivateMessage *message;
@property (nonatomic, strong) UIImageView *vContainer;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *playImageView;
@property (nonatomic, strong) UIView *vImageViewContainer;
@property (nonatomic, strong) UIButton *clickView;

@end

@implementation JLPrivatePhotoMessageCell



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}


- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    
    JLMediaPrivateMessage *message = (JLMediaPrivateMessage *)self.model.content;
    self.message = message;
    
    // 1:照片类型  2:视频类型
    if ([message.type isEqualToString:@"1"]) {
        
        [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.portraitImageView);
            make.left.equalTo(self.contentView).offset(60);
            make.width.equalTo(@130);
            make.bottom.equalTo(self.contentView).offset(-30);
        }];
        
            // 照片
        if ([self.model.extra isEqualToString:@"1"]) {
            [self viewed];
        }else if ([self.model.extra isEqualToString:@"2"]){
            [self expired];
        }else{
            [self unlock];
        }

        self.effectView.frame = CGRectMake(0, 0, 130, 180);
        self.playImageView.hidden = YES;
        self.timeLab.hidden = YES;

        [self.vContainer sd_setImageWithURL:[NSURL URLWithString:message.privacyUrl]];
    }else{
        
        
        [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.portraitImageView);
            make.left.equalTo(self.contentView).offset(60);
            make.width.equalTo(@180);
            make.bottom.equalTo(self.contentView).offset(-30);
        }];
        
        // 视频
        if ([self.model.extra isEqualToString:@"1"]) {
            [self videoViewed];
        }else if ([self.model.extra isEqualToString:@"2"]){
            [self videoExpired];
        }else{
            [self videoUnlock];
        }
        
        
        self.playImageView.hidden = NO;
        self.timeLab.hidden = NO;

        self.effectView.frame = CGRectMake(0, 0, 180, 120);
        
        
            // 将时间差转换为时、分、秒
        NSInteger minutes = (message.duration) / 60;
        NSInteger seconds = (message.duration) % 60;
        
            // 根据需求格式化字符串，这里显示时、分、秒
        NSString *text = [NSString stringWithFormat:@"%02ld: %02ld",  minutes, seconds];

        self.timeLab.text  = text;
        [self.vContainer sd_setImageWithURL:[NSURL URLWithString:message.firstFrameImageUrl]];
    }
    
}



- (void)initialize{
    [self.contentView addSubview:self.vContainer];
    [self.contentView addSubview:self.maskView];
    [self.contentView addSubview:self.vImageViewContainer];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.playImageView];
    [self.contentView addSubview:self.clickView];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]; // 可选: Light, Dark, ExtraLight等
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = CGRectMake(0, 0, 130, 180);
    self.effectView = effectView;
    [self.maskView addSubview:effectView];

    
    [self.vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portraitImageView);
        make.left.equalTo(self.contentView).offset(60);
        make.width.equalTo(@130);
        make.bottom.equalTo(self.contentView).offset(-30);
    }];
    
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.vContainer);
    }];

    
    
    [self.vImageViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.vContainer);
        make.size.mas_offset(CGSizeMake(106, 24));
    }];

    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.iconImageView.mas_right).offset(4);
    }];
    
    
    
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.vImageViewContainer).offset(4);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
    
    
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vContainer.mas_centerY).offset(-10);
        make.centerX.equalTo(self.vContainer);
        make.size.mas_offset(CGSizeMake(24, 24));
    }];
    
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.vContainer).offset(-10);
    }];


    
    [self.clickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.vContainer);
    }];
}



- (void)viewed{
     
    self.titleLab.text = @"Viewed";
    self.iconImageView.image = [UIImage jl_name:@"jl_viewed" class:self];
    [self.vImageViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.vContainer);
        make.size.mas_offset(CGSizeMake(66, 24));
    }];
    
    
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.iconImageView.mas_right).offset(4);
    }];
    
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.vImageViewContainer).offset(4);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
}





- (void)expired{
    self.titleLab.text = @"Expired";
    self.iconImageView.image = [UIImage jl_name:@"jl_expired" class:self];

    [self.vImageViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.vContainer);
        make.size.mas_offset(CGSizeMake(76, 24));
    }];
    
    
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.iconImageView.mas_right).offset(4);
    }];
    
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.vImageViewContainer).offset(4);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
}







- (void)unlock{
    self.titleLab.text = @"To be unlocked";
    self.iconImageView.image = [UIImage jl_name:@"jl_lock" class:self];

    [self.vImageViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.vContainer);
        make.size.mas_offset(CGSizeMake(106, 24));
    }];
    
    
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.iconImageView.mas_right).offset(4);
    }];
    
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.vImageViewContainer).offset(4);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
}




- (void)videoViewed{
    
    self.titleLab.text = @"Viewed";
    self.iconImageView.image = [UIImage jl_name:@"jl_viewed" class:self];
    
    
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.iconImageView.mas_right).offset(4);
    }];
    
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.vImageViewContainer).offset(4);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
    
    [self.vImageViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playImageView.mas_bottom).offset(8);
        make.centerX.equalTo(self.vContainer);
        make.size.mas_offset(CGSizeMake(66, 24));
    }];

}





- (void)videoExpired{
    self.titleLab.text = @"Expired";
    self.iconImageView.image = [UIImage jl_name:@"jl_expired" class:self];
    
    
    
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.iconImageView.mas_right).offset(4);
    }];
    
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.vImageViewContainer).offset(4);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
    
    [self.vImageViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playImageView.mas_bottom).offset(8);
        make.centerX.equalTo(self.vContainer);
        make.size.mas_offset(CGSizeMake(76, 24));
    }];
}







- (void)videoUnlock{
    
    self.titleLab.text = @"To be unlocked";
    self.iconImageView.image = [UIImage jl_name:@"jl_lock" class:self];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.iconImageView.mas_right).offset(4);
    }];
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vImageViewContainer);
        make.left.equalTo(self.vImageViewContainer).offset(4);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
    
    
    [self.vImageViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playImageView.mas_bottom).offset(8);
        make.centerX.equalTo(self.vContainer);
        make.size.mas_offset(CGSizeMake(106, 24));
    }];

}






- (void)clickSendBtnEvnet{
    
    if ([self.model.extra isEqualToString:@"1"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips"
                                                                       message:@"This media is intimate. After unlocking,it can be viewed only once"
                                                                preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *goToSettings = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:goToSettings];
//        [alert addAction:cancel];
        [[NSObject currentViewController] presentViewController:alert animated:YES completion:nil];
    }else if ([self.model.extra isEqualToString:@"2"]){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips"
                                                                       message:@"This media is no longer valid. Please contact them to resend it."
                                                                preferredStyle:UIAlertControllerStyleAlert];
            //        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *goToSettings = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:goToSettings];
            //        [alert addAction:cancel];
        [[NSObject currentViewController] presentViewController:alert animated:YES completion:nil];
    }else{
        
        
        Weakself(ws);
            // 获取当前时间
        NSDate *now = [NSDate date];
        
            // 获取时间戳
        NSTimeInterval seconds = [now timeIntervalSince1970];
        
            // 将秒转换为毫秒
        long long currentTimeStamp = seconds * 1000;
        NSInteger expirationTime = self.message.expirationTime;
        
        if ([self.message.type isEqualToString:@"1"]) {
                        
            if (currentTimeStamp > expirationTime) {
                [SVProgressHUD showImage:nil status:@"The record has expired."];
                
                if (![self.model.extra isEqualToString:@"2"]) {
                    [[JLIMService shared] setMessageExtraStatus:@"2" messageId:self.model.messageId callback:^(BOOL result) {
                        ws.model.extra = @"2";
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRcMessageUpdateSuccess object:self];
                        NSLog(@"解锁私密状态更新成功 (过期)");
                    }];
                }
                return;
            }
                // 解锁照片
            [JLPopupViewComponent initPhotoWithModel:self.model];
        }else{
            
            if (currentTimeStamp > expirationTime) {
                [SVProgressHUD showImage:nil status:@"The record has expired."];
                
                if (![self.model.extra isEqualToString:@"2"]) {
                    [[JLIMService shared] setMessageExtraStatus:@"2" messageId:self.model.messageId callback:^(BOOL result) {
                        ws.model.extra = @"2";
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRcMessageUpdateSuccess object:self];
                        NSLog(@"解锁私密状态更新成功 (过期)");
                    }];
                }

                return;
            }

                // 解锁视频
            [JLPopupViewComponent initVideoWithModel:self.model rootViewController:[NSObject currentViewController]];
        }
    }

}



- (UIImageView *)vContainer{
    if (!_vContainer) {
        UIImageView *view = [[UIImageView alloc] init];
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = YES;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
        _vContainer = view;
    }
    return  _vContainer;
}




- (UIView *)maskView{
    if (!_maskView) {
        UIView *view = [[UIView alloc] init];
        view.userInteractionEnabled = NO;
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = YES;
        _maskView = view;
    }
    return  _maskView;
}






- (UILabel *)titleLab{
    if (!_titleLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor whiteColor];
        view.userInteractionEnabled = NO;
        view.text = @"To be unlocked";
        view.font = [UIFont systemFontOfSize:10];
        _titleLab = view;
    }
    return  _titleLab;
}





- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.userInteractionEnabled = NO;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.image = [UIImage jl_name:@"jl_lock" class:self];
        _iconImageView = view;
    }
    return  _iconImageView;
}




- (UILabel *)timeLab{
    if (!_timeLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.8];
        view.userInteractionEnabled = NO;
        view.text = @"";
        view.font = [UIFont systemFontOfSize:10];
        _timeLab = view;
    }
    return  _timeLab;
}







- (UIImageView *)playImageView{
    if (!_playImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.userInteractionEnabled = NO;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.backgroundColor = [UIColor clearColor];
        view.image = [UIImage jl_name:@"jl_play" class:self];
        _playImageView = view;
    }
    return  _playImageView;
}







- (UIView *)vImageViewContainer{
    if (!_vImageViewContainer) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.2];
        view.layer.cornerRadius = 12;
        view.layer.masksToBounds = YES;
        _vImageViewContainer = view;
    }
    return  _vImageViewContainer;
}






- (UIButton *)clickView{
    if (!_clickView) {
        UIButton *view = [[UIButton alloc] init];
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor clearColor];
        [view addTarget:self action:@selector(clickSendBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        _clickView = view;
    }
    return  _clickView;
}




+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight{
    JLMediaPrivateMessage *message = (JLMediaPrivateMessage *)model.content;
    
    if ([message.type isEqualToString:@"1"]) {
        return CGSizeMake(kScreenWidth, 180 + extraHeight);
    }else{
        return CGSizeMake(kScreenWidth, 120 + extraHeight);
    }
}



@end

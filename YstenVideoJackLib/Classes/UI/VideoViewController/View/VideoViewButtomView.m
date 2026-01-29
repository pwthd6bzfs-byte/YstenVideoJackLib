    //
    //  JLConversationButtomView.m
    //  Pods
    //
    //  Created by percent on 2026/1/9.
    //

#import "VideoViewButtomView.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JLRTCService.h"
#import "UIImage+Add.h"


@interface VideoViewButtomView ()


@end



@implementation VideoViewButtomView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self createUI];
    }
    return self;
}


- (void)createUI{
    [self addSubview:self.contentTxf];
    [self addSubview:self.sendBtn];
    [self addSubview:self.cameraBtn];
    [self addSubview:self.microphoneBtn];
//    [self addSubview:self.moreBtn];
    [self addSubview:self.emojiBtn];
    [self addSubview:self.giftBtn];
    [self addSubview:self.reverseBtn];
    
    
    [self.contentTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self.reverseBtn.mas_left).offset(-8);
        make.height.equalTo(@48);
    }];
    
    
    
    [self.cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-16);
        make.size.mas_equalTo(CGSizeMake(48,48));
    }];
    
    [self.microphoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.cameraBtn.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(48,48));
    }];
    
    
    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.microphoneBtn.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(48,48));
    }];

    
    [self.reverseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.giftBtn.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(48,48));
    }];
    
    
//    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentTxf);
//        make.right.equalTo(self).offset(-16);
//        make.size.mas_equalTo(CGSizeMake(56,32));
//    }];


//    [self.emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentTxf.mas_bottom).offset(8);
//        make.left.equalTo(self.photoBtn.mas_right).offset(width);
//        make.size.mas_equalTo(CGSizeMake(40,40));
//    }];
}



- (void)showKeyboardUI{
    
    self.backgroundColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.contentTxf.backgroundColor = [UIColor whiteColor];
    self.contentTxf.textColor = [UIColor blackColor];
    
//    self.moreBtn.hidden = YES;
    self.giftBtn.hidden = YES;
    self.reverseBtn.hidden = YES;
    self.cameraBtn.hidden = YES;
    self.microphoneBtn.hidden = YES;
    self.sendBtn.hidden = NO;

    [self.contentTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self.sendBtn.mas_left).offset(-8);
        make.height.equalTo(@48);
    }];
    
    
    [self.cameraBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];

    
    [self.microphoneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
    
    
    [self.giftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
    
    
    [self.reverseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];
    
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-16);
        make.size.mas_equalTo(CGSizeMake(48,48));
    }];


}

- (void)hideKeyboardUI{
    self.backgroundColor = [UIColor clearColor];
    self.contentTxf.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    self.contentTxf.textColor = [UIColor whiteColor];

//    self.moreBtn.hidden = NO;
    self.giftBtn.hidden = NO;
    self.reverseBtn.hidden = NO;
    self.cameraBtn.hidden = NO;
    self.microphoneBtn.hidden = NO;
    self.sendBtn.hidden = YES;


    [self.contentTxf mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self.reverseBtn.mas_left).offset(-8);
        make.height.equalTo(@48);
    }];
    
    
    
    [self.cameraBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-16);
        make.size.mas_equalTo(CGSizeMake(48,48));
    }];
    
    
    
    [self.microphoneBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.cameraBtn.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(48,48));
    }];

    
//    [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.right.equalTo(self.microphoneBtn.mas_left).offset(-8);
//        make.size.mas_equalTo(CGSizeMake(48,48));
//    }];
    
    
    [self.giftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.microphoneBtn.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(48,48));
    }];
    
    
    [self.reverseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.giftBtn.mas_left).offset(-8);
        make.size.mas_equalTo(CGSizeMake(48,48));
    }];
    
    
    [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    }];

}






    // 文本内容发送点击
- (void)clickSendBtnEvent{
    if (self.clickSendBlock) {
        self.clickSendBlock();
    }
}






    // 更多点击
//- (void)clickMoreBtnEvent{
//    if (self.clickMoreBtnBlock) {
//        self.clickMoreBtnBlock();
//    }
//}





    // 表情点击
- (void)clickEmojiBtnEvent{
    if (self.clickEmojiBlock) {
        self.clickEmojiBlock();
    }
}





// 前后置摄像头点击
- (void)clickReverseBtnEvent{
    if (self.clickReverseBtnBlock) {
        self.clickReverseBtnBlock();
    }
}


    // 摄像头点击
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
    
    if (self.clickCameraBtnBlock) {
        self.clickCameraBtnBlock(sender.selected);
    }
}




// 麦克风点击
- (void)clickMicrophoneBtnEvnet:(UIButton *)sender{
    sender.selected = !sender.isSelected; // 更新按钮状态
    if (sender.isSelected) {
        [[JLRTCService shared].agoraKit muteLocalAudioStream:YES];
    } else {
        [[JLRTCService shared].agoraKit muteLocalAudioStream:NO];
    }
    
    if (self.clickMicroPhoneBtnBlock) {
        self.clickMicroPhoneBtnBlock(sender.selected);
    }
}





    // 礼物点击
- (void)clickGiftBtnEvent{
    if (self.clickGiftBlock) {
        self.clickGiftBlock();
    }
}





#pragma mark - Target Action
- (UITextField *)contentTxf{
    if (!_contentTxf) {
        UITextField *view = [[UITextField alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
        view.layer.cornerRadius = 12;
        view.layer.masksToBounds = YES;
        view.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        view.leftViewMode = UITextFieldViewModeAlways;
        view.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        view.rightViewMode = UITextFieldViewModeAlways;
        view.font = [UIFont systemFontOfSize:14];
        view.textColor = [UIColor whiteColor];
        view.placeholder = @"Please enter...";
        _contentTxf = view;
    }
    
    return  _contentTxf;
}



- (UIButton *)sendBtn{
    if (!_sendBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.userInteractionEnabled = YES;
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage jl_name:@"jl_send" class:self] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickSendBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn = btn;
    }
    
    return  _sendBtn;
}



//- (UIButton *)moreBtn{
//    if (!_moreBtn) {
//        UIButton *btn = [[UIButton alloc] init];
//        btn.backgroundColor = [UIColor clearColor];
//        [btn setImage:[UIImage imageNamed:@"jl_more"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(clickMoreBtnEvent) forControlEvents:UIControlEventTouchUpInside];
//        _moreBtn = btn;
//    }
//    
//    return  _moreBtn;
//}



- (UIButton *)emojiBtn{
    if (!_emojiBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage jl_name:@"jl_emoji" class:self] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickEmojiBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        _emojiBtn = btn;
    }
    
    return  _emojiBtn;
}


- (UIButton *)reverseBtn{
    if (!_reverseBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage jl_name:@"jl_reverse_no" class:self] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickReverseBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        _reverseBtn = btn;
    }
    
    return  _reverseBtn;
}





- (UIButton *)cameraBtn{
    if (!_cameraBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage jl_name:@"jl_room_camera" class:self] forState:UIControlStateNormal];
        [btn setImage:[UIImage jl_name:@"jl_room_camera_no" class:self] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickCameraBtnEvnet:) forControlEvents:UIControlEventTouchUpInside];
        _cameraBtn = btn;
    }
    
    return  _cameraBtn;
}





- (UIButton *)microphoneBtn{
    if (!_microphoneBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage jl_name:@"jl_room_microphone" class:self] forState:UIControlStateNormal];
        [btn setImage:[UIImage jl_name:@"jl_room_microphone_no" class:self] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickMicrophoneBtnEvnet:) forControlEvents:UIControlEventTouchUpInside];
        _microphoneBtn = btn;
    }
    
    return  _microphoneBtn;
}





- (UIButton *)giftBtn{
    if (!_giftBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage jl_name:@"jl_gift_video" class:self] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickGiftBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        _giftBtn = btn;
    }
    
    return  _giftBtn;
}



@end

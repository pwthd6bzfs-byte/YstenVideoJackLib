//
//  JLConversationButtomView.m
//  Pods
//
//  Created by percent on 2026/1/9.
//

#import "JLConversationButtomView.h"
#import "RCAlumListTableViewController.h"
#import "RCBaseNavigationController.h"
#import "JLUserService.h"
#import "JLUserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIColor+HexColor.h"
#import <Masonry/Masonry.h>
#import "UIImage+Add.h"


@interface JLConversationButtomView ()


@end



@implementation JLConversationButtomView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI{
    [self addSubview:self.leftBtn];
    [self addSubview:self.contentTxf];
    [self addSubview:self.recordBtn];
    [self addSubview:self.sendBtn];
    
    [self addSubview:self.photoBtn];
    [self addSubview:self.emojiBtn];
    [self addSubview:self.telBtn];
    [self addSubview:self.giftBtn];


    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentTxf);
        make.left.equalTo(self).offset(16);
        make.size.mas_equalTo(CGSizeMake(24,24));
    }];

    
    [self.contentTxf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.left.equalTo(self.leftBtn.mas_right).offset(12);
//        make.size.mas_equalTo(CGSizeMake(120,40));
        make.right.equalTo(self.sendBtn.mas_left).offset(-16);
        make.height.equalTo(@48);
    }];
    
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentTxf);
    }];
    
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentTxf);
        make.right.equalTo(self).offset(-16);
        make.size.mas_equalTo(CGSizeMake(56,32));
    }];
    
        
    
    CGFloat kSreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat width = (kSreenWidth - 39.0*2 - 40*4)/3.0;
    
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTxf.mas_bottom).offset(8);
        make.left.equalTo(self).offset(39);
        make.size.mas_equalTo(CGSizeMake(40,40));
    }];

    
    [self.emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTxf.mas_bottom).offset(8);
        make.left.equalTo(self.photoBtn.mas_right).offset(width);
        make.size.mas_equalTo(CGSizeMake(40,40));
    }];

    
    [self.telBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTxf.mas_bottom).offset(8);
        make.left.equalTo(self.emojiBtn.mas_right).offset(width);
        make.size.mas_equalTo(CGSizeMake(40,40));
    }];
    
    
    [self.giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTxf.mas_bottom).offset(8);
        make.left.equalTo(self.telBtn.mas_right).offset(width);
        make.size.mas_equalTo(CGSizeMake(40,40));
    }];

}



// 录音点击
- (void)clickLeftBtnEvent{
    self.leftBtn.selected = !self.leftBtn.selected;
    if (self.leftBtn.selected == YES) {
        [self.leftBtn setImage:[UIImage jl_name:@"jl_record1" class:self] forState:UIControlStateNormal];
        self.recordBtn.hidden = NO;
    }else{
        [self.leftBtn setImage:[UIImage jl_name:@"jl_record" class:self] forState:UIControlStateNormal];
        self.recordBtn.hidden = YES;
    }
    
    if (self.clickLeftBlock) {
        self.clickLeftBlock(self.leftBtn.selected);
    }
}



// 文本内容发送点击
- (void)clickSendBtnEvent{
    if (self.clickSendBlock) {
        self.clickSendBlock();
    }
}



// 相册点击
- (void)clickPhotoBtnEvent{
    if (self.clickPhotoBlock) {
        self.clickPhotoBlock();
    }
}



// 表情点击
- (void)clickEmojiBtnEvent{
    self.leftBtn.selected = NO;
    [self.leftBtn setImage:[UIImage jl_name:@"jl_record" class:self] forState:UIControlStateNormal];
    self.recordBtn.hidden = YES;

    if (self.clickEmojiBlock) {
        self.clickEmojiBlock();
    }
}



// 视频通话点击
- (void)clickTelBtnEvent{
    if (self.clickTelBlock) {
        self.clickTelBlock();
    }
}



// 礼物点击
- (void)clickGiftBtnEvent{
    if (self.clickGiftBlock) {
        self.clickGiftBlock();
    }
}


#pragma mark - Target Action
- (void)voiceRecordButtonTouchDown:(UIButton *)sender {
//    sender.backgroundColor = RCDynamicColor(@"auxiliary_background_2_color", @"0xe0e2e3", @"0x323232");
    sender.backgroundColor = [UIColor colorWithHexString:@"#e0e2e3"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputContainerView:forControlEvents:)]) {
        [self.delegate inputContainerView:self forControlEvents:UIControlEventTouchDown];
    }
}

- (void)voiceRecordButtonTouchUpInside:(UIButton *)sender {
//    sender.backgroundColor = RCDynamicColor(@"auxiliary_background_1_color", @"0xffffff", @"0x2d2d2d");
    sender.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputContainerView:forControlEvents:)]) {
        [self.delegate inputContainerView:self forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)voiceRecordButtonTouchCancel:(UIButton *)sender {
//    sender.backgroundColor = RCDynamicColor(@"auxiliary_background_1_color", @"0xffffff", @"0x2d2d2d");
    sender.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputContainerView:forControlEvents:)]) {
        [self.delegate inputContainerView:self forControlEvents:UIControlEventTouchCancel];
    }
}

- (void)voiceRecordButtonTouchDragExit:(UIButton *)sender {
//    sender.backgroundColor = RCDynamicColor(@"auxiliary_background_1_color", @"0xffffff", @"0x2d2d2d");
//    sender.backgroundColor = [UIColor redColor];
    sender.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputContainerView:forControlEvents:)]) {
        [self.delegate inputContainerView:self forControlEvents:UIControlEventTouchDragExit];
    }
}

- (void)voiceRecordButtonTouchDragEnter:(UIButton *)sender {
    
//    sender.backgroundColor = RCDynamicColor(@"auxiliary_background_2_color", @"0xe0e2e3", @"0x323232");
    sender.backgroundColor = [UIColor colorWithHexString:@"#e0e2e3"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputContainerView:forControlEvents:)]) {
        [self.delegate inputContainerView:self forControlEvents:UIControlEventTouchDragEnter];
    }
}

- (void)voiceRecordButtonTouchUpOutside:(UIButton *)sender {
//    sender.backgroundColor = RCDynamicColor(@"auxiliary_background_1_color", @"0xffffff", @"0x323232") ;
    sender.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputContainerView:forControlEvents:)]) {
        [self.delegate inputContainerView:self forControlEvents:UIControlEventTouchUpOutside];
    }
}





- (UIButton *)recordBtn{
    if (!_recordBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.layer.cornerRadius = 12;
        btn.layer.masksToBounds = YES;
        [btn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        [btn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [btn setTitle:@"松开 结束"
                       forState:UIControlStateHighlighted];
        btn.hidden = YES;
        [btn addTarget:self
                          action:@selector(voiceRecordButtonTouchDown:)
                forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self
                          action:@selector(voiceRecordButtonTouchUpInside:)
                forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self
                          action:@selector(voiceRecordButtonTouchUpOutside:)
                forControlEvents:UIControlEventTouchUpOutside];
        [btn addTarget:self
                          action:@selector(voiceRecordButtonTouchDragExit:)
                forControlEvents:UIControlEventTouchDragExit];
        [btn addTarget:self
                          action:@selector(voiceRecordButtonTouchDragEnter:)
                forControlEvents:UIControlEventTouchDragEnter];
        [btn addTarget:self
                          action:@selector(voiceRecordButtonTouchCancel:)
                forControlEvents:UIControlEventTouchCancel];
        _recordBtn = btn;
    }
    
    return  _recordBtn;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage jl_name:@"jl_record" class:self] forState:UIControlStateNormal];
        [btn setImage:[UIImage jl_name:@"jl_keyboard" class:self] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(clickLeftBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn = btn;
    }
    
    return  _leftBtn;
}




- (UITextField *)contentTxf{
    if (!_contentTxf) {
        UITextField *view = [[UITextField alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 12;
        view.layer.masksToBounds = YES;
        view.placeholder = @"Membership is free";
        view.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        view.leftViewMode = UITextFieldViewModeAlways;
        view.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        view.rightViewMode = UITextFieldViewModeAlways;
        _contentTxf = view;
    }
    
    return  _contentTxf;
}



- (UIButton *)sendBtn{
    if (!_sendBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage jl_name:@"jl_send" class:self] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickSendBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn = btn;
    }
    
    return  _sendBtn;
}



- (UIButton *)photoBtn{
    if (!_photoBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage jl_name:@"jl_photo" class:self] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickPhotoBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        _photoBtn = btn;
    }
    
    return  _photoBtn;
}



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



- (UIButton *)telBtn{
    if (!_telBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage jl_name:@"jl_tel" class:self] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickTelBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        _telBtn = btn;
    }
    
    return  _telBtn;
}



- (UIButton *)giftBtn{
    if (!_giftBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage jl_name:@"jl_gift" class:self] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickGiftBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        _giftBtn = btn;
    }
    
    return  _giftBtn;
}



@end

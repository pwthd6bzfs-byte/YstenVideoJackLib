    //
    //  VideoViewMessageCell.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/19.
    //

#import "VideoViewTopTextMessageCell.h"
#import "JLUserService.h"
#import "YYKit.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+HexColor.h"
#import "JLIMService.h"

@interface VideoViewTopTextMessageCell ()


@property (nonatomic, strong) UIView *vContainer;

@property (nonatomic, strong) UILabel *messageLab;

@property (nonatomic, strong) UIButton *remoteBtn;

@end


@implementation VideoViewTopTextMessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}


- (void)setMessage:(RCMessage *)message{
    
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMessage = (RCTextMessage*)message.content;
        
        
        JLUserModel *userModel = [JLUserModel modelWithJSON:textMessage.extra];
        NSString *nickName = @"System";
        NSString *colorStrin = @"#119BFE";
                
        NSString *text = [NSString stringWithFormat:@"%@: %@",nickName,textMessage.content];
        
            // 富文本
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
            // 设置整体样式，比如字体
        [attributedText addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:colorStrin],NSFontAttributeName:[UIFont systemFontOfSize:14]
        } range:NSMakeRange(0, nickName.length+1)];
        self.messageLab.attributedText = attributedText;
        
        
    }
    
}


- (void)createUI{
    
    [self.contentView addSubview:self.vContainer];
    [self.vContainer addSubview:self.messageLab];
    [self.vContainer addSubview:self.remoteBtn];
    
    [self.vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
        
    
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vContainer).offset(8);
        make.left.equalTo(self.vContainer).offset(12);
        make.right.equalTo(self.remoteBtn.mas_left).offset(-4);
        make.bottom.equalTo(self.vContainer).offset(-8);
    }];
    
    
    [self.remoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vContainer).offset(-12);
        make.size.mas_equalTo(CGSizeMake(51, 20));
        make.centerY.equalTo(self.vContainer);
    }];

}





- (void)clickRemoteBtnEvnet{
    
    if ([JLIMService shared].delegate && [[JLIMService shared].delegate respondsToSelector:@selector(showDiveceControlPanelAlertView)]) {
        [[JLIMService shared].delegate showDiveceControlPanelAlertView];
    }
}






- (UILabel *)messageLab{
    if (!_messageLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor whiteColor];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:14];
        view.textAlignment = UITextAlignmentLeft;
//        view.preferredMaxLayoutWidth = 276-12*2; // 最大宽度
//        view.lineBreakMode = NSLineBreakByTruncatingTail;
        view.numberOfLines = 1;
        _messageLab = view;
    }
    return  _messageLab;
}



- (UIView *)vContainer{
    if (!_vContainer) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
        view.layer.cornerRadius = 12;
        view.layer.masksToBounds = YES;
        _vContainer = view;
    }
    return  _vContainer;
}



- (UIButton *)remoteBtn{
    if (!_remoteBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setTitle:@"remote" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:10];
        view.backgroundColor = [UIColor colorWithHexString:@"#D6007E"];
        view.layer.cornerRadius = 20/2.0;
        view.layer.masksToBounds = YES;
        [view addTarget:self action:@selector(clickRemoteBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        _remoteBtn = view;
    }
    return  _remoteBtn;
}





@end

//
//  VideoViewAskGiftCell.m
//  LJChatSDK
//
//  Created by percent on 2026/1/19.
//

#import "VideoViewAskGiftMessageCell.h"
#import "JLCustomMessage.h"
#import "JLUserService.h"
#import "YYKit.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+HexColor.h"

@interface VideoViewAskGiftMessageCell ()


@property (nonatomic, strong) UIView *vContainer;

@property (nonatomic, strong) UILabel *nickNameLab;

@property (nonatomic, strong) UILabel *messageLab;

@property (nonatomic, strong) UIImageView *giftImageView;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) RCMessage *model;

@end


@implementation VideoViewAskGiftMessageCell


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

    self.model = message;
    
    if ([message.content isMemberOfClass:[JLAskGiftMessage class]]) {
        JLAskGiftMessage *askGiftMessage = (JLAskGiftMessage*)message.content;
        
        JLUserModel *userModel = [JLUserModel modelWithJSON:askGiftMessage.extra];
        NSString *nickName = @"";
        if (userModel.nickName.length > 0){
            nickName = userModel.nickName;
        }else if (message.content.senderUserInfo.name.length > 0){
            nickName = message.content.senderUserInfo.name;
        }
        
        self.nickNameLab.text = nickName;
        
        NSString *giftString = [NSString stringWithFormat:@"%@*1",askGiftMessage.giftName];
        
        NSString *text = [NSString stringWithFormat:@"Ask for %@",giftString];
        
        
        [self.giftImageView sd_setImageWithURL:[NSURL URLWithString:askGiftMessage.giftUrl]];
            // 富文本
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];

        self.messageLab.attributedText = attributedText;
        
        
            /// 计算宽度
        UIFont *font = [UIFont systemFontOfSize:14];
        NSDictionary *attributes = @{NSFontAttributeName: font};
        CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
        CGSize size = rect.size;
        if (size.width >= (276 - 10*2 - 50 -5)) {
            
            [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView);
                make.top.equalTo(self.nickNameLab.mas_bottom).offset(10);
                make.width.equalTo(@276);
                make.height.equalTo(@72);
                make.bottom.equalTo(self.contentView).offset(-5);
            }];
            
        }else{
            
            [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(size.width + 50 + 10*2 + 5));
                make.left.equalTo(self.contentView);
                make.top.equalTo(self.nickNameLab.mas_bottom).offset(10);
                make.height.equalTo(@72);
                make.bottom.equalTo(self.contentView).offset(-5);
            }];
        }
    }
    
    
    
}


- (void)createUI{
    
    [self.contentView addSubview:self.nickNameLab];
    [self.contentView addSubview:self.vContainer];
    [self.vContainer addSubview:self.messageLab];
    [self.vContainer addSubview:self.giftImageView];
    [self.vContainer addSubview:self.sendBtn];
    
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.right.equalTo(self.contentView);
    }];

    
    [self.vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.nickNameLab.mas_bottom).offset(10);
        make.height.equalTo(@72);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vContainer);
        make.left.equalTo(self.vContainer).offset(10);
        make.size.mas_offset(CGSizeMake(50, 50));
    }];
    
    
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftImageView.mas_top).offset(-2);
        make.left.equalTo(self.giftImageView.mas_right).offset(5);
    }];
    
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.messageLab);
        make.bottom.equalTo(self.vContainer.mas_bottom).offset(-5);
        make.size.mas_equalTo(CGSizeMake(56,32));
    }];
    
}



- (void)clickSendBtnEvnet{
    
    JLAskGiftMessage *message = (JLAskGiftMessage *)self.model.content;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVideoViewAskGiftSuccess object:message];
}




- (UILabel *)nickNameLab{
    if (!_nickNameLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor colorWithHexString:@"#FE006B"];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:14];
        view.textAlignment = UITextAlignmentLeft;
        _nickNameLab = view;
    }
    return  _nickNameLab;
}



- (UILabel *)messageLab{
    if (!_messageLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor whiteColor];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:14];
        view.textAlignment = UITextAlignmentLeft;
        view.preferredMaxLayoutWidth = 276 - 10*2 - 50 - 5; // 最大宽度
        view.lineBreakMode = NSLineBreakByCharWrapping;
        view.numberOfLines = 0;
        _messageLab = view;
    }
    return  _messageLab;
}



- (UIButton *)sendBtn{
    if (!_sendBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setTitle:@"Send" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:13];
        view.backgroundColor = [UIColor colorWithHexString:@"#D6007E"];
        view.layer.cornerRadius = 32.0/2;
        [view addTarget:self action:@selector(clickSendBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn = view;
    }
    return  _sendBtn;
}



- (UIImageView *)giftImageView{
    if (!_giftImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@""];
        _giftImageView = view;
    }
    return  _giftImageView;
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


@end

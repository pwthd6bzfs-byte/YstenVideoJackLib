    //
    //  JLGiftMessageCell.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/13.
    //

#import "JLAskGiftMessageCell.h"
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
#import "UIImage+Add.h"

@interface JLAskGiftMessageCell ()

@property (nonatomic, strong) JLAskGiftMessage *askGiftMessage;
@property (nonatomic, strong) UIView *vContainer;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *countImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *sendBtn;


@end

@implementation JLAskGiftMessageCell



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
    
    JLAskGiftMessage *message = (JLAskGiftMessage *)self.model.content;
    self.askGiftMessage = message;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:message.giftUrl]];
}




- (void)initialize{
    [self.contentView addSubview:self.vContainer];
    [self.vContainer addSubview:self.titleLab];
    [self.vContainer addSubview:self.iconImageView];
    [self.vContainer addSubview:self.countImageView];
    [self.vContainer addSubview:self.sendBtn];
    
    
    [self.vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portraitImageView);
        make.left.equalTo(self.contentView).offset(60);
        make.width.equalTo(@200);
        make.bottom.equalTo(self.contentView).offset(-30);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vContainer.mas_top).offset(3);
        make.left.right.equalTo(self.vContainer);
    }];
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vContainer);
        make.centerX.equalTo(self.vContainer).offset(-18);
        make.size.mas_offset(CGSizeMake(32, 32));
    }];
    
    
    [self.countImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vContainer);
        make.centerX.equalTo(self.vContainer).offset(18);
        make.size.mas_offset(CGSizeMake(32, 32));
    }];
    
    
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.vContainer);
        make.height.equalTo(@30);
        make.left.right.equalTo(self.vContainer);
    }];
    
}



- (void)clickSendBtnEvnet{
    
    JLAskGiftMessage *message = (JLAskGiftMessage *)self.model.content;

    NSDictionary *dict = [message modelToJSONObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAskGiftSuccess object:dict];
}



- (UIView *)vContainer{
    if (!_vContainer) {
        UIView *view = [[UIView alloc] init];
        view.layer.cornerRadius = 16;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        _vContainer = view;
    }
    return  _vContainer;
}



- (UILabel *)titleLab{
    if (!_titleLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor colorWithHexString:@"#000000"];
        view.text = @"Can you gie me a present?";
        view.font = [UIFont systemFontOfSize:15];
        view.textAlignment = UITextAlignmentCenter;
        _titleLab = view;
    }
    return  _titleLab;
}


- (UIImageView *)countImageView{
    if (!_countImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage jl_name:@"jl_count" class:self];
        view.contentMode = UIViewContentModeScaleAspectFit;
        _countImageView = view;
    }
    return  _countImageView;
}



- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView = view;
    }
    return  _iconImageView;
}



- (UIButton *)sendBtn{
    if (!_sendBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setTitle:@"Send" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:13];
        view.backgroundColor = [UIColor colorWithHexString:@"#D6007E"];
        [view addTarget:self action:@selector(clickSendBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn = view;
    }
    return  _sendBtn;
}




+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight{
    return CGSizeMake(kScreenWidth, 140 + extraHeight);
}




@end

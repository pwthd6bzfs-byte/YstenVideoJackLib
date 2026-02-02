//
//  JLGiftMessageCell.m
//  LJChatSDK
//
//  Created by percent on 2026/1/13.
//

#import "JLGiftMessageCell.h"
#import "JLUserService.h"
#import "JLCustomMessage.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Config.h"
@interface JLGiftMessageCell ()

@property (nonatomic, strong) JLGiftMessage *giftMessage;
@property (nonatomic, strong) UIView *vContainer;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *sendBtn;


@end

@implementation JLGiftMessageCell



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
    
    JLGiftMessage *message = (JLGiftMessage *)self.model.content;
    self.giftMessage = message;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:message.giftUrl]];
    
    if (!message.giveNum) {
        self.titleLab.text = [NSString stringWithFormat:@"%@ x1",message.giftName];
    }else{
        self.titleLab.text = [NSString stringWithFormat:@"%@ x%@",message.giftName,message.giveNum];
    }
    
    
    NSString *text = message.giftName;
    UIFont *font = [UIFont systemFontOfSize:15];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    CGFloat width = rect.size.width;
    
    
    [self.vContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width + 10*2 + 62));
    }];
    
    
    [self.statusContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.vContainer);
        make.right.equalTo(self.vContainer.mas_left).offset(-10);
    }];
}




- (void)initialize{
    [self.contentView addSubview:self.vContainer];
    [self.vContainer addSubview:self.titleLab];
    [self.vContainer addSubview:self.iconImageView];
    
    [self.vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.portraitImageView);
        make.right.equalTo(self.contentView).offset(-60);
        make.width.equalTo(@110);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vContainer);
        make.left.equalTo(self.vContainer).offset(10);
        make.size.mas_offset(CGSizeMake(36, 36));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vContainer);
        make.right.equalTo(self.vContainer).offset(-10);
    }];
    
    
    
    self.vContainer.backgroundColor = [UIColor colorWithHexString:@"#D6007E"];

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
        view.textColor = [UIColor whiteColor];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:15];
        view.textAlignment = UITextAlignmentCenter;
        _titleLab = view;
    }
    return  _titleLab;
}




- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView = view;
    }
    return  _iconImageView;
}





+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight{
    return CGSizeMake(kScreenWidth, 46 + extraHeight);
}




@end

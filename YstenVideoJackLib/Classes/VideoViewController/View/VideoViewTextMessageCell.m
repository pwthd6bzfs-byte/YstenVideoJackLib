//
//  VideoViewMessageCell.m
//  LJChatSDK
//
//  Created by percent on 2026/1/19.
//

#import "VideoViewTextMessageCell.h"
#import "JLUserService.h"
#import "YYKit.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+HexColor.h"

@interface VideoViewTextMessageCell ()


@property (nonatomic, strong) UIView *vContainer;

@property (nonatomic, strong) UILabel *messageLab;

@end


@implementation VideoViewTextMessageCell


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
            NSString *nickName = @"";
            NSString *colorStrin = @"";
            
            // 是自己的消息
            JLUserModel *userModel1 = [JLUserService shared].userInfo;
            if ([message.senderUserId isEqualToString:[NSString stringWithFormat:@"%ld",userModel1.userID]]) {
                nickName = userModel1.nickName;
                colorStrin = @"#70D6EF";
            }else{
                if (userModel.nickName.length > 0){
                    nickName = userModel.nickName;
                }
                colorStrin = @"#FE006B";
            }
            
            NSString *text = [NSString stringWithFormat:@"%@: %@",nickName,textMessage.content];
                        
            // 富文本
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
                // 设置整体样式，比如字体
            [attributedText addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:colorStrin]
                                          } range:NSMakeRange(0, nickName.length+1)];
            self.messageLab.attributedText = attributedText;
            
            
            /// 计算宽度
            UIFont *font = [UIFont systemFontOfSize:14];
            
            NSDictionary *attributes = @{NSFontAttributeName: font};
            CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
            
            CGSize size = rect.size;
            if (size.width >= (276 - 12*2)) {
                
                [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(self.contentView);
                    make.width.equalTo(@276);
                    make.bottom.equalTo(self.contentView).offset(-5);
                }];

            }else{
                
                [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.equalTo(self.contentView);
                    make.width.equalTo(@(size.width+1 + 12*2));
                    make.bottom.equalTo(self.contentView).offset(-5);
                }];
            }
    }
    
    
    
}


- (void)createUI{
    
    [self.contentView addSubview:self.vContainer];
    [self.vContainer addSubview:self.messageLab];
    
    [self.vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vContainer).offset(8);
        make.left.equalTo(self.vContainer).offset(12);
        make.right.equalTo(self.vContainer).offset(-12);
        make.bottom.equalTo(self.vContainer).offset(-8);
    }];
}



- (UILabel *)messageLab{
    if (!_messageLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor whiteColor];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:14];
        view.textAlignment = UITextAlignmentLeft;
        view.preferredMaxLayoutWidth = 276-12*2; // 最大宽度
        view.lineBreakMode = NSLineBreakByCharWrapping;
        view.numberOfLines = 0;
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







@end

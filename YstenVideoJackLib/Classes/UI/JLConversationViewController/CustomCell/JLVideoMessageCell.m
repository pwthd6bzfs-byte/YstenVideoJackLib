    //
    //  JLGiftMessageCell.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/13.
    //

#import "JLVideoMessageCell.h"
#import "JLCustomMessage.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import "Config.h"
@interface JLVideoMessageCell ()

@property (nonatomic, strong) JLVideoMessage *videoMessage;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *vContainer;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UIButton *sendBtn;


@end

@implementation JLVideoMessageCell



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
    
    JLVideoMessage *message = (JLVideoMessage *)self.model.content;
    self.videoMessage = message;
    
    
    NSString *statusName = @"";
    NSString *statusImageStr = @"";
    NSString *statusColorHex = @"";
    NSString *subStatus = [NSString stringWithFormat:@"%@",message.subStatus];
    
    // 视频通话类型
    if ([subStatus isEqualToString:@"406"]){
        // 主播拒绝
        statusImageStr = @"jl_call_reject";
        statusName = @"Reject Calls";
        statusColorHex = @"#896B09";
    }else if ([subStatus isEqualToString:@"201"]){
        // 主播挂断

        statusImageStr = @"jl_call";
        statusName = [NSString stringWithFormat:@"Duration：%@",message.duration];
        statusColorHex = @"#137326";
    }else if ([subStatus isEqualToString:@"202"]){
        // 用户挂断
        
        statusImageStr = @"jl_call";
        statusName = [NSString stringWithFormat:@"Duration：%@",message.duration];
        statusColorHex = @"#137326";
    }else if ([subStatus isEqualToString:@"203"]){
        // 系统结束-余额不足
        
        statusImageStr = @"jl_call";
        statusName = [NSString stringWithFormat:@"Duration：%@",message.duration];
        statusColorHex = @"#137326";
    }else if ([subStatus isEqualToString:@"402"] ) {
        // 超时未接听
        
        statusImageStr = @"jl_call";
        statusName = @"Missed Calls";
        statusColorHex = @"#B4243C";
    }else{
        statusImageStr = @"jl_call";
        statusName = @"Missed Calls";
        statusColorHex = @"#D6007E";
    }
 
    self.titleLab.text = statusName;
    self.vContainer.backgroundColor = [UIColor colorWithHexString:statusColorHex];
    self.iconImageView.image = [UIImage imageNamed:statusImageStr];
    
    NSString *text = statusName;
    UIFont *font = [UIFont systemFontOfSize:15];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    CGFloat width = rect.size.width;
    
    
    [self.vContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(width + 10*2 + 5 + 24));
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
        make.size.mas_offset(CGSizeMake(24, 24));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vContainer);
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
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

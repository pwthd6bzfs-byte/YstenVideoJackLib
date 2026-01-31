    //
    //  RemoteView.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/19.
    //

#import "HeartMatchExplainView.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import "JLUserService.h"
#import "YYKit.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+HexColor.h"
#import "UIImage+Add.h"


@interface  HeartMatchExplainView()


@property (nonatomic, strong) UILabel *textLab;

@property (nonatomic, strong) UIImageView *coinImageView;


@end

@implementation HeartMatchExplainView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        [self creatUI];
    }
    return self;
}



- (void)creatUI{
    
    [self addSubview:self.coinImageView];
    [self addSubview:self.textLab];
    
    
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(26, 26));
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12);
    }];
    
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.coinImageView.mas_right).offset(4);
    }];
}






- (void)setContent:(NSString *)content{
    self.textLab.text = content;
}





- (UIImageView *)coinImageView{
    if (!_coinImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage jl_name:@"jl_heartMatch_head" class:self];
        view.clipsToBounds = YES;
        
        _coinImageView = view;
    }
    return  _coinImageView;
}







- (UILabel *)textLab{
    if (!_textLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor whiteColor];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:12];
        view.textAlignment = UITextAlignmentLeft;
        view.clipsToBounds = YES;
        _textLab = view;
    }
    return  _textLab;
}







@end

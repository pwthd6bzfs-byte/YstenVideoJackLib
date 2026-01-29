    //
    //  RemoteView.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/19.
    //

#import "RechargeView.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Add.h"
#import "JLIMService.h"


@interface  RechargeView()


@property (nonatomic, strong) UILabel *textLab;

@property (nonatomic, strong) UIImageView *coinImageView;

@property (nonatomic, strong) UIButton *rechargeBtn;


@end

@implementation RechargeView

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
    [self addSubview:self.rechargeBtn];
    
    
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(26, 26));
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12);
    }];
    
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.coinImageView.mas_right).offset(4);
    }];
    
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(72, 32));
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-12);
    }];
}





- (void)clickRechargeBtnEvnet{
    NSLog(@"去充值");
    
    if ([JLIMService shared].delegate && [[JLIMService shared].delegate respondsToSelector:@selector(showRechargeAlertView)]) {
        [[JLIMService shared].delegate showRechargeAlertView];
    }

}



- (UIImageView *)coinImageView{
    if (!_coinImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage jl_name:@"jl_recharge_coin" class:self];
        view.clipsToBounds = YES;

        _coinImageView = view;
    }
    return  _coinImageView;
}







- (UILabel *)textLab{
    if (!_textLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor whiteColor];
        view.text = @"Not enough coins, please recharge";
        view.font = [UIFont systemFontOfSize:12];
        view.textAlignment = UITextAlignmentLeft;
        view.lineBreakMode = NSLineBreakByCharWrapping;
        view.clipsToBounds = YES;
        _textLab = view;
    }
    return  _textLab;
}



- (UIButton *)rechargeBtn{
    if (!_rechargeBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setTitle:@"Recharge" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:12];
        view.backgroundColor = [UIColor colorWithHexString:@"#FE006B"];
        view.layer.cornerRadius = 8;
        [view addTarget:self action:@selector(clickRechargeBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        view.clipsToBounds = YES;
        _rechargeBtn = view;
    }
    return  _rechargeBtn;
}










@end

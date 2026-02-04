//
//  DeviceInviteNotifaction.m
//  YstenVideoJackLib
//
//  Created by percent on 2026/2/3.
//

#import "DeviceInviteNotifactionView.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Add.h"
#import "JLIMService.h"


@interface  DeviceInviteNotifactionView()

    /// 视图容器
@property (nonatomic, strong) UIImageView *vContainer;

@property (nonatomic, strong) UILabel *textLab;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UIButton *takeOverBtn;

@property (nonatomic, strong) UILabel *labTime;

@property (nonatomic, strong) UIImageView *imgIcon;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger timeCount;



@end

@implementation DeviceInviteNotifactionView

- (instancetype)init{
    self = [super init];
    if (self) {
//        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        self.timeCount = 10;
        self.image = [UIImage jl_name:@"jl_invite" class:self];
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        [self creatUI];
    }
    return self;
}



- (void)creatUI{
    
    [self addSubview:self.textLab];
    [self addSubview:self.closeBtn];
    [self addSubview:self.headImageView];
    [self addSubview:self.takeOverBtn];
    [self addSubview:self.labTime];
    [self addSubview:self.imgIcon];

        
    
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(16);
        make.left.equalTo(self).offset(16);
        make.right.equalTo(self).offset(-16-24);
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textLab);
        make.right.equalTo(self).offset(-10);
        make.size.mas_offset(CGSizeMake(24, 24));
    }];
    
    
    
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.textLab);
        make.top.equalTo(self.textLab.mas_bottom).offset(12);
        make.size.mas_offset(CGSizeMake(80, 80));
    }];

    
    
    [self.takeOverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.textLab);
        make.top.equalTo(self.headImageView.mas_bottom).offset(12);
        make.size.mas_offset(CGSizeMake(200, 36));
    }];
    
    
    [self.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.takeOverBtn);
        make.right.equalTo(self.labTime.mas_left).offset(-7);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
    
    
    
    [self.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.takeOverBtn);
        make.centerX.equalTo(self.takeOverBtn);
    }];
    
    

}


- (void)startTimer{
        // 如果定时器已经存在，先暂停（避免多个定时器同时运行）
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
        // 创建并启动定时器，每隔1秒触发一次timerFired方法
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timerFired)
                                                    userInfo:nil
                                                     repeats:YES];
}



- (void)timerFired{
    self.labTime.text = [NSString stringWithFormat:@"receive %lds",self.timeCount];
    self.timeCount -= 1;
    if (self.timeCount == 0) {
        [self hide];
        [self.timer invalidate];
        self.timer = nil;
    }
}



// 关闭
- (void)clickCloseBtnEvnet{
    [self.timer invalidate];
    self.timer = nil;
    [self hide];
}



- (void)show{
    self.timeCount = 10;
    self.labTime.text = [NSString stringWithFormat:@"receive %lds",self.timeCount];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.anchorUserInfo.headFileName]];
    self.hidden = NO;
    [self startTimer];
}




- (void)hide{
    self.hidden = YES;
    if (self.clickCloseBlock) {
        self.clickCloseBlock();
    }
}





// 接收
- (void)clicktakeOverBtnEvnet{
    [self hide];
    
    if (self.clickReceiveBlock) {
        self.clickReceiveBlock();
    }
}




- (UIImageView *)headImageView{
    if (!_headImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage jl_name:@"" class:self];
        view.layer.cornerRadius = 40;
        view.layer.borderWidth = 2;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.clipsToBounds = YES;
        _headImageView = view;
    }
    return  _headImageView;
}




- (UILabel *)textLab{
    if (!_textLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor blackColor];
        view.text = @"The other party invites you to interact with toys.";
        view.font = [UIFont systemFontOfSize:14];
        view.textAlignment = UITextAlignmentLeft;
        view.lineBreakMode = NSLineBreakByCharWrapping;
        view.numberOfLines = 2;
        view.clipsToBounds = YES;
        _textLab = view;
    }
    return  _textLab;
}




- (UIButton *)closeBtn{
    if (!_closeBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setImage:[UIImage jl_name:@"jl_close_gray1" class:self] forState:UIControlStateNormal];
        view.layer.cornerRadius = 8;
        [view addTarget:self action:@selector(clickCloseBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        view.clipsToBounds = YES;
        _closeBtn = view;
    }
    return  _closeBtn;
}





- (UIButton *)takeOverBtn{
    if (!_takeOverBtn) {
        UIButton *view = [[UIButton alloc] init];
//        view.backgroundColor = [UIColor colorWithHexString:@"#FE006B"];
        [view setBackgroundImage:[UIImage jl_name:@"jl_button_bg" class:self] forState:UIControlStateNormal];
        [view setTitle:@"" forState:UIControlStateNormal];
        view.layer.cornerRadius = 12;
        [view addTarget:self action:@selector(clicktakeOverBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        view.clipsToBounds = YES;
        _takeOverBtn = view;
    }
    return  _takeOverBtn;
}




- (UIImageView *)imgIcon{
    if (!_imgIcon) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage jl_name:@"invite_icon" class:self];
        _imgIcon = view;
    }
    return  _imgIcon;
}


- (UILabel *)labTime{
    if (!_labTime) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor whiteColor];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:14];
        view.clipsToBounds = YES;
        _labTime = view;
    }
    return  _labTime;
}





@end

    //
    //  RemoteView.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/19.
    //

#import "LocalView.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JLUserService.h"


@interface  LocalView()


@property (nonatomic, strong) UIView *headView;

//@property (nonatomic, strong) UIImageView *microPhoneImageView;

@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation LocalView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}



- (void)creatUI{
        
    [self addSubview:self.contentView];
    [self addSubview:self.headView];
    [self.headView addSubview:self.headImageView];
//    [self addSubview:self.microPhoneImageView];
    
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(72, 72));
        make.center.equalTo(self);
    }];
    
    
//    [self.microPhoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_offset(CGSizeMake(32, 32));
//        make.left.equalTo(self).offset(8);
//        make.bottom.equalTo(self).offset(-8);
//    }];
    
//    self.microPhoneImageView.hidden = YES;

    
    JLUserModel *userInfo = [JLUserService shared].userInfo;
    
    self.headView.hidden = YES;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.headFileName]];
}





- (void)stopHeadView{
    self.headView.hidden = YES;
    [self.headView sendSubviewToBack:self];
}




- (void)startHeadView{
    self.headView.hidden = NO;
    [self.headView bringSubviewToFront:self];
}




//- (void)startMicroPhone{
//    self.microPhoneImageView.hidden = YES;
//}


//- (void)stopMicroPhone{
//    self.microPhoneImageView.hidden = NO;
//}




- (UIView *)contentView{
    if (!_contentView) {
        UIView *view = [[UIView alloc] init];
        _contentView = view;
    }
    return  _contentView;
}




- (UIView *)headView{
    if (!_headView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        _headView = view;
    }
    return  _headView;
}





- (UIImageView *)headImageView{
    if (!_headImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.layer.cornerRadius = 72/2.0;
        view.layer.masksToBounds = YES;
        _headImageView = view;
    }
    return  _headImageView;
}





//- (UIImageView *)microPhoneImageView{
//    if (!_microPhoneImageView) {
//        UIImageView *view = [[UIImageView alloc] init];
//        view.image = [UIImage imageNamed:@"jl_microphone_no"];
//        _microPhoneImageView = view;
//    }
//    return  _microPhoneImageView;
//}


@end

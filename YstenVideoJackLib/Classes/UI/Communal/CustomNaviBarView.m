//
//  CustomNaviBarView.m
//  ZP_POP
//
//  Created by dfb－yong on 2018/5/15.
//  Copyright © 2018年 yong. All rights reserved.
//

#import "CustomNaviBarView.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import "UIImage+Add.h"

#define kRightMargin 12
#define FontNaviBar_ItemText [UIFont systemFontOfSize:13]

@interface CustomNaviBarView ()

@end


@implementation CustomNaviBarView


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupViews];
        [self setupCostranins];
        
        
    }
    return self;
}

- (void) buttonClickAction:(UIButton *)bt {
    
    if (self.clickBackBtnEvent) {
        self.clickBackBtnEvent();
    }
    
}


- (void) buttonClickRightAction:(UIButton *)bt {
    
    if (self.clickRightBtnEvent) {
        self.clickRightBtnEvent();
    }
    
}



- (void)setIsTransparentNavBar:(BOOL)isTransparentNavBar
{
    self.alpha = isTransparentNavBar ? 0.f : 1.f;
}

//-(void)setTitleNavBar:(NSString *)titleNavBar {
//    self.titleLabel.text = titleNavBar;
//}

-(void)setIsHidenNavBarLine:(BOOL)isHidenNavBarLine
{
    self.lienView.hidden = isHidenNavBarLine;
}

///设置左侧第一个按钮为返回按钮
- (void)setLeftFirstButtonWithImageName:(NSString *)imageName{
    
    self.backButton.hidden = NO;
    UIImage *image = [UIImage imageNamed:imageName];
    [self.backButton setImage:image forState:UIControlStateNormal];
}

///设置左侧第一个按钮
- (void)setLeftFirstButtonWithTitleName:(NSString *)titleName{
    
    self.backButton.hidden = NO;
    //_leftFirstBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.backButton setTitle:titleName forState:UIControlStateNormal];
}

///设置右侧第一个按钮显示图片
- (void)setRightFirstButtonWithImageName:(NSString *)imageName{
    
    self.rightFirstBtn.hidden = NO;
    UIImage *image = [UIImage jl_name:imageName class:self];
    [self.rightFirstBtn setImage:image forState:UIControlStateNormal];

    float w = 20;
    if (image) {
        w = image.size.width;
    }
    w  = w+kRightMargin*2;
    

 __weak __typeof(&*self)ws = self;
    [self.rightFirstBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right).offset(-10);
        make.centerY.equalTo(ws.backButton.mas_centerY);
        make.height.equalTo(ws.backButton.mas_height).offset(0);
        make.width.equalTo(@(w));
    }];
    
}


///设置右侧第一个按钮显示文字
- (void)setRightFirstButtonWithTitleName:(NSString *)titleName {
    
//    if (StrIsNotNull(titleName)) {
        titleName = [NSString stringWithFormat:@" %@ ",titleName];
//    }
    
    self.rightFirstBtn.hidden = NO;
    //_rightFirstBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.rightFirstBtn setTitle:titleName forState:UIControlStateNormal];
    
    __weak __typeof(&*self)ws = self;
    [self.rightFirstBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right).offset(-kRightMargin);
        make.centerY.equalTo(ws.backButton.mas_centerY);
        make.height.equalTo(ws.backButton.mas_height).offset(0);
    }];
    
}

///设置右侧第一个按钮【选中状态】文字
- (void)setRightFirstButtonWithSelectedStateTitleName:(NSString *)titleName {
    
//    if (StrIsNotNull(titleName)) {
        titleName = [NSString stringWithFormat:@" %@ ",titleName];
//    }
    
    self.rightFirstBtn.hidden = NO;
    [self.rightFirstBtn setTitle:titleName forState:UIControlStateSelected];
    __weak __typeof(&*self)ws = self;
    [self.rightFirstBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right).offset(-kRightMargin);
        make.centerY.equalTo(ws.backButton.mas_centerY);
        make.height.equalTo(ws.backButton.mas_height).offset(0);
    }];
}


///设置右侧第二个按钮显示图片
- (void)setRightSecondButtonWithImageName:(NSString *)imageName{
    
    _rightSecondBtn.hidden = NO;
    UIImage *image = [UIImage imageNamed:imageName];
    [_rightSecondBtn setImage:image forState:UIControlStateNormal];
    
    float w = 20;
    if (image) {
        w = image.size.width;
    }
    w  = w+kRightMargin*2;
    
    __weak __typeof(&*self)ws = self;
    [self.rightSecondBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.rightFirstBtn.mas_left).offset(0);
        make.centerY.equalTo(ws.backButton.mas_centerY);
        make.height.equalTo(ws.backButton.mas_height).offset(0);
        make.width.equalTo(@(w));
    }];
    
}

///设置右侧第二个按钮显示文字
- (void)setRightSecondButtonWithTitleName:(NSString *)titleName{
    
//    if (StrIsNotNull(titleName)) {
        titleName = [NSString stringWithFormat:@" %@ ",titleName];
//    }
    
    _rightSecondBtn.hidden = NO;
    //_rightSecondBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [_rightSecondBtn setTitle:titleName forState:UIControlStateNormal];
    
    __weak __typeof(&*self)ws = self;
    [self.rightSecondBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.rightFirstBtn.mas_left).offset(-15);
        make.centerY.equalTo(ws.rightFirstBtn.mas_centerY);
        make.height.equalTo(ws.backButton.mas_height).offset(0);
        //make.width.equalTo(ws.backButton.mas_height).offset(0);
    }];
}


- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}


- (void) setupViews {
    
    [self addSubview:self.lienView ];
    [self addSubview:self.backButton ];
    [self addSubview:self.titleLabel ];
    [self addSubview:self.rightFirstBtn ];
    [self addSubview:self.rightSecondBtn ];
    
}

- (void) setupCostranins {
    
    __weak __typeof(&*self)ws = self;
    
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(15));
        make.centerY.equalTo(self);
        make.height.width.equalTo(@32);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
//        make.centerX.equalTo(ws.mas_centerX);
//        make.centerY.equalTo(ws.backButton.mas_centerY);
//        make.height.equalTo(ws.backButton.mas_height);
//        make.width.lessThanOrEqualTo(@(kScreenWidth-80*2));
    }];
    
    
    
    [self.rightFirstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(ws.mas_right).offset(-kRightMargin);
        make.centerY.equalTo(ws.backButton.mas_centerY);
        make.height.width.equalTo(ws.backButton.mas_height).offset(0);
    }];
    
    
    [self.rightSecondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(ws.rightFirstBtn.mas_left).offset(-2);
        make.centerY.equalTo(ws.rightFirstBtn.mas_centerY);
        make.height.width.equalTo(ws.backButton.mas_height).offset(0);
    }];
    
    
    //
    [self.lienView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@(0));
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(ws.mas_bottom);
        
    }];
    
}


-(UIView *) lienView
{
    if (!_lienView)
    {
        _lienView = [[UIView alloc]init];
        _lienView.backgroundColor = [UIColor colorWithHexString:@"#dfdfdf"];
        _lienView.hidden = YES;
        
    }
    return _lienView;
}

-(UIButton *) backButton
{
    if (!_backButton)
    {
        UIButton *  _leftButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _leftButton.backgroundColor = [UIColor clearColor];
        [_leftButton setImage:[UIImage jl_name:@"jl_navBackBlackIcon" class:self] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage jl_name:@"jl_navBackBlackIcon" class:self] forState:UIControlStateHighlighted];
        [_leftButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
//        _leftButton.tag = CustomNaviBarViewActionType_Back;
        //_leftButton.hidden = YES;
        _backButton = _leftButton;
    }
    return _backButton;
}

-(UILabel *) titleLabel
{
    if (!_titleLabel)
    {
        UIFont *font = [UIFont boldSystemFontOfSize:18.0f];
        _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = font;
        //_titleLabel.hidden = YES;
    }
    return _titleLabel;
}


-(UIButton *)rightFirstBtn {
    
    if (!_rightFirstBtn) {
        //右侧第一个按钮_rightFirstBtn
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.exclusiveTouch = YES;
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = FontNaviBar_ItemText;
        [btn setTitleColor:@"" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClickRightAction:) forControlEvents:UIControlEventTouchUpInside];
//        btn.tag = CustomNaviBarViewActionType_RightFirst;
        btn.hidden = YES;
        
        _rightFirstBtn = btn;
    }
    return _rightFirstBtn;
}



-(UIButton *)rightSecondBtn {
    
    if (!_rightSecondBtn) {
        
        //右侧第一个按钮_rightFirstBtn
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.exclusiveTouch = YES;
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = FontNaviBar_ItemText;
        [btn setTitleColor:@"" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClickRightAction:) forControlEvents:UIControlEventTouchUpInside];
//        btn.tag = CustomNaviBarViewActionType_RightSecond;
        btn.hidden = YES;
        
        _rightSecondBtn = btn;
    }
    return _rightSecondBtn;
}

@end


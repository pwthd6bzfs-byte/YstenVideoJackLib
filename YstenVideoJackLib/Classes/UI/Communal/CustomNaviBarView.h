//
//  CustomNaviBarView.h
//  ZP_POP
//
//  Created by dfb－yong on 2018/5/15.
//  Copyright © 2018年 yong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNaviBarView : UIView


@property(nonatomic,strong) UIView *lienView;

/** 返回按钮 左侧第一个按钮 **/
@property(nonatomic,strong) UIButton *backButton;

@property(nonatomic,strong) UILabel *titleLabel;

/** 右侧第一个按钮 */
@property (nonatomic, strong)UIButton *rightFirstBtn;

/** 右侧第二个按钮 */
@property (nonatomic, strong)UIButton *rightSecondBtn;

///** 右侧倒数第三个按钮 */
//@property (nonatomic, strong)UIButton *rightThreeBtn;


//@property(nonatomic,strong) NSString *titleNavBar;

/*!
 *  @brief  是否使导航栏透明
 */
@property(nonatomic,assign) BOOL isTransparentNavBar;

/*!
 *  @brief  是否隐藏导航栏上的线
 */
@property(nonatomic,assign) BOOL isHidenNavBarLine;

@property (nonatomic, strong) void(^clickBackBtnEvent)();

@property (nonatomic, strong) void(^clickRightBtnEvent)();


#pragma mark - 常规设置按钮
///设置左侧第一个按钮为返回按钮
- (void)setLeftFirstButtonWithImageName:(NSString *)imageName;

///设置左侧第一个按钮显示文字
- (void)setLeftFirstButtonWithTitleName:(NSString *)titleName;

///设置右侧第一个按钮显示图片
- (void)setRightFirstButtonWithImageName:(NSString *)imageName;

///设置右侧第一个按钮显示文字
- (void)setRightFirstButtonWithTitleName:(NSString *)titleName;
///设置右侧第一个按钮【选中状态】文字
- (void)setRightFirstButtonWithSelectedStateTitleName:(NSString *)titleName;

///设置右侧第二个按钮显示图片
- (void)setRightSecondButtonWithImageName:(NSString *)imageName;

///设置右侧第二个按钮显示文字
- (void)setRightSecondButtonWithTitleName:(NSString *)titleName;


- (void)setTitle:(NSString *)title;
@end

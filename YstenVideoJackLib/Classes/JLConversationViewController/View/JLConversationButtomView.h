//
//  JLConversationButtomView.h
//  Pods
//
//  Created by percent on 2026/1/9.
//

#import <UIKit/UIKit.h>
#import <RongIMLibCore/RongIMLibCore.h>
#import "RCInputContainerView.h"
//#import "YstenVideoJackLib-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JLInputContainerViewDelegate <NSObject>

- (void)inputContainerView:(UIView *)inputContainerView forControlEvents:(UIControlEvents)controlEvents;

@end



@interface JLConversationButtomView : UIView


@property (nonatomic, weak) id<JLInputContainerViewDelegate> delegate;

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *recordBtn;

@property (nonatomic, strong) UITextField *contentTxf;

@property (nonatomic, strong) UIButton *sendBtn;


@property (nonatomic, strong) UIButton *photoBtn;

@property (nonatomic, strong) UIButton *emojiBtn;

@property (nonatomic, strong) UIButton *telBtn;

@property (nonatomic, strong) UIButton *giftBtn;

@property (nonatomic, strong) UIButton *deviceBtn;



@property (nonatomic,copy) void (^clickLeftBlock)(BOOL);

@property (nonatomic,copy) void (^clickSendBlock)(void);

@property (nonatomic,copy) void (^clickPhotoBlock)(void);

@property (nonatomic,copy) void (^clickEmojiBlock)(void);

@property (nonatomic,copy) void (^clickTelBlock)(void);

@property (nonatomic,copy) void (^clickGiftBlock)(void);

@property (nonatomic,copy) void (^clickDeviceBlock)(void);



// 添加设备UI
- (void)addDeviceLayout;

@end




NS_ASSUME_NONNULL_END

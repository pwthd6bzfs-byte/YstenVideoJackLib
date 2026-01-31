    //
    //  JLConversationButtomView.h
    //  Pods
    //
    //  Created by percent on 2026/1/9.
    //

#import <UIKit/UIKit.h>
#import <RongIMLibCore/RongIMLibCore.h>
NS_ASSUME_NONNULL_BEGIN


@interface VideoViewButtomView : UIButton


@property (nonatomic, strong) UITextField *contentTxf;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) UIButton *reverseBtn;

@property (nonatomic, strong) UIButton *cameraBtn;

@property (nonatomic, strong) UIButton *microphoneBtn;

//@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIButton *emojiBtn;

@property (nonatomic, strong) UIButton *giftBtn;




@property (nonatomic,copy) void (^clickSendBlock)(void);

@property (nonatomic,copy) void (^clickReverseBtnBlock)(void);

@property (nonatomic,copy) void (^clickCameraBtnBlock)(BOOL);

@property (nonatomic,copy) void (^clickMicroPhoneBtnBlock)(BOOL);

@property (nonatomic,copy) void (^clickEmojiBlock)(void);

@property (nonatomic,copy) void (^clickGiftBlock)(void);



- (void)showKeyboardUI;

- (void)hideKeyboardUI;




@end




NS_ASSUME_NONNULL_END

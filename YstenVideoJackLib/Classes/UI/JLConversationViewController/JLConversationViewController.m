//
//  JLConversationViewController.m
//  JuliFrameworkDemo
//
//  Created by percent on 2026/1/5.
//

#import "JLConversationViewController.h"
#import "SVProgressHUD.h"
#import "RCTextMessageCell.h"
#import "JLConversationButtomView.h"
#import "JLEmojiView.h"
#import "RCAlumListTableViewController.h"
#import "VideoViewController.h"
#import "RCConversationVCUtil.h"
#import "RCVoiceRecordControl.h"
#import "JLGiftListModel.h"
#import "JLPopupViewComponent.h"
#import "JLSVGAQueueManager.h"
#import "JLCustomMessage.h"
#import "JLGiftMessageCell.h"
#import "JLAskGiftMessageCell.h"
#import "JLPrivatePhotoMessageCell.h"
#import "JLVideoMessageCell.h"
#import "JLAnchorUserModel.h"
#import "JLUserService.h"
#import "JLAPIService.h"
#import "JLRTCService.h"
#import "JLIMService.h"
#import "JLUserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIColor+HexColor.h"
#import <Masonry/Masonry.h>
#import "Config.h"
#import "CustomNaviBarView.h"
#import <RongCloudOpenSource/RongIMKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Add.h"
#import "UIImage+Add.h"



@interface JLConversationViewController ()<RCMessageBlockDelegate,RCAlbumListViewControllerDelegate,JLInputContainerViewDelegate,RCVoiceRecordControlDelegate,SVGAPlayerDelegate>


#define ButtomView_Height (112+34)

// 自定义导航栏
@property (nonatomic, strong) CustomNaviBarView *customNaviBarView;
/// 自定义底部区域
@property (nonatomic, strong) JLConversationButtomView *buttomView;
/// 表情区域
@property (nonatomic, strong) JLEmojiView *emojiView;
/// 键盘弹出蒙层
@property (nonatomic, strong) UIButton *keyboardMaskView;
/// 关注按钮
@property (nonatomic, strong) UIButton *followBtn;
/// 列表距顶部偏移量
@property (nonatomic, assign) CGFloat conversationViewFrameY;
/// 列表高度
@property (nonatomic, assign) CGFloat heihgt;
/// 判断点击表情按钮
@property (nonatomic, assign) BOOL isClickEmoji;
/// 语音控制
@property (nonatomic, strong) RCVoiceRecordControl *voiceRecordControl;

@property (nonatomic, strong) RCConversationVCUtil *util;

/// 礼物svga
@property (nonatomic, strong) SVGAPlayer *svgaPlayer;
/// 礼物管理器
@property (nonatomic, strong) JLSVGAQueueManager *queueManager;

/// 主播信息详情
@property (nonatomic, strong) JLAnchorUserModel *anchorUserInfo;

// 数据源
@property (nonatomic, strong) JLGiftListModel *model;

@end

@implementation JLConversationViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"JLConversationViewController 销毁");
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /// 消息拦截监听代理
    [RCCoreClient sharedCoreClient].messageBlockDelegate = self;
    self.isClickEmoji = NO;
    self.displayUserNameInCell = NO;
    self.chatSessionInputBarControl.hidden = YES;
    [self requestData];
    [self requestUserCoinComplete:nil];
    [self addSubViews];
    [self setupLayouts];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // 更新某条消息状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rcMessageUpdateSuccess)
                                                 name:kNotificationRcMessageUpdateSuccess object:nil];

    // 回赠礼物
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendAskGiftMessge:)
                                                 name:kNotificationAskGiftSuccess object:nil];
}


    // 注册自定义消息和cell
- (void)registerCustomCellsAndMessages {
    [super registerCustomCellsAndMessages];
    [self registerClass:[JLGiftMessageCell class] forMessageClass:[JLGiftMessage class]];
    [self registerClass:[JLAskGiftMessageCell class] forMessageClass:[JLAskGiftMessage class]];
    [self registerClass:[JLVideoMessageCell class] forMessageClass:[JLVideoMessage class]];
    [self registerClass:[JLPrivatePhotoMessageCell class] forMessageClass:[JLMediaPrivateMessage class]];

}


- (void)addSubViews{
    __weak __typeof(self)weakSelf = self;

        // 将其添加到父视图
    [self.view addSubview:self.customNaviBarView];
    self.customNaviBarView.backgroundColor = [UIColor clearColor];
    self.customNaviBarView.clickBackBtnEvent = ^{
        weakSelf.navigationController.navigationBarHidden = NO;
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.customNaviBarView setRightFirstBtn:self.followBtn];
    [self.customNaviBarView addSubview:self.followBtn];
    [self.followBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.customNaviBarView);
        make.right.equalTo(self.customNaviBarView).offset(-16);
        make.size.mas_offset(CGSizeMake(80, 32));
    }];
    
    
    [self.customNaviBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kStatusBarHeight);
    }];

    
    
    [self.view addSubview:self.keyboardMaskView];
    [self.view addSubview:self.buttomView];
    [self.view addSubview:self.emojiView];
    self.util = [[RCConversationVCUtil alloc] init:self];
    
    
    // 点击发送消息
    self.buttomView.clickSendBlock = ^{
        if (weakSelf.buttomView.contentTxf.text.length <= 0){
            [SVProgressHUD showImage:nil status:@"The content cannot be empty."];
            return;
        }
        
//        if ([self sendReferenceMessage:self.chatSessionInputBarControl.inputTextView.text]) {
//            return;
//        }
                
        RCTextMessage *textMessage = [[RCTextMessage alloc] init];;
        textMessage.content = weakSelf.buttomView.contentTxf.text;
        
        RCMessage *message = [[RCMessage alloc] init];
        message.targetId = weakSelf.targetId;
        message.content = textMessage;
        message.messageDirection = MessageDirection_SEND;
        message.senderUserId = [NSString stringWithFormat:@"%ld",[JLUserService shared].userInfo.userID];
        message.conversationType = ConversationType_PRIVATE;
        
        
        [[RCIM sharedRCIM] sendMessage:message pushContent:nil pushData:nil successBlock:^(RCMessage * _Nonnull successMessage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view endEditing:YES];
                weakSelf.buttomView.contentTxf.text = @"";
                    // 更新金币
                [weakSelf requestUserCoinComplete:nil];
            });
            NSLog(@"%@",successMessage);
        } errorBlock:^(RCErrorCode nErrorCode, RCMessage * _Nonnull errorMessage) {
            NSLog(@"%@",errorMessage);
        }];
    };

    
    
    Weakself(ws)
        // 点击左按钮
    self.buttomView.clickLeftBlock = ^(BOOL result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 显示录音icon布局
            if (result == YES) {
                [ws hideKeyboard];
            }
        });
    };

    
    // 点击相册
    self.buttomView.clickPhotoBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view endEditing:YES];
            RCAlumListTableViewController *albumListVC = [[RCAlumListTableViewController alloc] init];
            albumListVC.delegate = ws;
            RCBaseNavigationController *rootVC = [[RCBaseNavigationController alloc] initWithRootViewController:albumListVC];
            rootVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [weakSelf presentViewController:rootVC animated:YES completion:^{
                
            }];
        });
    };

    
    // 点击表情按钮
    self.buttomView.clickEmojiBlock = ^{
        [weakSelf clickEmojiBtn];
    };

    
    // 点击通话视频
    self.buttomView.clickTelBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view endEditing:YES];
            [weakSelf sendVideoCall];
        });
    };

    
    // 点击礼物
    self.buttomView.clickGiftBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.view endEditing:YES];
            if (weakSelf.model) {
                [ws requestUserCoinComplete:^{
                    [JLPopupViewComponent popupTableiViewWithModel:weakSelf.model returnModel:^(JLGiftModel * _Nonnull model,NSString * _Nonnull num) {
                        [weakSelf sendGiftMessge:model num:num];
                    }];
                } isShowLoding:YES];
            }
        });
    };

    // 点击插入表情
    self.emojiView.clickSelectEmojiBlock = ^(NSString * string) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.buttomView.contentTxf insertText:string];
        });
    };
    
    
    // 点击删除表情
    self.emojiView.clickDelEmojiBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.buttomView.contentTxf deleteBackward];
        });
    };
    
    
        // 创建SVGA播放器
    self.svgaPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-34-112)];
    self.svgaPlayer.userInteractionEnabled = NO;
    [self.view addSubview:self.svgaPlayer];
    
        // 创建队列管理器
    self.queueManager = [[JLSVGAQueueManager alloc] initWithPlayer:self.svgaPlayer];
    
    
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.conversationDataRepository enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[RCMessageModel class]]) {
                RCMessage *message = (RCMessage *)obj;
                
                if ([message.content isKindOfClass:[JLMediaPrivateMessage class]]) {
                    JLMediaPrivateMessage *mediaPrivateMessage = (JLMediaPrivateMessage *)message.content;
                    
                        // 获取当前时间
                    NSDate *now = [NSDate date];
                        // 获取时间戳
                    NSTimeInterval seconds = [now timeIntervalSince1970];
                    
                        // 将秒转换为毫秒
                    long long currentTimeStamp = seconds * 1000;
                    NSInteger expirationTime = mediaPrivateMessage.expirationTime;
                    if (currentTimeStamp > expirationTime) {
                            // 过期
                        if (![message.extra isEqualToString:@"2"]) {
                            message.extra = @"2";
                            [[JLIMService shared] setMessageExtraStatus:@"2" messageId:message.messageId callback:^(BOOL result) {
                                NSLog(@"解锁私密状态更新成功 (过期)");
                            }];
                        }
                    }
                }
            }
        }];
    });
    
    [self rcMessageUpdateSuccess];
}



- (void)setupLayouts{
    
    CGFloat conversationViewFrameY = CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame) +
    CGRectGetMaxY(self.navigationController.navigationBar.bounds);
        
    CGFloat height =  (kScreenHeight - conversationViewFrameY - ButtomView_Height);
    self.heihgt = height;
    self.conversationViewFrameY = conversationViewFrameY;
    
    [self.conversationMessageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(self.conversationViewFrameY);
        make.left.mas_equalTo(self.view);
        make.width.offset(kScreenWidth);
        make.height.offset(height);
    }];
    
    [self.keyboardMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight));
    }];
    
    
    [self.buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.conversationMessageCollectionView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.offset(ButtomView_Height);
    }];
    
    
    [self.emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttomView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.height.equalTo(@300);
    }];

}



#pragma mark 事件方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}



// 空白区域回收键盘
- (void)hideKeyboard {
    if (self.isClickEmoji == YES){
        [self.conversationMessageCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(self.conversationViewFrameY);
            make.left.mas_equalTo(self.view);
            make.width.offset([UIScreen mainScreen].bounds.size.width);
            make.height.offset(self.heihgt);
        }];
        
        [self.buttomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(ButtomView_Height));
        }];
        
        self.keyboardMaskView.hidden = YES;
        [UIView animateWithDuration:0.03 animations:^{
            [self.view layoutIfNeeded];
                // 滚动最下方
            [self scrollToBottomAnimated:NO];
        }];
    }else{
        [self.view endEditing:YES];
    }
    
}




    // 键盘即将显示
- (void)keyboardWillShow:(NSNotification *)notification {
        // 获取键盘高度
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
        // 获取动画时长
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        // 获取动画曲线
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
        // 调整界面
    self.isClickEmoji = NO;
    self.emojiView.hidden = YES;
    self.keyboardMaskView.hidden = NO;
    
    
    [self.conversationMessageCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(self.conversationViewFrameY - keyboardHeight + 34);
        make.left.mas_equalTo(self.view);
        make.width.offset([UIScreen mainScreen].bounds.size.width);
        make.height.offset(self.heihgt);
    }];
    
    [self.buttomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@112);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [UIView setAnimationCurve:curve];
        [self.view layoutIfNeeded];
            // 滚动最下方
        [self scrollToBottomAnimated:NO];
    }];
}





    // 键盘即将隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (self.isClickEmoji == YES) {
        return;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
        // 调整界面
    self.emojiView.hidden = YES;
    self.keyboardMaskView.hidden = YES;
    [self.conversationMessageCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(self.conversationViewFrameY);
        make.left.mas_equalTo(self.view);
        make.width.offset([UIScreen mainScreen].bounds.size.width);
        make.height.offset(self.heihgt);
    }];
    
    [self.buttomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(ButtomView_Height));
    }];

    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
        
            // 滚动最下方
        [self scrollToBottomAnimated:NO];
    }];
}




    // 点击表情
- (void)clickEmojiBtn{
    self.isClickEmoji = YES;
    self.keyboardMaskView.hidden = NO;
    [self.view endEditing:YES];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    view.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.emojiView.hidden = NO;
    [self.conversationMessageCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(self.conversationViewFrameY-300+34);
        make.left.mas_equalTo(self.view);
        make.width.offset([UIScreen mainScreen].bounds.size.width);
        make.height.offset(self.heihgt);
    }];
    
    [self.buttomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(112));
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
            // 滚动最下方
        [self scrollToBottomAnimated:NO];
    }];
    
}



// 请求接口数据
- (void)requestData{
    
    Weakself(ws)
        // 获取礼物列表
    [JLAPIService getGiftListInfoWithGiftType:@"" Success:^(NSDictionary * _Nonnull result) {
        NSArray *array = [NSArray modelArrayWithClass:[JLGiftListModel class] json:result[@"data"]];
        if ([array count] > 0) {
            ws.model = array[0];
        }
    } failued:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
    RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:self.targetId];
    
    if (userInfo) {
        [self.customNaviBarView setTitle:userInfo.name];
    }
    
    // 获取主播详情信息
    [JLAPIService getAnchorDetailInfo:[self.targetId integerValue] userCode:@"" success:^(NSDictionary * _Nonnull result) {
        NSLog(@"%@",result);
        
        JLAnchorUserModel *newUserInfo = [JLAnchorUserModel modelWithJSON:result[@"data"]];
        ws.anchorUserInfo = newUserInfo;
        
        ws.followBtn.hidden = NO;
        if ([ws.anchorUserInfo.followFlag isEqualToString:@"1"]) {
            ws.followBtn.selected = YES;
            ws.followBtn.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
        }else{
            ws.followBtn.selected = NO;
            ws.followBtn.backgroundColor = [UIColor colorWithHexString:@"#D6007E"];
        }
        [ws.customNaviBarView setTitle:newUserInfo.nickName];
        
        RCUserInfo *info = [RCUserInfo new];
        info.name = newUserInfo.nickName;
        info.portraitUri = newUserInfo.headFileName;
        info.userId = [NSString stringWithFormat:@"%ld",(long)newUserInfo.userID];
        [[RCIM sharedRCIM] refreshUserInfoCache:info withUserId:info.userId];
        
    } failued:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}




// 点击用户头像
- (void)didTapCellPortrait:(NSString *)userId{
    if ([JLIMService shared].delegate && [[JLIMService shared].delegate respondsToSelector:@selector(pushPresonCenter:)]) {
        [[JLIMService shared].delegate pushPresonCenter:userId];
    }
}





// 点击关注
- (void)clickFollowBtnEvnet{
    Weakself(ws);
    
    if (self.followBtn.selected == YES) {
        [SVProgressHUD show];
            // 获取主播详情信息
        [JLAPIService cancelFollowWithAnchorID:[self.targetId integerValue] success:^(NSDictionary * _Nonnull result) {
            NSLog(@"%@",result);
            NSLog(@"取关成功");
            [SVProgressHUD dismiss];
                //        [SVProgressHUD showImage:nil status:@"关注成功"];
            ws.followBtn.selected = NO;
            ws.followBtn.backgroundColor = [UIColor colorWithHexString:@"#D6007E"];
        } failued:^(NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];
        }];

    }else{
        [SVProgressHUD show];
            // 获取主播详情信息
        [JLAPIService addFollowWithAnchorID:[self.targetId integerValue] success:^(NSDictionary * _Nonnull result) {
            NSLog(@"%@",result);
            NSLog(@"关注成功");
                //        [SVProgressHUD showImage:nil status:@"关注成功"];
            ws.followBtn.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
            [SVProgressHUD dismiss];
            ws.followBtn.selected = YES;
        } failued:^(NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            NSLog(@"%@",error);
        }];
    }
}







    // 查询金币
- (void)requestUserCoinComplete:(void(^)(void))completBlock{
    [self requestUserCoinComplete:completBlock isShowLoding:NO];
}




- (void)requestUserCoinComplete:(void(^)(void))completBlock isShowLoding:(BOOL)isShowLoding{
    Weakself(ws)
    if (isShowLoding == YES) {
        [SVProgressHUD show];
    }
    
    [[JLUserService shared] getUserCoinSuccess:^(NSDictionary * _Nonnull result) {
        NSNumber *coins = result[@"data"][@"coins"];
        [JLUserService shared].userInfo.coins = [coins integerValue];
        
        if (isShowLoding == YES) {
            [SVProgressHUD dismiss];
        }
        
        if (completBlock) {
            completBlock();
        }
    } failued:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
        if (isShowLoding == YES) {
            [SVProgressHUD dismiss];
        }
    }];
}



    // 添加svga动画url
- (void)addSvgaUrl:(NSString *)giftSvgaUrl{
    
    Weakself(ws)
        // 从网络加载动画
    NSURL *url = [NSURL URLWithString:giftSvgaUrl];
    [ws.queueManager enqueueAnimationWithURL:url
                                       loops:1
                                  completion:^(BOOL success) {
        NSLog(@"网络动画播放完成: %@", success ? @"成功" : @"失败");
    }];
    
}






    // 回赠礼物
- (void)sendAskGiftMessge:(NSNotification *)notification{
    
    
    id passedObject = notification.object;
    NSDictionary *askGiftMessageDict = passedObject;
    JLAskGiftMessage *askGiftMessage = [JLAskGiftMessage modelWithDictionary:askGiftMessageDict];
    //    Weakself(ws)
//    JLUserModel *userInfo = [JLUserService shared].userInfo;
//    
//    
//        // Type 2 发送礼物
//    JLGiftMessage *giftMessage = [JLGiftMessage messageWithType:@"2" channelId:askGiftMessage.channelId giftId:askGiftMessage.giftId giftCode:askGiftMessage.giftCode userId:@(userInfo.userID) userCategory:[JLUserService shared].userInfo.userCategory giveNum:giveNum nickName:[JLUserService shared].userInfo.nickName userRole:askGiftMessage.userRole giftUrl:askGiftMessage.giftUrl giftName:askGiftMessage.giftName giftPrice:askGiftMessage.giftPrice giftSvgaUrl:askGiftMessage.giftSvgaUrl];
//    
//    RCMessage *message = [[RCMessage alloc] init];
//    message.targetId = [NSString stringWithFormat:@"%@",self.targetId];
//    message.content = giftMessage;
//    message.messageDirection = MessageDirection_SEND;
//    
//    message.senderUserId = [NSString stringWithFormat:@"%ld",userInfo.userID];
//    message.conversationType = ConversationType_PRIVATE;
//    
//    
//    JLGiftModel *giftModel = [[JLGiftModel alloc] init];
//    giftModel.giftSvgaUrl = giftMessage.giftSvgaUrl;
//    giftModel.giftName = giftMessage.giftName;
//    
//    
//    [SVProgressHUD show];
//    [[RCIM sharedRCIM] sendMessage:message pushContent:nil pushData:NULL successBlock:^(RCMessage * _Nonnull successMessage) {
//        NSLog(@"%@",successMessage);
//        [SVProgressHUD dismiss];
//        [ws addSvgaUrl:askGiftMessage.giftSvgaUrl];
//    } errorBlock:^(RCErrorCode nErrorCode, RCMessage * _Nonnull errorMessage) {
//        [SVProgressHUD dismiss];
//        NSLog(@"%@",errorMessage);
//    }];
    
    Weakself(ws)
    NSString *giveNum = @"1";
    if ([askGiftMessage.giveNum integerValue] > 0){
        giveNum = askGiftMessage.giveNum;
    }

    
    [SVProgressHUD show];
    [JLUserService sendGiftInfoWithAnchorId:[self.targetId integerValue] channelId:@"" giftId:askGiftMessage.giftId giveNum:giveNum success:^(NSDictionary * _Nonnull result) {
        [SVProgressHUD dismiss];
        [ws requestUserCoinComplete:nil];
        [ws addSvgaUrl:askGiftMessage.giftSvgaUrl];
    } failued:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];

}




    // 发送礼物
- (void)sendGiftMessge:(JLGiftModel *)model num:(NSString *)num{
    
//    JLUserModel *userInfo = [JLUserService shared].userInfo;
//        // Type 2 发送礼物
//    JLGiftMessage *giftMessage = [JLGiftMessage messageWithType:@"2" channelId:@"" giftId:model.ID giftCode:model.giftCode userId:@(userInfo.userID) userCategory:[JLUserService shared].userInfo.userCategory giveNum:num nickName:[JLUserService shared].userInfo.nickName userRole:@"" giftUrl:model.giftIcon giftName:model.giftName giftPrice:model.giftPrice giftSvgaUrl:model.giftSvgaUrl];
//    
//    RCMessage *message = [[RCMessage alloc] init];
//    message.targetId = [NSString stringWithFormat:@"%@",self.targetId];
//    message.content = giftMessage;
//    message.messageDirection = MessageDirection_SEND;
//    
//    message.senderUserId = [NSString stringWithFormat:@"%ld",userInfo.userID];
//    message.conversationType = ConversationType_PRIVATE;
//    
//    
//    JLGiftModel *giftModel = [[JLGiftModel alloc] init];
//    giftModel.giftSvgaUrl = giftMessage.giftSvgaUrl;
//    giftModel.giftName = giftMessage.giftName;
//    
//    [SVProgressHUD show];
//    Weakself(ws)
//    [[RCIM sharedRCIM] sendMessage:message pushContent:nil pushData:NULL successBlock:^(RCMessage * _Nonnull successMessage) {
//        NSLog(@"%@",successMessage);
//        [SVProgressHUD dismiss];
//        [ws addSvgaUrl:model.giftSvgaUrl];
//    } errorBlock:^(RCErrorCode nErrorCode, RCMessage * _Nonnull errorMessage) {
//        NSLog(@"%@",errorMessage);
//        [SVProgressHUD dismiss];
//    }];
    
    Weakself(ws)
    [SVProgressHUD show];
    [JLUserService sendGiftInfoWithAnchorId:[self.targetId integerValue] channelId:@"" giftId:model.ID giveNum:num success:^(NSDictionary * _Nonnull result) {
        [SVProgressHUD dismiss];
        [ws requestUserCoinComplete:nil];
        [ws addSvgaUrl:model.giftSvgaUrl];
    } failued:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}





// 更新某条消息状态
- (void)rcMessageUpdateSuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conversationMessageCollectionView reloadData];
    });
}




/// 拨打视频
- (void)sendVideoCall{
    
    // 访问摄像头权限
    [self checkAndRequestCameraPermission];
        
//    Weakself(ws)
//        // 拨打视频
//    [[JLRTCService shared] videoCallWithAnchorID:[self.targetId integerValue] success:^(NSString * _Nonnull channel, NSString * _Nonnull token) {
//        VideoViewController *controller = [[VideoViewController alloc] init];
//        controller.modalPresentationStyle = 0;
//        controller.channel = channel;
//        controller.token = token;
//        controller.isNeedPush = YES;
//        controller.anchorID = [self.targetId integerValue];
//        controller.anchorRtcToken = @"";
//        controller.anchorUserInfo = ws.anchorUserInfo;
//        [self presentViewController:controller animated:YES completion:nil];
//        
//    } failued:^(NSError * _Nonnull error) {
//        
//    }];
}



- (void)startUsingCamera{
    Weakself(ws)
        // 拨打视频
    [[JLRTCService shared] videoCallWithAnchorID:[self.targetId integerValue] success:^(NSString * _Nonnull channel, NSString * _Nonnull token,JLAnchorUserModel * _Nonnull anchorUserInfo) {
        
        JLUserModel *userInfo = [[JLUserService shared] userInfo];
        if (userInfo.coins < ws.anchorUserInfo.coinVideoPrice) {
            return [SVProgressHUD showInfoWithStatus:@"你的金币不足"];
        }

        
        VideoViewController *controller = [[VideoViewController alloc] init];
        controller.modalPresentationStyle = 0;
        controller.channel = channel;
        controller.token = token;
        controller.isNeedPush = YES;
        controller.anchorID = [ws.targetId integerValue];
        controller.anchorRtcToken = @"";
        controller.anchorUserInfo = anchorUserInfo;
        [ws presentViewController:controller animated:YES completion:nil];
        
    } failued:^(NSError * _Nonnull error) {
        
    }];
}




#pragma mark 代理方法
// 选择相册回调代理
- (void)albumListViewController:(RCAlumListTableViewController *)albumListViewController
                 selectedImages:(NSArray *)selectedImages
                isSendFullImage:(BOOL)enable{
    [self.util doSendSelectedMediaMessage:selectedImages fullImageRequired:NO];
}





// 语音按钮回调代码
- (void)inputContainerView:(UIView *)inputContainerView forControlEvents:(UIControlEvents)controlEvents{
    switch (controlEvents) {
        case UIControlEventTouchDown: {
            [self.voiceRecordControl onBeginRecordEvent];
        } break;
        case UIControlEventTouchUpInside: {
            [self.voiceRecordControl onEndRecordEvent];
        } break;
        case UIControlEventTouchDragExit: {
            [self.voiceRecordControl dragExitRecordEvent];
        } break;
        case UIControlEventTouchUpOutside: {
            [self.voiceRecordControl onCancelRecordEvent];
            
        } break;
        case UIControlEventTouchDragEnter: {
            [self.voiceRecordControl dragEnterRecordEvent];
        } break;
        case UIControlEventTouchCancel: {
            [self.voiceRecordControl onEndRecordEvent];
        } break;
        default:
            break;
    }
}





    /// 结束录制语音消息
- (void)voiceRecordControl:(RCVoiceRecordControl *)voiceRecordControl
                    didEnd:(NSData *)recordData
                  duration:(long)duration
                     error:(NSError *)error{
    if (error == nil) {
        if (self.conversationType == ConversationType_CUSTOMERSERVICE ||
            [RCCoreClient sharedCoreClient].voiceMsgType == RCVoiceMessageTypeOrdinary) {
            RCVoiceMessage *voiceMessage = [RCVoiceMessage messageWithAudio:recordData duration:duration];
            [self sendMessage:voiceMessage pushContent:nil];
        } else if ([RCCoreClient sharedCoreClient].voiceMsgType == RCVoiceMessageTypeHighQuality) {
            NSString *path = [self.util getHQVoiceMessageCachePath];
            [recordData writeToFile:path atomically:YES];
            RCHQVoiceMessage *hqVoiceMsg = [RCHQVoiceMessage messageWithPath:path duration:duration];
            [self sendMessage:hqVoiceMsg pushContent:nil];
        }
    }
}





// 字体颜色更改
- (void)willDisplayConversationTableCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = self.conversationDataRepository[indexPath.row];
    NSString *userID =  [NSString stringWithFormat:@"%ld",(long)[JLUserService shared].userInfo.userID];
    
    if ([cell isMemberOfClass:[RCTextMessageCell class]]){
        RCTextMessageCell *newCell = (RCTextMessageCell *)cell;

        if ([model.senderUserId isEqualToString:userID]) {
            newCell.textLabel.textColor = [UIColor whiteColor];
        }else{
            newCell.textLabel.textColor = [UIColor blackColor];
        }
    }
}




// 自定义底部区域
- (JLConversationButtomView *)buttomView{
    if (!_buttomView) {
        JLConversationButtomView *view = [JLConversationButtomView new];
        view.backgroundColor = [UIColor clearColor];
        view.delegate = self;
        _buttomView = view;
    }
    return  _buttomView;
}


- (JLEmojiView *)emojiView{
    if (!_emojiView) {
        JLEmojiView *view = [JLEmojiView new];
        view.backgroundColor = [UIColor blueColor];
        view.hidden = YES;
        _emojiView = view;
    }
    return  _emojiView;
}


- (UIButton *)keyboardMaskView{
    if (!_keyboardMaskView) {
        UIButton *view = [UIButton new];
        view.hidden = YES;
        [view addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
        _keyboardMaskView = view;
    }
    return  _keyboardMaskView;
}


- (RCVoiceRecordControl *)voiceRecordControl {
    if (!_voiceRecordControl) {
        _voiceRecordControl = [[RCVoiceRecordControl alloc] initWithConversationType:self.conversationType];
        _voiceRecordControl.delegate = self;
    }
    return _voiceRecordControl;
}


- (UIButton *)followBtn{
    if (!_followBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setTitle:@"Follow" forState:UIControlStateNormal];
        [view setTitle:@"UnFollow" forState:UIControlStateSelected];
        [view setImage:[UIImage jl_name:@"jl_follow_add" class:self] forState:UIControlStateNormal];
        [view setImage:[UIImage jl_name:@"jl_follow_no" class:self] forState:UIControlStateSelected];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        view.titleLabel.font = [UIFont systemFontOfSize:13];
        view.backgroundColor = [UIColor colorWithHexString:@"#D6007E"];
        [view addTarget:self action:@selector(clickFollowBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        view.layer.cornerRadius = 8;
        view.hidden = YES;
        _followBtn = view;
    }
    return  _followBtn;
}


-(CustomNaviBarView *)customNaviBarView {
    
    if (!_customNaviBarView) {
        CustomNaviBarView *view = [[CustomNaviBarView alloc] init];
        _customNaviBarView = view;
    }
    return _customNaviBarView;
}




- (void)checkAndRequestCameraPermission {
        // 1. 获取当前的授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
        // 2. 根据状态进行处理
    switch (authStatus) {
        case AVAuthorizationStatusAuthorized:
                // 用户已授权，可以安全地启动摄像头
            [self startUsingCamera];
            break;
            
        case AVAuthorizationStatusNotDetermined: {
                // 用户未决定，发起授权请求
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                            // 用户首次授权
                        [self startUsingCamera];
                    } else {
                            // 用户首次拒绝
                        [self showPermissionDeniedAlert];
                    }
                });
            }];
            break;
        }
            
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
                // 用户已拒绝或受限制，引导用户去设置
            [self showPermissionDeniedAlert];
            break;
            
        default:
            break;
    }
}





- (void)showPermissionDeniedAlert {
        // 弹窗提示，并引导用户跳转到系统设置
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相机"
                                                                   message:@"请在iPhone的“设置-隐私-相机”中，允许本应用访问相机。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *goToSettings = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 跳转到本应用的设置页面
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
    [alert addAction:cancel];
    [alert addAction:goToSettings];
    [self presentViewController:alert animated:YES completion:nil];
}


/*!
 发送消息被拦截的回调方法
 - Parameter blockedMessageInfo: 被拦截消息的相关信息
 */
- (void)messageDidBlock:(RCBlockedMessageInfo *)blockedMessageInfo{
    
    NSString *jsonString =  blockedMessageInfo.extra;
    if ([jsonString length] <= 0) {
        return;
    }
        // 转换为 NSData
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
        // 解析为字典
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    if (error) {
        NSLog(@"JSON解析失败: %@", error.localizedDescription);
    } else {
        NSLog(@"解析结果: %@", dictionary);
            // 使用字典
        NSNumber *number = dictionary[@"msgErrorCode"];
        NSInteger msgErrorCode = [number integerValue];
        // 1:用户余额不足
        if (msgErrorCode == 1){
            [SVProgressHUD showImage:nil status:@"Partner offline, try later"];
            
                // 通过 messageUID 获取对应的 message 信息
            RCMessage *blockMessage = [[RCCoreClient sharedCoreClient] getMessageByUId:blockedMessageInfo.blockedMsgUId];
            
                // 调用 IMLibCore 接口修改消息的发送状态
            [[RCCoreClient sharedCoreClient] setMessageSentStatus:blockMessage.messageId sentStatus:SentStatus_FAILED completion:^(BOOL ret) {
                
                    // 如果使用的是 IMKit ,需要延时发送刷新消息状态的通知; 如果是使用的 IMLib 则需要您自行处理 UI 刷新
                RCMessageCellNotificationModel *notifyModel = [[RCMessageCellNotificationModel alloc] init];
                notifyModel.actionName = CONVERSATION_CELL_STATUS_SEND_FAILED;
                notifyModel.messageId = blockMessage.messageId;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:KNotificationMessageBaseCellUpdateSendingStatus
                     object:notifyModel];
                });
            }];
        }
    }

}



@end

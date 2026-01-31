//
//  VideoViewController.m
//  JuliFrameworkDemo
//
//  Created by percent on 2025/4/1.
//

#import "VideoViewController.h"
#import <AgoraRtcKit/AgoraRtcKit.h>
#import "JLRTCService.h"
#import "JLAPIService.h"
#import "VideoCallView.h"
#import <Masonry/Masonry.h>
#import "Config.h"
#import "RemoteView.h"
#import "LocalView.h"
#import "JLGiftListModel.h"
#import "SVGAPlayer.h"
#import "JLSVGAQueueManager.h"
#import "VideoFuncView.h"
#import "VideoCallView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "JLUserService.h"
#import "JLCustomMessage.h"
#import "JLPopupViewComponent.h"

@interface VideoViewController ()<JLRTCServiceDelegate>

// 本地摄像头控制器
@property (nonatomic, strong) AgoraRtcVideoCanvas *localVideoCanvas;
// 远程摄像头控制器
@property (nonatomic, strong) AgoraRtcVideoCanvas *remoteVideoCanvas;
// 远程摄像头视图
@property (nonatomic, strong) RemoteView *remoteView;
// 本地摄像头视图
@property (nonatomic, strong) LocalView *localView;
// 本地摄像头点击视图
@property (nonatomic, strong) UIButton *localBtn;

// 电话拨打视图
@property (nonatomic, strong) VideoCallView *videoCallView;
// 聊天室视图
@property (nonatomic, strong) VideoFuncView *videoFuncView;


// 数据源
@property (nonatomic, strong) JLGiftListModel *model;
// 礼物svga
@property (nonatomic, strong) SVGAPlayer *svgaPlayer;
// 礼物管理器
@property (nonatomic, strong) JLSVGAQueueManager *queueManager;

@property (nonatomic, assign) NSInteger uid;
// 是否交换
@property (nonatomic, assign) BOOL isExchange;
// 是否主播加入
@property (nonatomic, assign) BOOL isAddJoinOfUid;



@end

@implementation VideoViewController


- (void)dealloc{
    NSLog(@"VideoViewController 销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 移除定时器
    [self.videoFuncView removeTimer];
    // 在视图消失时停止倒计时，避免内存泄漏
    [self.videoFuncView.countdownLab stopCountdown];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestData];
    [self creatUI];
    [self setupLayouts];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendAskGiftMessge:)
                                                 name:kNotificationVideoViewAskGiftSuccess object:nil];
    
    
        // 注册RTC代理
    [JLRTCService shared].delegate = self;
        // 加入房间
    [[JLRTCService shared] joinChannel:self.channel token:self.token needPush:self.isNeedPush];
        // 设置本地摄像头
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    videoCanvas.view = self.localView.contentView;
    self.localVideoCanvas = videoCanvas;
    [[JLRTCService shared].agoraKit setupLocalVideo:videoCanvas];
    
    [[JLRTCService shared].agoraKit enableAudio];
    [[JLRTCService shared].agoraKit enableVideo];
    [[JLRTCService shared].agoraKit startPreview];
    
    
    
    if (self.isHeartMatch == YES){
            // 隐藏拨打视图
        self.videoCallView.hidden = YES;
            // 是否是心动速配
        self.videoFuncView.isHeartMatch = self.isHeartMatch;
    }
}


- (void)creatUI{
    
        // 创建SVGA播放器
    self.svgaPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-34-60)];
    self.svgaPlayer.userInteractionEnabled = NO;
        // 创建队列管理器
    self.queueManager = [[JLSVGAQueueManager alloc] initWithPlayer:self.svgaPlayer];
    
    
    [self.view addSubview:self.remoteView];
    [self.view addSubview:self.videoFuncView];
    [self.view addSubview:self.videoCallView];
    [self.view addSubview:self.localView];
    [self.view addSubview:self.localBtn];
    [self.view addSubview:self.svgaPlayer];
    
    
    // 主播信息
    self.videoCallView.anchorUserInfo = self.anchorUserInfo;
    self.videoFuncView.anchorUserInfo = self.anchorUserInfo;

        // 频道
    self.videoFuncView.channel = self.channel;
        // 主播通话价格
    self.videoCallView.priceLab.text = [NSString stringWithFormat:@"%ld",self.anchorUserInfo.coinVideoPrice];
        // 摄像头开关状态
    self.videoFuncView.videoViewButtomView.cameraBtn.selected = self.videoCallView.cameraBtn.selected;
        // 麦克风开关状态
    self.videoFuncView.videoViewButtomView.microphoneBtn.selected = self.videoCallView.microphoneBtn.selected;
    
    
    Weakself(ws)
        // 点击摄像头
    self.videoCallView.clickCameraBlock = ^(BOOL result) {
        
        if (ws.isExchange == YES) {
            if (result == NO) {
                [ws.remoteView stopHeadView];
            }else{
                [ws.remoteView startHeadView];
            }
        }else{
            if (result == NO) {
                [ws.localView stopHeadView];
            }else{
                [ws.localView startHeadView];
            }
        }
        
        
            // 摄像头开关状态
        ws.videoFuncView.videoViewButtomView.cameraBtn.selected = result;
    };
    
    self.videoFuncView.videoViewButtomView.clickCameraBtnBlock = self.videoCallView.clickCameraBlock;
    
    
    
        // 点击麦克风
    self.videoCallView.clickMicroPhoneBlock  = ^(BOOL result){
            // 麦克风开关状态
        ws.videoFuncView.videoViewButtomView.microphoneBtn.selected = result;
    };
    
    
        // 前后置镜头切换
    self.videoCallView.clickReverseBlock = ^(BOOL result){
        
    };
    
    
    
        // 点击取消拨打通话
    self.videoCallView.clickCancelBlock = ^{
        [ws clickCancenCall];
    };
    
    
    
        // 点击空白区域回收键盘
    self.videoFuncView.clickMaskViewBlock = ^{
        [ws hideKeyboard];
    };
    
    
        // 点击退出房间
    self.videoFuncView.clickLogoutBlock = ^{
            // 创建 UIAlertController
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Operration Tips"
                                                                       message:@"Are you sure you want to leave the room?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
            // 添加按钮动作
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了取消按钮");
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Confirm"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
            [ws logoutRequest];
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
            // 显示警告框
        [ws presentViewController:alert animated:NO completion:nil];
    };
    
    
    
        // 发送消息按钮
    self.videoFuncView.sendMessageSuccessBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws.view endEditing:YES];
        });
            // 更新金币
        [ws requestUserCoinComplete:nil];
    };
    
    
        // 点击前后置镜头
    self.videoFuncView.videoViewButtomView.clickReverseBtnBlock = ^{
        if (ws.videoCallView) {
            [ws.videoCallView clickReverseBtnEvnet];
        }
    };
    
    
        // 点击礼物按钮
    self.videoFuncView.videoViewButtomView.clickGiftBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws.view endEditing:YES];
            if (ws.model) {
                [ws requestUserCoinComplete:^{
                    [JLPopupViewComponent popupTableiViewWithModel:ws.model returnModel:^(JLGiftModel * _Nonnull model,NSString * _Nonnull num) {
                        [ws sendGiftMessge:model num:num];
                    }];
                } isShowLoding:YES];
            }
        });
    };
    
    
    
    
        //    self.emojiView.clickSelectEmojiBlock = ^(NSString * string) {
        //        [weakSelf.buttomView.contentTxf insertText:string];
        //    };
        //
        //
        //    self.emojiView.clickDelEmojiBlock = ^{
        //        [weakSelf.buttomView.contentTxf deleteBackward];
        //    };
}





- (void)setupLayouts{
    
    [self.remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [self.videoFuncView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [self.videoCallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [self.localView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavigationBar_Height + 12);
        make.right.equalTo(self.view).offset(-16);
        make.size.mas_equalTo(CGSizeMake(150, 200));
    }];
    
    
    
    [self.localBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.localView);
    }];
    
}






    // 空白区域回收键盘
- (void)hideKeyboard {
    [self.view endEditing:YES];
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
    [self.videoFuncView showMask];
    [self.videoFuncView.videoViewButtomView showKeyboardUI];
    
    [self.videoFuncView.videoViewButtomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset( - keyboardHeight);
        make.left.mas_equalTo(self.view);
        make.width.offset([UIScreen mainScreen].bounds.size.width);
        make.height.offset(60);
    }];
    
    
        //    [UIView animateWithDuration:duration animations:^{
        //        [UIView setAnimationCurve:curve];
        //        [self.view layoutIfNeeded];
        //    }];
}





    // 键盘即将隐藏
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self.videoFuncView hideMask];
    [self.videoFuncView.videoViewButtomView hideKeyboardUI];
    
    [self.videoFuncView.videoViewButtomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-34);
        make.left.mas_equalTo(self.view);
        make.width.offset([UIScreen mainScreen].bounds.size.width);
        make.height.offset(60);
    }];
    
    
        //    [UIView animateWithDuration:duration animations:^{
        //        [self.view layoutIfNeeded];
        //    }];
}






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
    
}





    // 发送礼物
- (void)sendGiftMessge:(JLGiftModel *)model num:(NSString *)num{
    
    Weakself(ws)
    [SVProgressHUD show];
    [JLUserService sendGiftInfoWithAnchorId:self.anchorID channelId:self.channel giftId:model.ID giveNum:num success:^(NSDictionary * _Nonnull result) {
        [SVProgressHUD dismiss];
        [ws requestUserCoinComplete:nil];
        [ws addSvgaUrl:model.giftSvgaUrl];
    } failued:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"%@",error);
    }];
}


    // 回赠礼物
- (void)sendAskGiftMessge:(NSNotification *)notification{
    
    
    id passedObject = notification.object;
    JLAskGiftMessage *askGiftMessage = passedObject;
    
    if (askGiftMessage != nil) {
        Weakself(ws)
        NSString *giveNum = @"1";
        if ([askGiftMessage.giveNum integerValue] > 0){
            giveNum = askGiftMessage.giveNum;
        }
        
        
        [SVProgressHUD show];
        [JLUserService sendGiftInfoWithAnchorId:self.anchorID channelId:self.channel giftId:askGiftMessage.giftId giveNum:giveNum success:^(NSDictionary * _Nonnull result) {
            [SVProgressHUD dismiss];
            [ws requestUserCoinComplete:nil];
            [ws addSvgaUrl:askGiftMessage.giftSvgaUrl];
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



// 切换本地摄像头和远程摄像头方法
- (void)clickViewEvnet{
    
    if (self.isAddJoinOfUid == NO) {
        return;
    }
         
    self.isExchange = !self.isExchange;
    if (self.isExchange) {
        
        self.localVideoCanvas.view = nil;
        [[JLRTCService shared].agoraKit setupRemoteVideo:self.localVideoCanvas];
        
            // 设置本地摄像头
        AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        videoCanvas.uid = 0;
        videoCanvas.view = self.remoteView.contentView;
        self.localVideoCanvas = videoCanvas;
        [[JLRTCService shared].agoraKit setupLocalVideo:videoCanvas];
        
        self.remoteVideoCanvas.view = nil;
        [[JLRTCService shared].agoraKit setupRemoteVideo:self.remoteVideoCanvas];
        
            // 设置远程摄像头
        AgoraRtcVideoCanvas *remoteVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        remoteVideoCanvas.uid = self.uid;
        remoteVideoCanvas.view = self.localView.contentView;
        remoteVideoCanvas.renderMode = AgoraVideoRenderModeHidden;
        self.remoteVideoCanvas = remoteVideoCanvas;
        [[JLRTCService shared].agoraKit setupRemoteVideo:remoteVideoCanvas];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.videoFuncView.videoViewButtomView.cameraBtn.selected == NO) {
                [self.localView stopHeadView];
                [self.remoteView stopHeadView];
            }else{
                [self.localView stopHeadView];
                [self.remoteView startHeadView];
            }
        });
        
        
    }else{
        
        
        self.localVideoCanvas.view = nil;
        [[JLRTCService shared].agoraKit setupRemoteVideo:self.localVideoCanvas];
        
            // 设置本地摄像头
        AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        videoCanvas.uid = 0;
        videoCanvas.view = self.localView.contentView;
        self.localVideoCanvas = videoCanvas;
        [[JLRTCService shared].agoraKit setupLocalVideo:videoCanvas];
        
        
        
        self.remoteVideoCanvas.view = nil;
        [[JLRTCService shared].agoraKit setupRemoteVideo:self.remoteVideoCanvas];
        
            // 设置远程摄像头
        AgoraRtcVideoCanvas *remoteVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
        remoteVideoCanvas.uid = self.uid;
        remoteVideoCanvas.view = self.remoteView;
        remoteVideoCanvas.renderMode = AgoraVideoRenderModeHidden;
        self.remoteVideoCanvas = remoteVideoCanvas;
        [[JLRTCService shared].agoraKit setupRemoteVideo:remoteVideoCanvas];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.videoFuncView.videoViewButtomView.cameraBtn.selected == NO) {
                [self.localView stopHeadView];
                [self.remoteView stopHeadView];
            }else{
                [self.localView startHeadView];
                [self.remoteView stopHeadView];
            }
        });

    }
        
}






// 取消拨打通话
- (void)clickCancenCall{
    [JLAPIService userCancalCallChannelID:self.channel success:^(NSDictionary * _Nonnull result) {
        NSLog(@"手动取消拨打通话成功");
    } failued:^(NSError * _Nonnull error) {
        NSLog(@"手动取消拨打通话失败");
    }];
}


    // 退出房间接口请求
- (void)logoutRequest{
        // 防止出现白条bug
    [self.videoFuncView noGetImMessage];
    Weakself(ws)
    [[JLRTCService shared] endVideoCallWithSuccess:^(NSDictionary * _Nonnull result) {
        NSLog(@"退出1v1房间成功");
        [ws dismissViewControllerAnimated:YES completion:nil];
    } failued:^(NSError * _Nonnull error) {
        NSLog(@"退出1v1房间失败");
    }];
}


#pragma mark - JLRTCServiceDelegate
    /// 拨打视频电话发生异常
    /// - Parameters:
    ///   - service: 视频模块
    ///   - error: 异常错误
- (void)rtcService:(JLRTCService *)service didOccurError:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:nil];
}


    /// 用户加入房间
    /// - Parameters:
    ///   - service: 视频模块
    ///   - channel: 房间号
    ///   - uid: 用户id
- (void)rtcService:(JLRTCService *)service didJoinChannel:(NSString *)channel withUid:(NSInteger)uid{
    NSLog(@"用户加入房间");
}


    /// 主播加入房间
    /// - Parameters:
    ///   - service: 视频模块
    ///   - uid: 主播id
- (void)rtcService:(JLRTCService *)service didJoinOfUid:(NSUInteger)uid{
    
    // 隐藏拨打视图
    self.videoCallView.hidden = YES;
    self.isAddJoinOfUid = YES;
    // 计算房间时间
    [self.videoFuncView startCountdown];
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    self.uid = uid;
    videoCanvas.uid = uid;
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    videoCanvas.view = self.remoteView.contentView;
    self.remoteVideoCanvas = videoCanvas;
    [service.agoraKit setupRemoteVideo:videoCanvas];
}


    /// 用户重新加入房间
    /// - Parameters:
    ///   - service: 视频模块
    ///   - channel: 房间号
    ///   - uid: 用户端id
- (void)rtcService:(JLRTCService *)service didRejoinChannel:(NSString *)channel withUid:(NSInteger)uid{
    
}


    ///  主播离线
    /// - Parameters:
    ///   - service: 视频模块
    ///   - uid: 主播id
- (void)rtcService:(JLRTCService *)service didOfflineOfUid:(NSUInteger)uid{
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (RemoteView *)remoteView{
    if (!_remoteView) {
        RemoteView *view = [[RemoteView alloc] init];
        view.backgroundColor = [UIColor blackColor];
        _remoteView = view;
    }
    return  _remoteView;
}




- (UIButton *)localBtn{
    if (!_localBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view addTarget:self action:@selector(clickViewEvnet) forControlEvents:UIControlEventTouchUpInside];
        _localBtn = view;
    }
    return  _localBtn;
}




- (LocalView *)localView{
    if (!_localView) {
        LocalView *view = [[LocalView alloc] init];
        view.layer.cornerRadius = 16;
        view.layer.masksToBounds = YES;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.borderWidth = 1;
        view.backgroundColor = [UIColor blackColor];
        _localView = view;
    }
    return  _localView;
}



- (VideoCallView *)videoCallView{
    if (!_videoCallView) {
        VideoCallView *view = [[VideoCallView alloc] init];
        _videoCallView = view;
    }
    return  _videoCallView;
}




- (VideoFuncView *)videoFuncView{
    if (!_videoFuncView) {
        VideoFuncView *view = [[VideoFuncView alloc] init];
        _videoFuncView = view;
    }
    return  _videoFuncView;
}





@end

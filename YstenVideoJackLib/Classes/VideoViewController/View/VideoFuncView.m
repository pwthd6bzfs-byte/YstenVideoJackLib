//
//  VideoFuncView.m
//  LJChatSDK
//
//  Created by percent on 2026/1/19.
//

#import "VideoFuncView.h"
#import "VideoViewTextMessageCell.h"
#import "VideoViewAskGiftMessageCell.h"
#import "VideoViewGiftMessageCell.h"
#import "RechargeView.h"
#import "HeartMatchExplainView.h"
#import "RCIM.h"
#import "JLSystemConfigUtil.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "JLUserService.h"
#import "JLIMService.h"
#import "JLCustomMessage.h"
#import "JLAPIService.h"
#import "UIImage+Add.h"

@interface VideoFuncView ()<UITableViewDelegate,UITableViewDataSource>

// 蒙层
@property (nonatomic, strong) UIButton *vMask;
// 头像
@property (nonatomic, strong) UIImageView *headImageView;
// 名称
@property (nonatomic, strong) UILabel *nickNameLab;
// 国家icon
@property (nonatomic, strong) UIImageView *nationImageView;
// 国家名称
@property (nonatomic, strong) UILabel *nationLab;
// 房间标签
@property (nonatomic, strong) UIView *roomTagView;
// 房间标签icon
@property (nonatomic, strong) UIImageView *roomTagIcon;
// 房间标签文本
@property (nonatomic, strong) UILabel *roomTagLab;
// 关注按钮
@property (nonatomic, strong) UIButton *followBtn;
// 退出按钮
@property (nonatomic, strong) UIButton *logoutBtn;
// 倒计时容器
@property (nonatomic, strong) UIView *countdownView;
// 倒计时icon
@property (nonatomic, strong) UIImageView *countdownImageView;
// 消息TableView
@property (nonatomic, strong) UITableView *tableView;
// 金币不足提示
@property (nonatomic, strong) RechargeView *rechargeView;
// 心动速配明细提示
@property (nonatomic, strong) HeartMatchExplainView *heartMatchExplainView;


@property (nonatomic, strong) NSTimer *timer;


// 数据源
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, assign) NSInteger heartbeatMatchFreeTime;

@end


@implementation VideoFuncView


- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
        self.isGetMeesage = YES;
        
        NSDictionary *heartbeatMatchDict =  [JLSystemConfigUtil getInfoWithHeartbeatMatchDict:@"HeartbeatMatchDict"];
        NSString *heartbeatMatchFreeTimeString =  heartbeatMatchDict[@"heartbeatMatchFreeTime"];
        self.heartbeatMatchFreeTime = [heartbeatMatchFreeTimeString integerValue];
    }
    return self;
}


- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)initialize{
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessage:)
                                                 name:kNotificationRcMessageSuccess
                                               object:nil];

    
    [self addSubview:self.headImageView];
    [self addSubview:self.nickNameLab];
    [self addSubview:self.nationImageView];
    [self addSubview:self.nationLab];
    [self addSubview:self.roomTagView];
    [self addSubview:self.followBtn];
    [self addSubview:self.logoutBtn];
    [self addSubview:self.countdownView];
    [self addSubview:self.countdownImageView];
    [self addSubview:self.countdownLab];
    [self addSubview:self.tableView];
    [self addSubview:self.heartMatchExplainView];
    [self addSubview:self.rechargeView];
    [self addSubview:self.vMask];
    [self addSubview:self.videoViewButtomView];
    
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kStatusBarHeight + 6);
        make.left.equalTo(self).offset(16);
        make.size.mas_offset(CGSizeMake(32, 32));
    }];
    
    
    [self.nickNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top).offset(-1);
        make.left.equalTo(self.headImageView.mas_right).offset(16);
    }];

    
    
    [self.nationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageView.mas_bottom).offset(1);
        make.left.equalTo(self.headImageView.mas_right).offset(16);
        make.size.mas_offset(CGSizeMake(12, 14));
    }];

    
    [self.nationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nationImageView);
        make.left.equalTo(self.nationImageView.mas_right).offset(2);
    }];
    
    
    
    [self.roomTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countdownView.mas_bottom).offset(14);
        make.left.equalTo(self.countdownView);
        make.size.mas_offset(CGSizeMake(113, 32));
    }];

    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImageView);
        make.left.equalTo(self.nickNameLab.mas_right).offset(5);
        make.size.mas_offset(CGSizeMake(82, 32));
    }];

    
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.followBtn);
        make.right.equalTo(self).offset(-16);
        make.size.mas_offset(CGSizeMake(32, 32));
    }];

    
    [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(18);
        make.left.equalTo(self.headImageView);
        make.size.mas_offset(CGSizeMake(103, 32));
    }];
    
    
    [self.countdownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.countdownView);
        make.left.equalTo(self.countdownView).offset(8);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];


    
    [self.countdownLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.countdownView);
        make.left.equalTo(self.countdownImageView.mas_right).offset(3);
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView);
        make.width.equalTo(@276);
        make.height.equalTo(@296);
        make.bottom.equalTo(self.rechargeView.mas_top).offset(-12);
    }];
    
    
    [self.rechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView);
        make.right.equalTo(self).offset(-16);
        make.height.equalTo(@0);
        make.bottom.equalTo(self.heartMatchExplainView.mas_top).offset(0);
    }];
    
    [self.heartMatchExplainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView);
        make.right.equalTo(self).offset(-16);
        make.height.equalTo(@0);
        make.bottom.equalTo(self.videoViewButtomView.mas_top).offset(0);
    }];
    
    [self.videoViewButtomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-34);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@60);
    }];
    
    
    [self.vMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    

    Weakself(ws)
    self.videoViewButtomView.clickSendBlock = ^{
        if (ws.videoViewButtomView.contentTxf.text.length <= 0){
            [SVProgressHUD showImage:nil status:@"The content cannot be empty."];
            return;
        }
        
        JLUserModel *userInfo = [JLUserService shared].userInfo;
        
        
        // 拓展参数
        NSDictionary *dict= @{
            @"nickName":userInfo.nickName,
            @"headFileName":userInfo.headFileName,
            @"gender":[NSString stringWithFormat:@"%@",userInfo.gender],
            @"country":userInfo.country,
            @"id":[NSString stringWithFormat:@"%ld",userInfo.userID],
            @"userCode":userInfo.userCode,
            @"channelId":ws.channel};
        NSString *dictString = [dict modelToJSONString];
                
        
        RCTextMessage *textMessage = [[RCTextMessage alloc] init];;
        textMessage.content = ws.videoViewButtomView.contentTxf.text;
        textMessage.extra = dictString;
//        textMessage
        RCMessage *message = [[RCMessage alloc] init];
        message.targetId = [NSString stringWithFormat:@"%ld", ws.anchorUserInfo.userID];
        message.content = textMessage;
        message.messageDirection = MessageDirection_SEND;
        message.senderUserId = [NSString stringWithFormat:@"%ld",[JLUserService shared].userInfo.userID];
        message.conversationType = ConversationType_PRIVATE;
        
        
        [ws.array addObject:message];
        if (ws.array.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws.tableView reloadData];
                [ws.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ws.array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
        }
        

        [[RCIM sharedRCIM] sendMessage:message pushContent:nil pushData:nil successBlock:^(RCMessage * _Nonnull successMessage) {
            
            ws.sendMessageSuccessBlock();
            NSLog(@"%@",successMessage);
        } errorBlock:^(RCErrorCode nErrorCode, RCMessage * _Nonnull errorMessage) {
            NSLog(@"%@",errorMessage);
        }];
        
        ws.videoViewButtomView.contentTxf.text = @"";
    };
    
}



- (void)setAnchorUserInfo:(JLAnchorUserModel *)anchorUserInfo{
    _anchorUserInfo = anchorUserInfo;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:anchorUserInfo.headFileName]];
    self.nickNameLab.text = anchorUserInfo.nickName;
    self.nationLab.text = anchorUserInfo.country;
    [self.nationImageView sd_setImageWithURL:[NSURL URLWithString:anchorUserInfo.nationalFlagUrl]];
    
    
    if ([self.anchorUserInfo.followFlag isEqualToString:@"1"]) {
        self.followBtn.selected = YES;
        self.followBtn.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
    }else{
        self.followBtn.selected = NO;
        self.followBtn.backgroundColor = [UIColor colorWithHexString:@"#D6007E"];
    }
    
}


- (void)setIsHeartMatch:(BOOL)isHeartMatch{
    if (isHeartMatch == YES) {
        // 更改为心动样式 (默认通话视频样式)
        self.roomTagView.backgroundColor = [UIColor colorWithHexString:@"#F95D9A" alpha:0.5];
        self.roomTagLab.text = @"Heartmatch";
        self.roomTagIcon.image = [UIImage jl_name:@"jl_heartMatch" class:self];
        [self showHeartMatchView];
    }
}




// 设置目标时间为当前时间
- (void)startCountdown{
    [self.countdownLab startCountdown];
}





- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}



// 设置超时定时器
- (void)startTimer {
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
    
    if (self.heartbeatMatchFreeTime == 0) {
        [self.timer invalidate];
        self.timer = nil;
        
        // 隐藏心动提示
        [self.heartMatchExplainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headImageView);
            make.right.equalTo(self).offset(-16);
            make.height.equalTo(@0);
            make.bottom.equalTo(self.videoViewButtomView.mas_top).offset(0);
        }];
        
        return;
    }
    
    self.heartbeatMatchFreeTime -= 1;
    
    NSString *content = [NSString stringWithFormat:@"%lds %ldconins/minute",self.heartbeatMatchFreeTime,(long)self.anchorUserInfo.coinVideoPrice];
    
    [self.heartMatchExplainView setContent:content];
}




// 显示去充值视图
- (void)showRechargeView{
    NSLog(@"显示弹窗充值视图");
    [self.rechargeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView);
        make.right.equalTo(self).offset(-16);
        make.height.equalTo(@56);
        make.bottom.equalTo(self.heartMatchExplainView.mas_top).offset(-12);
    }];
}




// 显示心动速配明细提示
- (void)showHeartMatchView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.heartMatchExplainView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.headImageView);
                make.right.equalTo(self).offset(-16);
                make.height.equalTo(@42);
                make.bottom.equalTo(self.videoViewButtomView.mas_top).offset(-12);
            }];
            
            
            [self startTimer];
        });
    });
}







- (void)clickFollowingBtnEvnet:(UIButton *)sender{
    Weakself(ws);
    if (self.followBtn.selected == YES) {
        [SVProgressHUD show];
            // 获取主播详情信息
        [JLAPIService cancelFollowWithAnchorID:self.anchorUserInfo.userID success:^(NSDictionary * _Nonnull result) {
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
        [JLAPIService addFollowWithAnchorID:self.anchorUserInfo.userID success:^(NSDictionary * _Nonnull result) {
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



// 不再接收IM消息
- (void)noGetImMessage{
    self.isGetMeesage = NO;
}



- (void)showMask{
    self.vMask.hidden = NO;
}




- (void)hideMask{
    self.vMask.hidden = YES;
}




- (void)clickMaskViewEvnet{
    if (self.clickMaskViewBlock) {
        self.clickMaskViewBlock();
    }
}





- (void)clickLogoutBtnEvnet:(UIButton *)sender{
    if (self.clickLogoutBlock) {
        self.clickLogoutBlock();
    }
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCMessage *message =  self.array[indexPath.row];

    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        VideoViewTextMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoViewTextMessageCell"];
        cell.message = message;
        return  cell;
    }
    
    
    if ([message.content isMemberOfClass:[JLAskGiftMessage class]]) {
        VideoViewAskGiftMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoViewAskGiftMessageCell"];
        cell.message = message;
        return  cell;
    }

    
    if ([message.content isMemberOfClass:[JLGiftMessage class]]) {
        VideoViewGiftMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoViewGiftMessageCell"];
        cell.message = message;
        return  cell;
    }

    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return  cell;
}






    /// 监听接收到融云消息
    /// - Parameters:
    ///   - service: service
    ///   - message: 融云消息
- (void)didReceiveMessage:(NSNotification *)notification{
    RCMessage *message = notification.object;
    
    if (self.isGetMeesage == NO) {
        return;
    }
    
    // 判断是否是该主播的消息
    if ([message.targetId isEqualToString:[NSString stringWithFormat:@"%ld",self.anchorUserInfo.userID]]) {
        
        // 去充值消息
        if ([message.objectName isEqualToString:@"mikchat:recharge"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showRechargeView];
            });
            return;
        }
        
        
//        // 不接收
//        if ([message.content isMemberOfClass:[JLHeartBeatMessage class]]) {
//            return;
//        }
        
        
        [self.array addObject:message];
        if (self.array.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            });
        }
    }
}





- (UIButton *)vMask{
    if (!_vMask) {
        UIButton *view = [[UIButton alloc] init];
        view.hidden = YES;
        [view addTarget:self action:@selector(clickMaskViewEvnet) forControlEvents:UIControlEventTouchUpInside];
        _vMask = view;
    }
    return  _vMask;
}





- (UIImageView *)headImageView{
    if (!_headImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.layer.cornerRadius = 32/2.0;
        view.layer.masksToBounds = YES;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
        _headImageView = view;
    }
    return  _headImageView;
}


- (UILabel *)nickNameLab{
    if (!_nickNameLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor whiteColor];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:14];
        view.textAlignment = UITextAlignmentCenter;
        _nickNameLab = view;
    }
    return  _nickNameLab;
}



- (UIImageView *)nationImageView{
    if (!_nationImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        _nationImageView = view;
    }
    return  _nationImageView;
}



- (UILabel *)nationLab{
    if (!_nationLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:10];
        view.textAlignment = UITextAlignmentCenter;
        _nationLab = view;
    }
    return  _nationLab;
}






- (UIView *)roomTagView{
    if (!_roomTagView) {
        UIView *view = [[UIView alloc] init];
        view.layer.cornerRadius = 32/2.0;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor colorWithHexString:@"#B20FE4" alpha:0.5];

        UIImageView *iconImg = [[UIImageView alloc] init];
        iconImg.image = [UIImage jl_name:@"jl_video" class:self];
        self.roomTagIcon = iconImg;
        [view addSubview:iconImg];
        
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).offset(8);
            make.size.mas_offset(CGSizeMake(20, 20));
        }];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.textColor = [UIColor whiteColor];
        lab.text =  @"Video chat";
        lab.font = [UIFont systemFontOfSize:14];
        self.roomTagLab = lab;
        [view addSubview:lab];

        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(iconImg.mas_right).offset(2);
        }];
        
        _roomTagView = view;
    }
    return  _roomTagView;
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
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = YES;
        [view addTarget:self action:@selector(clickFollowingBtnEvnet:) forControlEvents:UIControlEventTouchUpInside];
        _followBtn = view;
    }
    return  _followBtn;
}




- (UIButton *)logoutBtn{
    if (!_logoutBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setImage:[UIImage jl_name:@"jl_close" class:self] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(clickLogoutBtnEvnet:) forControlEvents:UIControlEventTouchUpInside];
        _logoutBtn = view;
    }
    return  _logoutBtn;
}




- (UIView *)countdownView{
    if (!_countdownView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.2];
        view.layer.cornerRadius = 18;
        view.layer.masksToBounds = YES;
        _countdownView = view;
    }
    return  _countdownView;
}





- (UIImageView *)countdownImageView{
    if (!_countdownImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.image = [UIImage jl_name:@"jl_countDown" class:self];
        _countdownImageView = view;
    }
    return  _countdownImageView;
}





- (CountdownLabel *)countdownLab{
    if (!_countdownLab) {
        CountdownLabel *view = [[CountdownLabel alloc] init];
        view.textColor = [UIColor whiteColor];
        view.text = @"00:00:00";
        view.font = [UIFont systemFontOfSize:13];
        view.textAlignment = UITextAlignmentCenter;
        _countdownLab = view;
    }
    return  _countdownLab;
}





-(UITableView *) tableView
{
    if (!_tableView)
        {
        
        UITableView * view = [[UITableView alloc]initWithFrame:
                              CGRectMake(0,
                                         0,
                                         0,
                                         0 ) style:UITableViewStylePlain];
        view.delegate = self;
        view.dataSource = self;
        view.contentInset = UIEdgeInsetsMake(0 , 0, 0, 0);
        view.separatorColor = [UIColor clearColor];
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.estimatedRowHeight = 60;
        view.rowHeight = UITableViewAutomaticDimension;
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.backgroundColor = [UIColor clearColor];
        view.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        view.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        view.sectionHeaderHeight = 0;
        view.sectionFooterHeight = 0;
        [view registerClass:[VideoViewTextMessageCell class] forCellReuseIdentifier:@"VideoViewTextMessageCell"];
        [view registerClass:[VideoViewAskGiftMessageCell class] forCellReuseIdentifier:@"VideoViewAskGiftMessageCell"];
        [view registerClass:[VideoViewGiftMessageCell class] forCellReuseIdentifier:@"VideoViewGiftMessageCell"];

        if (@available(iOS 11.0, *)) {
            view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView = view;
        }
    return _tableView;
}



- (RechargeView *)rechargeView{
    if (!_rechargeView) {
        RechargeView *view = [[RechargeView alloc] init];
        _rechargeView = view;
    }
    return  _rechargeView;
}




- (HeartMatchExplainView *)heartMatchExplainView{
    if (!_heartMatchExplainView) {
        HeartMatchExplainView *view = [[HeartMatchExplainView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        _heartMatchExplainView = view;
    }
    return  _heartMatchExplainView;
}




- (VideoViewButtomView *)videoViewButtomView{
    if (!_videoViewButtomView) {
        VideoViewButtomView *view = [[VideoViewButtomView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        _videoViewButtomView = view;
    }
    return  _videoViewButtomView;
}


- (NSMutableArray *)array{
    if (!_array) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        _array = array;
    }
    
    return _array;
}



@end

//
//  JLViewController.m
//  YstenVideoJackLib
//
//  Created by pwthd6bzfs-byte on 01/29/2026.
//  Copyright (c) 2026 pwthd6bzfs-byte. All rights reserved.
//

#import "JLViewController.h"
#import "JLLocalizationUtil.h"
#import "JLAPIService.h"
#import "SVProgressHUD.h"
#import "JLStorageUtil.h"
#import "JLIMService.h"
#import "JLWebViewController.h"
#import "JLIMService.h"
#import "JLUserService.h"
#import "JLCustomMessage.h"
#import "JLChatListContainer.h"
#import "JLConversationListVC.h"

@interface JLViewController ()<JLIMServiceDelegate>

@property (nonatomic,strong) UITextField *txf;

@end

@implementation JLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [JLLocalizationUtil setLanguage:@"en"];
        // 测试环境
    [JLAPIService environmentSetting:0];
    [[JLIMService shared] initSystem];
    [JLIMService shared].delegate = self;
    
    
    
    UITextField *txf = [[UITextField alloc] init];
    txf.frame = CGRectMake(60, 120, 200, 50);
    txf.layer.borderColor = [UIColor blackColor].CGColor;
    txf.layer.borderWidth = 1;
    txf.placeholder = @"设备号";
    txf.text = @"10007312";
    txf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    txf.leftViewMode = UITextFieldViewModeAlways;
    self.txf = txf;
    [self.view addSubview:txf];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor blackColor];
    [btn1 setTitle:@"登录" forState:UIControlStateNormal];
    btn1.frame = CGRectMake(60, 180, 200, 50);
    [btn1 addTarget:self action:@selector(clickbtn1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [UIColor blackColor];
    [btn2 setTitle:@"深度聊天" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(60, 240, 200, 50);
    [btn2 addTarget:self action:@selector(clickbtn2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    
    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn6.backgroundColor = [UIColor blackColor];
    [btn6 setTitle:@"web页面" forState:UIControlStateNormal];
    btn6.frame = CGRectMake(60, 300, 200, 50);
    [btn6 addTarget:self action:@selector(clickbtn6:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn6];
    
    UIButton *btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn7.backgroundColor = [UIColor blackColor];
    [btn7 setTitle:@"退出登录" forState:UIControlStateNormal];
    btn7.frame = CGRectMake(60, 360, 200, 50);
    [btn7 addTarget:self action:@selector(clickbtn7:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn7];
    
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.backgroundColor = [UIColor blackColor];
    [btn5 setTitle:@"消息列表" forState:UIControlStateNormal];
    btn5.frame = CGRectMake(60, 420, 200, 50);
    [btn5 addTarget:self action:@selector(clickbtn5:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn5];
    
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)clickbtn1:(UIButton *)btn{
    [self.view endEditing:YES];
    
    [[JLUserService shared] loginUserId:self.txf.text];
    
//    [[JLUserService shared] initServiceWithUserID:self.txf.text success:^(NSDictionary * _Nonnull result) {
//        NSLog(@"%@",result);
//    } failued:^(NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
}


- (void)clickbtn2:(UIButton *)btn{
    
    JLChatListContainer *vc = [[JLChatListContainer alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)clickbtn5:(UIButton *)btn{
    
    
    JLConversationListVC *vc = [[JLConversationListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

        //    if (![JLStorageUtil userToken]){
        //        [SVProgressHUD showImage:nil status:@"未登录"];
        //        return;
        //    }
        //
        //    JLHeartMatchController *vc = [[JLHeartMatchController alloc] init];
        //    [self.navigationController pushViewController:vc animated:YES];
}


- (void)clickbtn6:(UIButton *)btn{
    
    if (![JLStorageUtil userToken]){
        [SVProgressHUD showImage:nil status:@"未登录"];
        return;
    }
    
    JLWebViewController *webVC = [[JLWebViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)clickbtn7:(UIButton *)btn{
    [[JLIMService shared] logout];
    [SVProgressHUD showImage:nil status:@"退出成功"];
}

- (void)clickbtn8:(UIButton *)btn{
    
        //    JLUserModel *model = [[JLUserService shared] userInfo];
        //    if (model.coins <= 0) {
        //        return [SVProgressHUD showInfoWithStatus:@"你的金币不足"];
        //    }
    
        // 拨打视频
        //    [[JLRTCService shared] videoCallWithAnchorID:1691666985372561410 success:^(NSString * _Nonnull channel, NSString * _Nonnull token) {
        //        VideoViewController *controller = [[VideoViewController alloc] init];
        //        controller.modalPresentationStyle = 0;
        //        controller.channel = channel;
        //        controller.token = token;
        //        controller.isNeedPush = NO;
        //        controller.anchorID = 1691666985372561410;
        //        controller.anchorRtcToken = @"";
        //        [self presentViewController:controller animated:YES completion:nil];
        //
        //    } failued:^(NSError * _Nonnull error) {
        //
        //    }];
}





    // 代理方法
- (void)didReceiveMessage:(RCMessage *)message {
    if ([message.content isKindOfClass:[JLVideoMessage class]]) {
        JLVideoMessage *customMessage = (JLVideoMessage *)message.content;
        NSLog(@"%@",customMessage);
    }
}


- (void)imService:(JLIMService *)service didReceiveMessage:(RCMessage *)message {
    
        //    if ([message.content isKindOfClass:[JLHeartBeatMessage class]]) {
        //        JLHeartBeatMessage *recommendMessage = (JLHeartBeatMessage *)message.content;
        //        VideoViewController *controller = [[VideoViewController alloc] init];
        //        controller.modalPresentationStyle = 0;
        //        controller.channel = recommendMessage.channelId;
        //        controller.token = recommendMessage.userRtcToken;
        //        controller.isNeedPush = NO;
        //        controller.isHeartMatch = YES;
        //        controller.anchorID = recommendMessage.anchorId;
        //        controller.anchorRtcToken = recommendMessage.anchorRtcToken;
        //
        //        JLAnchorUserModel *anchorUserInfo = [[JLAnchorUserModel alloc] init];
        //        anchorUserInfo.userID = recommendMessage.anchorId;
        //        anchorUserInfo.nickName = recommendMessage.anchorNickName;
        //        anchorUserInfo.userCode = recommendMessage.anchorCode;
        //        anchorUserInfo.headFileName = recommendMessage.anchorHeadFileName;
        //        anchorUserInfo.country = recommendMessage.anchorCountry;
        //        anchorUserInfo.nationalFlagUrl = recommendMessage.anchorNationalFlagUrl;
        //        controller.anchorUserInfo = anchorUserInfo;
        //        [self presentViewController:controller animated:YES completion:nil];
        //        return;
        //    }
        //
        //    if ([message.content isKindOfClass:[JLVideoMessage class]]) {
        //        JLVideoMessage *customMessage = (JLVideoMessage *)message.content;
        //        NSLog(@"%@",customMessage);
        //    }
}

@end

    //
    //  JLWebViewController.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/15.
    //

#import "JLWebViewController.h"
#import "JLStorageUtil.h"
#import "VideoViewController.h"
#import "JLConversationViewController.h"
#import "JLUserService.h"
#import "JLUserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UIColor+HexColor.h"
#import <Masonry/Masonry.h>
#import "JLUserService.h"
#import "JLAPIService.h"
#import "JLRTCService.h"
#import "JLIMService.h"
#import "JLSystemConfigUtil.h"
#import "JLHeartMatchController.h"
#import "JLWeakScriptMessageDelegate.h"
#import "NSObject+CurrentNavigationViewController.h"
#import "Config.h"

@interface JLWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKUserContentController *userContentController;
@property (nonatomic, copy) NSString *heartbeatMatchPrice;
@property (nonatomic, copy) NSString *token;

/// 是否加载主播列表  NO 默认加载
@property (nonatomic, assign) BOOL isDefault;


@end

@implementation JLWebViewController



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = !self.isNavigation;
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
        //    self.navigationController.navigationBarHidden = NO;
}



    // 注意:参数为变化前的traitCollection
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
        // trait发生了改变
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            // 执行操作
        [self toSetTheme];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTheme];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toSetTheme) name:kNotificationWebThemeSuccess object:nil];

    NSDictionary *dict = [JLSystemConfigUtil getInfoWithHeartbeatMatchDict:@"HeartbeatMatchDict"];
    self.heartbeatMatchPrice = dict[@"heartbeatMatchPrice"];
    
    
    // 创建 WKWebView 配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES; // 允许内联播放
    config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone; // 不需要用户交互即可播放
                                                                                  // 创建 UserContentController（用于 JS 与 Native 交互）
    self.userContentController = [[WKUserContentController alloc] init];
    config.userContentController = self.userContentController;
        // 注册消息处理器
    [self registerMessageHandlers];
    
    
        // 创建 WKWebView
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES; // 允许手势后退前进
    [self.view addSubview:self.webView];
    
    
    
    // 进度条
    //    [self setupProgressView]
    self.navigationController.navigationBarHidden = !self.isNavigation;
    
    if (self.isNavigation == NO) {
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
            make.left.right.bottom.equalTo(self.view);
        }];
    }else{
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(kNavigationBar_Height);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    
    
    
    if (self.isDefault == NO) {
        
        NSString *baseUrl = [JLSystemConfigUtil getInfoWithH5String:@"baseUrl"];
        if (baseUrl && baseUrl.length > 0) {
            [self loadDefaultWeb:baseUrl];
        }

    }else{
        [self loadDefaultWeb:self.h5String];
    }
}




- (void)loadDefaultWeb:(NSString *)h5String{
    if (h5String.length > 0) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:h5String]];
        [self.webView loadRequest:request];
    }
}


- (void)setH5String:(NSString *)h5String{
    _h5String = h5String;
    self.isDefault = YES;
}




- (void)initTheme{
    if ([JLIMService shared].isInterfaceStyle == YES) {
        
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                // 当前是深色模式
            if (@available(iOS 13.0, *)) {
//                self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
                self.view.backgroundColor = [UIColor blackColor];
                [JLIMService shared].model = @"2";
            } else {
                self.view.backgroundColor = [UIColor whiteColor];
            }
        } else {
                // 当前不是深色模式
            if (@available(iOS 13.0, *)) {
//                self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
                self.view.backgroundColor = [UIColor whiteColor];
                [JLIMService shared].model = @"1";
            } else {
                self.view.backgroundColor = [UIColor whiteColor];
            }
        }
        
    }else{
            // 判断皮肤颜色
        if ([[JLIMService shared].model isEqualToString:@"2"]) {
            if (@available(iOS 13.0, *)) {
//                self.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
                self.view.backgroundColor = [UIColor blackColor];
                [JLIMService shared].model = @"2";
            } else {
                self.view.backgroundColor = [UIColor whiteColor];
            }
            
        }else{
            
            if (@available(iOS 13.0, *)) {
//                self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
                self.view.backgroundColor = [UIColor whiteColor];
                [JLIMService shared].model = @"1";
            } else {
                self.view.backgroundColor = [UIColor whiteColor];
            }
        }
    }

}




- (void)toSetTheme{
    [self initTheme];
    
    NSString *mode = @"";
    if ([[JLIMService shared].model isEqualToString:@"1"]) {
        mode = @"light";
    }else{
        mode = @"dark";
    }
    
    NSDictionary *dict = @{@"theme":mode};
    NSString *jsonString = [dict modelToJSONString];
    NSString *js = [NSString stringWithFormat:@"%@(%@)", @"setTheme", jsonString];
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];

}






- (void)registerMessageHandlers {
        // 注册各种消息处理器
    
        // 使用 WeakScriptMessageDelegate 避免循环引用
    JLWeakScriptMessageDelegate *weakDelegate =
    [[JLWeakScriptMessageDelegate alloc] initWithDelegate:self];
    
    
    [self.userContentController addScriptMessageHandler:weakDelegate name:@"handleNativeParams"];    // 初始化APP参数
    [self.userContentController addScriptMessageHandler:weakDelegate name:@"goHeartMatch"]; // 打开匹配
    [self.userContentController addScriptMessageHandler:weakDelegate name:@"showToast"]; // 吐司
    [self.userContentController addScriptMessageHandler:weakDelegate name:@"openSettings"]; // 打开设置
    [self.userContentController addScriptMessageHandler:weakDelegate name:@"goSubscribeVip"]; //跳转订阅界面
    [self.userContentController addScriptMessageHandler:weakDelegate name:@"recommendVideoCall"]; // 推荐通话
    [self.userContentController addScriptMessageHandler:weakDelegate name:@"closePage"]; // 关闭界面
    [self.userContentController addScriptMessageHandler:weakDelegate name:@"navigateToChat"]; // 跳转聊天
    [self.userContentController addScriptMessageHandler:weakDelegate name:@"startVideoCall"]; // 跳转通话
    [self.userContentController addScriptMessageHandler:weakDelegate name:@"goNewPageH5"]; // 跳转H5
    
    [self.userContentController addScriptMessageHandler:weakDelegate name:@"openNotifications"]; // 通知
    [self.userContentController addScriptMessageHandler:weakDelegate name:@"qoToCheckInCenter"]; // 任务中心
}




- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *schemeStr = navigationAction.request.URL.scheme;
    NSString *queryStr = navigationAction.request.URL.query;
    
    NSMutableURLRequest *request = (NSMutableURLRequest *)navigationAction.request;
    
    if ([webView canGoBack]) {
        self.navigationController.navigationBar.hidden = YES;
    }else {
        self.navigationController.navigationBar.hidden = NO;
    }
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
    return;
}



    // 接收来自 JavaScript 的消息
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"收到 JavaScript 消息: name=%@, body=%@", message.name, message.body);
    
    
        // 初始化APP参数
    if ([message.name isEqualToString:@"handleNativeParams"]) {
        
        NSString *callback = message.body[@"callback"];
        
        NSString *resetStr =  [NSString stringWithFormat:@"%ld",(long long)([[NSDate date] timeIntervalSince1970] * 1000.0)];
        UIDevice *device = [UIDevice currentDevice];
        NSString *uuid = [[NSUUID UUID] UUIDString];
        
        
        
        NSDictionary *dict = @{
            @"reset":resetStr,
            @"sessionid":[NSString stringWithFormat:@"%ld",[JLUserService shared].userInfo.userID],
            @"userid":[NSString stringWithFormat:@"%ld",[JLUserService shared].userInfo.userID],
            @"lang":@"en",
            @"devicetype":@"ios",
            //            @"bladeAuth":[JLStorageUtil userToken],
            @"bladeAuth":[JLStorageUtil userToken],
            //            @"versioncode":@"1.0.0",
            @"heartbeatMatchPrice":[NSString stringWithFormat:@"%@",self.heartbeatMatchPrice],
            @"deviceid":uuid,
            @"mode":[JLIMService shared].model,// 皮肤  @"1" : 黑色  @"2" : @"白色"
            @"model":device.name,
            @"appname":@"lovespouse"
        };
        
        NSString *jsonString = @"";
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
        if (!jsonData) {
            NSLog(@"转换为JSON字符串时出错: %@", error);
        } else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        
            // 构造 JavaScript 代码，调用 receiveToken 函数
        NSString *js = [NSString stringWithFormat:@"%@(%@)", callback, jsonString];
        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
            NSLog(@"%@",error);
        }];
        
        return;
    }
    
    
    
        /// 跳转通话
    if ([message.name isEqualToString:@"startVideoCall"]) {
        NSString *jlAnchorId =  message.body[@"jlAnchorId"];
        
        if (jlAnchorId) {
                // 拨打视频
            [[JLRTCService shared] videoCallWithAnchorID:[jlAnchorId integerValue] success:^(NSString * _Nonnull channel, NSString * _Nonnull token,JLAnchorUserModel * _Nonnull anchorUserInfo) {
                VideoViewController *controller = [[VideoViewController alloc] init];
                controller.modalPresentationStyle = 0;
                controller.channel = channel;
                controller.token = token;
                controller.isNeedPush = YES;
                controller.anchorID = [jlAnchorId integerValue];
                controller.anchorRtcToken = @"";
                controller.anchorUserInfo = anchorUserInfo;
                [self presentViewController:controller animated:YES completion:nil];
                
            } failued:^(NSError * _Nonnull error) {
                
            }];
        }
        
        return;
    }
    
    
        /// 跳转私聊
    if ([message.name isEqualToString:@"navigateToChat"]) {
        NSString *jlAnchorId =  message.body[@"jlAnchorId"];
        
        if (jlAnchorId) {
            JLConversationViewController *conversationVC = [[JLConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:jlAnchorId];
                //            conversationVC.title = model.conversationTitle;
            conversationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:conversationVC animated:YES];
        }
        return;
    }
    
    
        /// 调用H5方法
    if ([message.name isEqualToString:@"goNewPageH5"]) {
        NSString *url =  message.body[@"url"];
            //        url = @"https://testh5.yiimeet.com/#/recharge/list";
            // 重定向新URL
//        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        
        JLWebViewController *web = [[JLWebViewController alloc] init];
        web.h5String = url;
        web.isDefault = YES;
        web.isNavigation = NO;
        web.hidesBottomBarWhenPushed = YES;
        if ([NSObject currentNavigationController]) {
            [[NSObject currentNavigationController] pushViewController:web animated:YES];
        }
    }
    
    
    
        /// 心动速配
    if ([message.name isEqualToString:@"goHeartMatch"]) {
        JLHeartMatchController *vc = [[JLHeartMatchController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
        //
    if ([message.name isEqualToString:@"goSubscribeVip"]) {
            // 处理
        
    }
    
    
    if ([message.name isEqualToString:@"closePage"]) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
}


    // 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}


- (void)setupProgressView {
        // 创建进度条
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height,
                                         self.view.frame.size.width, 2);
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.progressTintColor = [UIColor blueColor];
    [self.navigationController.navigationBar addSubview:self.progressView];
    
        // KVO 监听加载进度
//    [self.webView addObserver:self
//                   forKeyPath:@"estimatedProgress"
//                      options:NSKeyValueObservingOptionNew
//                      context:nil];
}

    // KVO 回调
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
//                       context:(void *)context {
//    if ([keyPath isEqualToString:@"estimatedProgress"]) {
//        float progress = [change[NSKeyValueChangeNewKey] floatValue];
//        [self.progressView setProgress:progress animated:YES];
//        
//        if (progress >= 1.0) {
//            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                self.progressView.alpha = 0;
//            } completion:^(BOOL finished) {
//                [self.progressView setProgress:0 animated:NO];
//            }];
//        } else {
//            self.progressView.alpha = 1.0;
//        }
//    }
//}



    // 记得移除观察者
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"JLWebViewController 销毁");
//    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}



@end

    //
    //  JLWebViewController.h
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/15.
    //

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JLWebViewController : UIViewController

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) NSString *h5String;

/// 是否隐藏导航栏 默认:  NO   不显示
@property (nonatomic, assign) BOOL isNavigation;



@end

NS_ASSUME_NONNULL_END

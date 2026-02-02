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

@property (nonatomic, assign) BOOL isDefault;



@end

NS_ASSUME_NONNULL_END

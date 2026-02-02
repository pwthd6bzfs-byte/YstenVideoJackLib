//
//  JLWeakScriptMessageDelegate.h
//  YstenVideoJackLib
//
//  Created by percent on 2026/1/31.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface JLWeakScriptMessageDelegate : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)delegate;

@end

NS_ASSUME_NONNULL_END

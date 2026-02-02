//
//  JLWeakScriptMessageDelegate.m
//  YstenVideoJackLib
//
//  Created by percent on 2026/1/31.
//

#import "JLWeakScriptMessageDelegate.h"

@implementation JLWeakScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)delegate {
    self = [super init];
    if (self) {
        _scriptDelegate = delegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end




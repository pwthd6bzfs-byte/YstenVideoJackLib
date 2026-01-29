//
//  UIView+ViewController.h
//  LJChatSDK
//
//  Created by percent on 2026/1/26.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSObject (CurrentViewController)

    // 获取当前显示的 ViewController
+ (UIViewController *)currentViewController;

    // 获取当前导航控制器
+ (UINavigationController *)currentNavigationController;

    // 获取当前 TabBar 控制器
+ (UITabBarController *)currentTabBarController;

    // 获取当前 ViewController 所在的 Window
+ (UIWindow *)currentWindow;

    // 获取当前 ViewController 的视图
+ (UIView *)currentView;

    // 获取指定 Window 的当前 ViewController
+ (UIViewController *)currentViewControllerInWindow:(UIWindow *)window;

    // 检查当前是否是特定类型的 ViewController
+ (BOOL)isCurrentViewControllerOfClass:(Class)targetClass;

@end
NS_ASSUME_NONNULL_END

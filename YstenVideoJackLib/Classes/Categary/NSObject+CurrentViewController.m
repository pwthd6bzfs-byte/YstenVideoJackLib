//
//  UIView+ViewController.m
//  LJChatSDK
//
//  Created by percent on 2026/1/26.
//

    // NSObject+CurrentViewController.m
#import "NSObject+CurrentViewController.h"

@implementation NSObject (CurrentViewController)

#pragma mark - 获取 KeyWindow

+ (UIWindow *)keyWindow {
    UIWindow *keyWindow = nil;
    
        // iOS 13+ 处理多个 scene
    if (@available(iOS 13.0, *)) {
        NSArray<UIWindowScene *> *windowScenes = [UIApplication sharedApplication].connectedScenes.allObjects;
        
        for (UIWindowScene *scene in windowScenes) {
                // 获取前景活跃的 scene
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
            
            if (keyWindow) break;
        }
    } else {
            // iOS 13 之前
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    
        // 备选方案：使用 delegate 的 window
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].delegate.window;
    }
    
        // 如果还没有，尝试获取第一个 window
    if (!keyWindow && [UIApplication sharedApplication].windows.count > 0) {
        keyWindow = [[UIApplication sharedApplication].windows firstObject];
    }
    
    return keyWindow;
}

#pragma mark - 递归获取顶层 ViewController

+ (UIViewController *)getTopViewControllerFrom:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
            // TabBarController
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self getTopViewControllerFrom:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            // NavigationController
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self getTopViewControllerFrom:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
            // 有模态视图
        return [self getTopViewControllerFrom:rootViewController.presentedViewController];
    } else {
            // 普通 ViewController
        return rootViewController;
    }
}

#pragma mark - 主要方法

    // 获取当前显示的 ViewController
+ (UIViewController *)currentViewController {
    UIWindow *keyWindow = [self keyWindow];
    if (!keyWindow) return nil;
    
    UIViewController *rootVC = keyWindow.rootViewController;
    if (!rootVC) return nil;
    
    return [self getTopViewControllerFrom:rootVC];
}

    // 获取当前导航控制器
+ (UINavigationController *)currentNavigationController {
        // 从当前 ViewController 向上查找
    UIViewController *currentVC = [self currentViewController];
    
    while (currentVC) {
        if ([currentVC isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)currentVC;
        }
        if (currentVC.navigationController) {
            return currentVC.navigationController;
        }
        currentVC = currentVC.parentViewController;
    }
    
        // 尝试从 rootViewController 开始查找
    UIWindow *keyWindow = [self keyWindow];
    UIViewController *rootVC = keyWindow.rootViewController;
    
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)rootVC;
    }
    
    return nil;
}

    // 获取当前 TabBar 控制器
+ (UITabBarController *)currentTabBarController {
        // 从当前 ViewController 向上查找
    UIViewController *currentVC = [self currentViewController];
    
    while (currentVC) {
        if ([currentVC isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)currentVC;
        }
        if (currentVC.tabBarController) {
            return currentVC.tabBarController;
        }
        currentVC = currentVC.parentViewController;
    }
    
        // 尝试从 rootViewController 开始查找
    UIWindow *keyWindow = [self keyWindow];
    UIViewController *rootVC = keyWindow.rootViewController;
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        return (UITabBarController *)rootVC;
    }
    
    return nil;
}

    // 获取当前 ViewController 所在的 Window
+ (UIWindow *)currentWindow {
    UIViewController *currentVC = [self currentViewController];
    
        // 通过 ViewController 的 view 获取 window
    if (currentVC && currentVC.view.window) {
        return currentVC.view.window;
    }
    
        // 备选方案
    return [self keyWindow];
}

    // 获取当前 ViewController 的视图
+ (UIView *)currentView {
    UIViewController *currentVC = [self currentViewController];
    return currentVC.view;
}

    // 获取指定 Window 的当前 ViewController
+ (UIViewController *)currentViewControllerInWindow:(UIWindow *)window {
    if (!window) return nil;
    
    UIViewController *rootVC = window.rootViewController;
    if (!rootVC) return nil;
    
    return [self getTopViewControllerFrom:rootVC];
}

    // 检查当前是否是特定类型的 ViewController
+ (BOOL)isCurrentViewControllerOfClass:(Class)targetClass {
    UIViewController *currentVC = [self currentViewController];
    return [currentVC isKindOfClass:targetClass];
}

@end

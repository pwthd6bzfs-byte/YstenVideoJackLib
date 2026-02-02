//
//  UINavigationViewController.m
//  YstenVideoJackLib
//
//  Created by percent on 2026/2/2.
//

#import "NSObject+CurrentNavigationViewController.h"

@implementation NSObject (CurrentNavigationViewController)

    // 工具类方法
+ (UINavigationController *)currentNavigationController {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self getCurrentNavigationControllerFromViewController:rootViewController];
}

+ (UINavigationController *)getCurrentNavigationControllerFromViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)viewController;
    }
    
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self getCurrentNavigationControllerFromViewController:tabBarController.selectedViewController];
    }
    
    if (viewController.presentedViewController) {
        return [self getCurrentNavigationControllerFromViewController:viewController.presentedViewController];
    }
    
    if (viewController.childViewControllers.count > 0) {
            // 查找可见的子控制器
        for (UIViewController *childVC in viewController.childViewControllers) {
            if (childVC.view.window) {
                return [self getCurrentNavigationControllerFromViewController:childVC];
            }
        }
    }
    
    return viewController.navigationController;
}


@end



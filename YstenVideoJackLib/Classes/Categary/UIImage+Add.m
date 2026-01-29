//
//  UIImage+Add.m
//  LJChatSDK
//
//  Created by percent on 2026/1/29.
//

#import "UIImage+Add.h"

@implementation UIImage (Add)


+ (UIImage *)jl_name:(NSString *)name class:(NSObject *)obj{
    NSBundle *bundle = [NSBundle bundleForClass:[obj class]];
    NSURL *bundleURL = [bundle URLForResource:@"LJChatSDK" withExtension:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    
    return [self imageNamed:name inBundle:resourceBundle compatibleWithTraitCollection:nil];
}

@end

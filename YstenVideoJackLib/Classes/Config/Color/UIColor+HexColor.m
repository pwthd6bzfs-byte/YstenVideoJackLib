//
//  UIColor+HexColor.m
//  AFNetworking
//
//  Created by percent on 2026/1/8.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) return [UIColor clearColor];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return [UIColor clearColor];
    NSRange range;
    range.location = 0; range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2; NSString *gString = [cString substringWithRange:range];
    range.location = 4; NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0) green:((float)g / 255.0) blue:((float)b / 255.0) alpha:alpha];
}
+ (UIColor *)colorWithHexString:(NSString *)color {
    return [self colorWithHexString:color alpha:1.0];
}
@end

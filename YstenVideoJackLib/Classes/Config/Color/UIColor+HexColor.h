//
//  UIColor+HexColor.h
//  AFNetworking
//
//  Created by percent on 2026/1/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HexColor)
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
@end
NS_ASSUME_NONNULL_END

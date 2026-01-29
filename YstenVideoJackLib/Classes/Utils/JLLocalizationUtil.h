//
//  JLLocalizationUtil.h
//  JuliFramework
//
//  Created by percent on 2025/5/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLLocalizationUtil : NSObject

    /// 设置语言（如 @"zh-Hans", @"en"）
+ (void)setLanguage:(NSString *)languageCode;

    /// 读取多语言字符串
+ (NSString *)localizedStringForKey:(NSString *)key;

    /// 设置自定义翻译（App 可覆盖默认翻译）
+ (void)setCustomTranslations:(NSDictionary<NSString *, NSString *> *)translations;


@end

NS_ASSUME_NONNULL_END

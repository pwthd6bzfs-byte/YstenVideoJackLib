    //
    //  JLLocalizationUtil.m
    //  JuliFramework
    //
    //  Created by percent on 2025/5/14.
    //

#import "JLLocalizationUtil.h"

@implementation JLLocalizationUtil

static NSString *overrideLanguageCode = nil;
static NSDictionary *customTranslations = nil;

+ (NSBundle *)sdkBundle {
    NSBundle *mainBundle = [NSBundle bundleForClass:[JLLocalizationUtil class]];
    NSURL *bundleURL = [[NSBundle bundleForClass:[JLLocalizationUtil class]] URLForResource:@"JuliResource" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:bundleURL] ?: mainBundle;
}

+ (NSBundle *)localizedBundle {
    NSBundle *bundle = [self sdkBundle];
    if (overrideLanguageCode) {
        NSString *path = [bundle pathForResource:overrideLanguageCode ofType:@"lproj"];
        if (path) return [NSBundle bundleWithPath:path];
    }
    return bundle;
}

+ (NSString *)localizedStringForKey:(NSString *)key {
    if (customTranslations[key]) {
        return customTranslations[key];
    }
    
    NSString *localized = [[NSBundle mainBundle] localizedStringForKey:key value:nil table:nil];
    return localized ?: key;
}

+ (void)setLanguage:(NSString *)languageCode {
    overrideLanguageCode = [languageCode copy];
}

+ (void)setCustomTranslations:(NSDictionary<NSString *,NSString *> *)translations {
    customTranslations = [translations copy];
}
@end

//
//  FCUserCacheUtil.m
//  ConstellChat
//
//  Created by percent on 2024/5/9.
//

#import "JLUserUtil.h"

@implementation JLUserUtil

+ (void)saveInfoWithName:(NSString *)name avatar:(NSString *)avatar targetID:(NSInteger)targetID country:(NSString *)country {
    NSDictionary *infoDic = @{@"name":name,@"avatar":avatar,@"country":country};
    [[NSUserDefaults standardUserDefaults] setObject:infoDic forKey:[NSString stringWithFormat:@"%ld",targetID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSDictionary *)getInfoWithTargetID:(NSInteger)targetID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld",targetID]];
}

@end

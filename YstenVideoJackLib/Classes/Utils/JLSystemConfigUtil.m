//
//  JLSystemConfigUtil.m
//  LJChatSDK
//
//  Created by percent on 2026/1/28.
//

#import "JLSystemConfigUtil.h"

@implementation JLSystemConfigUtil


+ (void)saveInfoWithHeartbeatMatchDict:(NSDictionary *)HeartbeatMatchDict{
    [[NSUserDefaults standardUserDefaults] setObject:HeartbeatMatchDict forKey:@"HeartbeatMatchDict"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveInfoWithH5String:(NSString *)h5String{
    [[NSUserDefaults standardUserDefaults] setObject:h5String forKey:@"h5String"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSDictionary *)getInfoWithHeartbeatMatchDict:(NSString *)HeartbeatMatchDict {
    return [[NSUserDefaults standardUserDefaults] objectForKey:HeartbeatMatchDict];
}


+ (NSDictionary *)getInfoWithH5String:(NSString *)h5String {
    return [[NSUserDefaults standardUserDefaults] objectForKey:h5String];
}



@end

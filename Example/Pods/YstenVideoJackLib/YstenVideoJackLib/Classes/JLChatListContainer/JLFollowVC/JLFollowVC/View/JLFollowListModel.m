//
//  JLFollowModel.m
//  LJChatSDK
//
//  Created by percent on 2026/1/26.
//

#import "JLFollowListModel.h"


@implementation JLFollowModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID":@"id"};
}


@end


@implementation JLFollowListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"records" : [JLFollowModel class]
    };
}


@end

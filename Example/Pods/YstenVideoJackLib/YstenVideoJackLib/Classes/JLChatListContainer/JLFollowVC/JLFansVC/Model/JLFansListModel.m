//
//  JLFansModel.m
//  Generated Model
//
//  Created by iOS Model Generator
//

#import "JLFansListModel.h"



@implementation JLFansModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID":@"id"};
}


@end


@implementation JLFansListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"records" : [JLFansModel class]
    };
}


@end

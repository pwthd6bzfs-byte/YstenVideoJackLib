//
//  JLGiftModel.m
//  Pods
//
//  Created by percent on 2026/1/12.
//

#import "JLGiftListModel.h"

@implementation JLGiftModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID":@"id"};
}

@end




@implementation JLGiftListModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"giftsList" : [JLGiftModel class] // 指定属性orders对应的元素类型
    };
}


@end


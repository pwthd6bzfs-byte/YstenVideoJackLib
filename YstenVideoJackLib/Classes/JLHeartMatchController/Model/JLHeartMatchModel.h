//
//  JLHeartMatchModel.h
//  LJChatSDK
//
//  Created by percent on 2026/1/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JLHeartMatchModel : NSObject

@property (nonatomic, copy) NSArray *anchors;  // 速配主播列表
@property (nonatomic, copy) NSString *batchId; // 发起速配id
@property (nonatomic, assign) NSInteger *heartbeatMatchWaitTime; // 等待时间
@property (nonatomic, assign) NSInteger *heartbeatMatchPrice; // 匹配价格
@property (nonatomic, assign) NSInteger heartbeatMatchTimeOut; // 超时退出


@end



@interface JLSystemHeartMatchModel : NSObject

@property (nonatomic, assign) NSInteger *heartbeatMatchFreeTime; // 免费时间
@property (nonatomic, copy) NSString *heartbeatMatchPrice; // 匹配价格

@end


NS_ASSUME_NONNULL_END

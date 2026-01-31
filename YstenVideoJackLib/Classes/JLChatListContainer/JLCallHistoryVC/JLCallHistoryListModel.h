//
//  JLCallHistoryModel.h
//  Generated Model
//
//  Created by iOS Model Generator
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"
NS_ASSUME_NONNULL_BEGIN

    /// JLCallHistoryModel 模型类
@interface JLCallHistoryModel : NSObject

    /// id
@property (nonatomic, strong) NSString * ID;

    /// anchorUserId
@property (nonatomic, strong) NSString * anchorUserId;

    /// subStatus
@property (nonatomic, assign) NSInteger subStatus;

    /// onlineStatus
@property (nonatomic, strong) NSString * onlineStatus;

    /// sourceType
@property (nonatomic, strong) NSString * sourceType;

    /// answerTime
@property (nonatomic, strong) NSString * answerTime;

    /// vipFlag
@property (nonatomic, strong) NSString * vipFlag;

    /// videoStatus
@property (nonatomic, strong) NSString * videoStatus;

    /// createTime
@property (nonatomic, strong) NSString * createTime;

    /// nickName
@property (nonatomic, strong) NSString * nickName;

    /// endTime
@property (nonatomic, strong) NSString * endTime;

    /// headFileName
@property (nonatomic, strong) NSString * headFileName;

    /// duration
@property (nonatomic, strong) NSString * duration;

    /// beginTime
@property (nonatomic, strong) NSString * beginTime;

    /// userCode
@property (nonatomic, strong) NSString * userCode;

    /// gender
@property (nonatomic, strong) NSString * gender;

    /// userId
@property (nonatomic, strong) NSString * userId;


@end


@interface JLCallHistoryListModel : NSObject

@property (nonatomic, strong) NSMutableArray<JLCallHistoryModel *> *records;

@end



NS_ASSUME_NONNULL_END

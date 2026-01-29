    //
    //  JLFansModel.h
    //  Generated Model
    //
    //  Created by iOS Model Generator
    //

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

    /// JLFansModel 模型类
@interface JLFansModel : NSObject

    /// followGender
@property (nonatomic, strong) NSString * followGender;

    /// nickName
@property (nonatomic, strong) NSString * nickName;

    /// birthday
@property (nonatomic, strong) NSString * birthday;

    /// ageStr
@property (nonatomic, strong) NSString * ageStr;

    /// country
@property (nonatomic, strong) NSString * country;

    /// updateTime
@property (nonatomic, strong) NSString * updateTime;

    /// followNickName
@property (nonatomic, strong) NSString * followNickName;

    /// vipFlag
@property (nonatomic, strong) NSString * vipFlag;

    /// followUserRole
@property (nonatomic, strong) NSString * followUserRole;

    /// followCountry
@property (nonatomic, strong) NSString * followCountry;

    /// nationalFlagUrl
@property (nonatomic, strong) NSString * nationalFlagUrl;

    /// id
@property (nonatomic, strong) NSString * identifier;

    /// headFileName
@property (nonatomic, strong) NSString * headFileName;

    /// gender
@property (nonatomic, strong) NSString * gender;

    /// level
@property (nonatomic, strong) NSString * level;

    /// followFlag
@property (nonatomic, strong) NSString * followFlag;

    /// onlineStatus
@property (nonatomic, strong) NSString * onlineStatus;

    /// showVideoUrl
@property (nonatomic, strong) NSString * showVideoUrl;

    /// videoPrice
@property (nonatomic, assign) NSInteger videoPrice;

    /// followNationalFlagUrl
@property (nonatomic, strong) NSString * followNationalFlagUrl;

    /// userRole
@property (nonatomic, strong) NSString * userRole;

    /// age
@property (nonatomic, assign) NSInteger age;

    /// followUserId
@property (nonatomic, strong) NSString * followUserId;

    /// createTime
@property (nonatomic, strong) NSString * createTime;

    /// followHeadFileName
@property (nonatomic, strong) NSString * followHeadFileName;

    /// userId
@property (nonatomic, strong) NSString * userId;


@end



    /// JLFansModel 模型类
@interface JLFansListModel : NSObject

@property (nonatomic, strong) NSMutableArray<JLFansModel *> *records;


@end

NS_ASSUME_NONNULL_END

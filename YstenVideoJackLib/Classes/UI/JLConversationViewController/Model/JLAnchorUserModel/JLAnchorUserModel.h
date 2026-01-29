//
//  JLAnchorUserModel.h
//  Generated Model
//
//  Created by iOS Model Generator
//

#import <Foundation/Foundation.h>
#import "NSObject+YYModel.h"
#import "AnchorFileListModel.h"
#import "AnchorFileOtherListModel.h"
#import "TrendsModel.h"

NS_ASSUME_NONNULL_BEGIN

/// JLAnchorUserModel 模型类
@interface JLAnchorUserModel : NSObject

/// age
@property (nonatomic, strong) NSString * age;

/// anchorFileList
@property (nonatomic, strong) NSArray<AnchorFileListModel *> *anchorFileList;

/// anchorFileOtherList
@property (nonatomic, strong) NSArray<AnchorFileOtherListModel *> *anchorFileOtherList;

/// anchorLevel
@property (nonatomic, assign) NSInteger anchorLevel;

/// anchorLevelName
@property (nonatomic, strong) NSString * anchorLevelName;

/// auditFlag
@property (nonatomic, strong) NSString * auditFlag;

/// auditVideo
@property (nonatomic, strong) NSString * auditVideo;

/// bizFlag
@property (nonatomic, assign) NSInteger bizFlag;

/// body
@property (nonatomic, strong) NSString * body;

/// coinVideoPrice
@property (nonatomic, assign) NSInteger coinVideoPrice;

/// country
@property (nonatomic, strong) NSString * country;

/// coverVideoUrl
@property (nonatomic, strong) NSString * coverVideoUrl;

/// coverVideoUrlStatus
@property (nonatomic, strong) NSString * coverVideoUrlStatus;

/// devices
@property (nonatomic, strong) NSString * devices;

/// devicesNum
@property (nonatomic, assign) NSInteger devicesNum;

/// email
@property (nonatomic, strong) NSString * email;

/// fansNum
@property (nonatomic, assign) NSInteger fansNum;

/// followFlag
@property (nonatomic, strong) NSString * followFlag;

/// followNum
@property (nonatomic, assign) NSInteger followNum;

/// gender
@property (nonatomic, strong) NSString * gender;

/// groundAuditStatus
@property (nonatomic, strong) NSString * groundAuditStatus;

/// groundFileName
@property (nonatomic, strong) NSString * groundFileName;

/// headAuditStatus
@property (nonatomic, strong) NSString * headAuditStatus;

/// headFileName
@property (nonatomic, strong) NSString * headFileName;

/// height
@property (nonatomic, strong) NSString * height;

/// highGroundFileName
@property (nonatomic, strong) NSString * highGroundFileName;

/// highGroundStatus
@property (nonatomic, strong) NSString * highGroundStatus;

/// id
@property (nonatomic,assign) NSInteger userID;

/// imageNum
@property (nonatomic, assign) NSInteger imageNum;

/// incomeDiamond
@property (nonatomic, assign) NSInteger incomeDiamond;

/// incomeDiamondDecimal
@property (nonatomic, assign) NSInteger incomeDiamondDecimal;

/// intro
@property (nonatomic, strong) NSString * intro;

/// introAuditStatus
@property (nonatomic, strong) NSString * introAuditStatus;

/// language
@property (nonatomic, strong) NSString * language;

/// lastIp
@property (nonatomic, strong) NSString * lastIp;

/// levelIcon
@property (nonatomic, strong) NSString * levelIcon;

/// minuteVideoIncome
@property (nonatomic, assign) NSInteger minuteVideoIncome;

/// momentNum
@property (nonatomic, assign) NSInteger momentNum;

/// nationalFlagUrl
@property (nonatomic, strong) NSString * nationalFlagUrl;

/// nickName
@property (nonatomic, strong) NSString * nickName;

/// onlineStatus
@property (nonatomic, strong) NSString * onlineStatus;

/// phone
@property (nonatomic, strong) NSString * phone;

/// power
@property (nonatomic, strong) NSString * power;

/// remark
@property (nonatomic, strong) NSString * remark;

/// roomTitle
@property (nonatomic, strong) NSString * roomTitle;

/// rtcUid
@property (nonatomic, assign) NSInteger rtcUid;

/// showVideoId
@property (nonatomic, assign) NSInteger showVideoId;

/// showVideoUrl
@property (nonatomic, strong) NSString * showVideoUrl;

/// showVideoUrlStatus
@property (nonatomic, strong) NSString * showVideoUrlStatus;

/// status
@property (nonatomic, strong) NSString * status;

/// subsidized
@property (nonatomic, assign) BOOL subsidized;

/// trends
@property (nonatomic, strong) NSArray<TrendsModel *> *trends;

/// trendsNum
@property (nonatomic, assign) NSInteger trendsNum;

/// unionId
@property (nonatomic, assign) NSInteger unionId;

/// unionName
@property (nonatomic, strong) NSString * unionName;

/// userCode
@property (nonatomic, strong) NSString * userCode;

/// username
@property (nonatomic, strong) NSString * username;

/// videoPrice
@property (nonatomic, assign) NSInteger videoPrice;

/// weibuVideoCoin
@property (nonatomic, assign) NSInteger weibuVideoCoin;

/// weight
@property (nonatomic, strong) NSString * weight;


@end

NS_ASSUME_NONNULL_END

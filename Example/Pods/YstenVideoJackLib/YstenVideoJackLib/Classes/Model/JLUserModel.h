//
//  JLUserModel.h
//  JuliFramework
//
//  Created by percent on 2025/3/31.
//

NS_ASSUME_NONNULL_BEGIN

@interface JLUserModel : NSObject

@property (nonatomic,assign) NSInteger userID;
@property (nonatomic,assign) NSInteger incomeDiamond;
@property (nonatomic,copy) NSString  *lastIp;
@property (nonatomic,copy) NSString  *level;
@property (nonatomic,assign) NSInteger msgSendNum;
@property (nonatomic,copy) NSString  *nickName;
@property (nonatomic,copy) NSString  *onlineStatus;
@property (nonatomic,copy) NSString  *country;
@property (nonatomic,assign) NSInteger diamond;
@property (nonatomic,assign) NSInteger diamondTotal;
@property (nonatomic,copy) NSString  *email;
@property (nonatomic,assign) NSInteger fansNum;
@property (nonatomic,copy) NSString  *firstFlag;
@property (nonatomic,assign) NSInteger firstRecharge;
@property (nonatomic,assign) NSInteger followNum;
@property (nonatomic,assign) NSInteger freeRanomMatch;
@property (nonatomic,assign) NSInteger freeVideoCall;
@property (nonatomic,copy) NSString  *gender;
@property (nonatomic,copy) NSString  *headFileName;
@property (nonatomic,copy) NSString  *phone;
@property (nonatomic,copy) NSString  *token;
@property (nonatomic,assign) NSInteger trendsNum;
@property (nonatomic,copy) NSString  *userCategory;
@property (nonatomic,copy) NSString  *userCode;
@property (nonatomic,copy) NSString  *username;
@property (nonatomic,assign) NSInteger videoPrice;
@property (nonatomic,copy) NSString  *vipExpireDay;
@property (nonatomic,copy) NSString  *vipExpireFlag;
@property (nonatomic,copy) NSString  *vipFlag;
@property (nonatomic,assign) NSInteger  coins;
@property (nonatomic, assign) NSInteger cardQuantity;


@end

NS_ASSUME_NONNULL_END

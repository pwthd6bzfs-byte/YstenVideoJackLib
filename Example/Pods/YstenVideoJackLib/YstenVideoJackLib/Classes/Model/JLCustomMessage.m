//
//  DCCustomMessage.m
//  GoMaster
//
//  Created by percent on 2024/1/27.
//

#import "JLCustomMessage.h"

@implementation JLCustomMessage

    ///初始化
+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                       giftCode:(NSString *)giftCode
                         userId:(NSString *)userId
                   userCategory:(NSString *)userCategory
                   headFileName:(NSString *)headFileName
                        giveNum:(NSString *)giveNum
                       nickName:(NSString *)nickName
                     followFlag:(NSString *)followFlag
                       userRole:(NSString *)userRole
                        tendsId:(NSString *)tendsId {
    JLCustomMessage *message = [[JLCustomMessage alloc] init];
    if (message) {
        message.type = type;
        message.channelId = channelId;
        message.giftCode = giftCode;
        message.userId = userId;
        message.userCategory = userCategory;
        message.headFileName = headFileName;
        message.giveNum = giveNum;
        message.nickName = nickName;
        message.followFlag = followFlag;
        message.userRole = userRole;
        message.tendsId = tendsId;
    }
    return message;
}

    ///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_NONE;
}

    /// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.channelId = [aDecoder decodeObjectForKey:@"channelId"];
        self.giftCode = [aDecoder decodeObjectForKey:@"giftCode"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userCategory = [aDecoder decodeObjectForKey:@"userCategory"];
        self.headFileName = [aDecoder decodeObjectForKey:@"headFileName"];
        self.giveNum = [aDecoder decodeObjectForKey:@"giveNum"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.followFlag = [aDecoder decodeObjectForKey:@"followFlag"];
        self.userRole = [aDecoder decodeObjectForKey:@"userRole"];
        self.tendsId = [aDecoder decodeObjectForKey:@"tendsId"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

    /// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.channelId forKey:@"channelId"];
    [aCoder encodeObject:self.giftCode forKey:@"giftCode"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userCategory forKey:@"userCategory"];
    [aCoder encodeObject:self.headFileName forKey:@"headFileName"];
    [aCoder encodeObject:self.giveNum forKey:@"giveNum"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.followFlag forKey:@"followFlag"];
    [aCoder encodeObject:self.userRole forKey:@"userRole"];
    [aCoder encodeObject:self.tendsId forKey:@"tendsId"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

    ///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.channelId forKey:@"channelId"];
    [dataDict setObject:self.giftCode forKey:@"giftCode"];
    [dataDict setObject:self.userId forKey:@"userId"];
    [dataDict setObject:self.userCategory forKey:@"userCategory"];
    [dataDict setObject:self.headFileName forKey:@"headFileName"];
    [dataDict setObject:self.giveNum forKey:@"giveNum"];
    [dataDict setObject:self.nickName forKey:@"nickName"];
    [dataDict setObject:self.followFlag forKey:@"followFlag"];
    [dataDict setObject:self.userRole forKey:@"userRole"];
    [dataDict setObject:self.tendsId forKey:@"tendsId"];
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}


    ///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.type = dictionary[@"type"];
            self.channelId = dictionary[@"channelId"];
            self.giftCode = dictionary[@"giftCode"];
            self.userId = dictionary[@"userId"];
            self.userCategory = dictionary[@"userCategory"];
            self.headFileName = dictionary[@"headFileName"];
            self.giveNum = dictionary[@"giveNum"];
            self.nickName = dictionary[@"nickName"];
            self.followFlag = dictionary[@"followFlag"];
            self.userRole = dictionary[@"userRole"];
            self.tendsId = dictionary[@"tendsId"];
            
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


    ///消息的类型名
+ (NSString *)getObjectName {
    return RCCustomMessageIdentifier;
}

@end


@implementation JLVideoMessage

+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                       duration:(NSString *)duration
                         userId:(NSString *)userId
                   userCategory:(NSString *)userCategory
                   headFileName:(NSString *)headFileName
                        giveNum:(NSString *)giveNum
                       nickName:(NSString *)nickName
                     followFlag:(NSString *)followFlag
                       userRole:(NSString *)userRole
                       anchorId:(NSString *)anchorId
                      subStatus:(NSString *)subStatus
                    videoStatus:(NSString *)videoStatus {
    JLVideoMessage *message = [[JLVideoMessage alloc] init];
    if (message) {
        message.type = type;
        message.channelId = channelId;
        message.duration = duration;
        message.userId = userId;
        message.headFileName = headFileName;
        message.giveNum = giveNum;
        message.nickName = nickName;
        message.followFlag = followFlag;
        message.userRole = userRole;
        message.anchorId = anchorId;
        message.videoStatus = videoStatus;
        message.subStatus = subStatus;
    }
    return message;
}


    ///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return  MessagePersistent_ISCOUNTED;
}

    /// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.channelId = [aDecoder decodeObjectForKey:@"channelId"];
        self.duration = [aDecoder decodeObjectForKey:@"duration"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.headFileName = [aDecoder decodeObjectForKey:@"headFileName"];
        self.giveNum = [aDecoder decodeObjectForKey:@"giveNum"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.followFlag = [aDecoder decodeObjectForKey:@"followFlag"];
        self.userRole = [aDecoder decodeObjectForKey:@"userRole"];
        self.anchorId = [aDecoder decodeObjectForKey:@"anchorId"];
        self.videoStatus = [aDecoder decodeObjectForKey:@"videoStatus"];
        self.subStatus = [aDecoder decodeObjectForKey:@"subStatus"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

    /// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.channelId forKey:@"channelId"];
    [aCoder encodeObject:self.duration forKey:@"duration"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.headFileName forKey:@"headFileName"];
    [aCoder encodeObject:self.giveNum forKey:@"giveNum"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.followFlag forKey:@"followFlag"];
    [aCoder encodeObject:self.userRole forKey:@"userRole"];
    [aCoder encodeObject:self.anchorId forKey:@"anchorId"];
    [aCoder encodeObject:self.videoStatus forKey:@"videoStatus"];
    [aCoder encodeObject:self.subStatus forKey:@"subStatus"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    
}

    ///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.channelId forKey:@"channelId"];
    [dataDict setObject:self.duration forKey:@"duration"];
    [dataDict setObject:self.userId forKey:@"userId"];
    [dataDict setObject:self.headFileName forKey:@"headFileName"];
    [dataDict setObject:self.giveNum forKey:@"giveNum"];
    [dataDict setObject:self.nickName forKey:@"nickName"];
    [dataDict setObject:self.followFlag forKey:@"followFlag"];
    [dataDict setObject:self.userRole forKey:@"userRole"];
    [dataDict setObject:self.anchorId forKey:@"anchorId"];
    [dataDict setObject:self.videoStatus forKey:@"videoStatus"];
    [dataDict setObject:self.subStatus forKey:@"subStatus"];

    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}


    ///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.type = dictionary[@"type"];
            self.channelId = dictionary[@"channelId"];
            self.duration = dictionary[@"duration"];
            self.userId = dictionary[@"userId"];
            self.headFileName = dictionary[@"headFileName"];
            self.giveNum = dictionary[@"giveNum"];
            self.nickName = dictionary[@"nickName"];
            self.followFlag = dictionary[@"followFlag"];
            self.userRole = dictionary[@"userRole"];
            self.anchorId = dictionary[@"anchorId"];
            self.videoStatus = dictionary[@"videoStatus"];
            self.subStatus = dictionary[@"subStatus"];
            
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


    ///消息的类型名
+ (NSString *)getObjectName {
    return RCVideoMessageIdentifier;
}


@end


@implementation JLGiftMessage

+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                         giftId:(NSString *)giftId
                       giftCode:(NSString *)giftCode
                         userId:(NSNumber *)userId
                   userCategory:(NSString *)userCategory
                        giveNum:(NSString *)giveNum
                       nickName:(NSString *)nickName
                       userRole:(NSString *)userRole
                        giftUrl:(NSString *)giftUrl
                       giftName:(NSString *)giftName
                      giftPrice:(NSString *)giftPrice
                    giftSvgaUrl:(NSString *)giftSvgaUrl {
    JLGiftMessage *message = [[JLGiftMessage alloc] init];
    if (message) {
        message.type = type;
        message.giftId = giftId;
        message.channelId = channelId;
        message.giftCode = giftCode;
        message.userId = userId;
        message.userCategory = userCategory;
        message.giveNum = giveNum;
        message.nickName = nickName;
        message.userRole = userRole;
        message.giftUrl = giftUrl;
        message.giftName = giftName;
        message.giftPrice = giftPrice;
        message.giftSvgaUrl = giftSvgaUrl;
    }
    return message;
}

    ///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISCOUNTED;
}

    /// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.channelId = [aDecoder decodeObjectForKey:@"channelId"];
        self.giftId = [aDecoder decodeObjectForKey:@"giftId"];
        self.giftCode = [aDecoder decodeObjectForKey:@"giftCode"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userCategory = [aDecoder decodeObjectForKey:@"userCategory"];
        self.giveNum = [aDecoder decodeObjectForKey:@"giveNum"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.userRole = [aDecoder decodeObjectForKey:@"userRole"];
        self.giftUrl = [aDecoder decodeObjectForKey:@"giftUrl"];
        self.giftName = [aDecoder decodeObjectForKey:@"giftName"];
        self.giftPrice = [aDecoder decodeObjectForKey:@"giftPrice"];
        self.giftSvgaUrl = [aDecoder decodeObjectForKey:@"giftSvgaUrl"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

    /// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.channelId forKey:@"channelId"];
    [aCoder encodeObject:self.giftId forKey:@"giftId"];
    [aCoder encodeObject:self.giftCode forKey:@"giftCode"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userCategory forKey:@"userCategory"];
    [aCoder encodeObject:self.giveNum forKey:@"giveNum"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.userRole forKey:@"userRole"];
    [aCoder encodeObject:self.giftUrl forKey:@"giftUrl"];
    [aCoder encodeObject:self.giftName forKey:@"giftName"];
    [aCoder encodeObject:self.giftPrice forKey:@"giftPrice"];
    [aCoder encodeObject:self.giftSvgaUrl forKey:@"giftSvgaUrl"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    
}

    ///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.giftId forKey:@"giftId"];
    [dataDict setObject:self.giftCode forKey:@"giftCode"];
    [dataDict setObject:self.userId forKey:@"userId"];
    [dataDict setObject:self.nickName forKey:@"nickName"];
    [dataDict setObject:self.userRole forKey:@"userRole"];
    [dataDict setObject:self.giftUrl forKey:@"giftUrl"];
    [dataDict setObject:self.giftName forKey:@"giftName"];
    [dataDict setObject:self.giftPrice forKey:@"giftPrice"];
    [dataDict setObject:self.giftSvgaUrl forKey:@"giftSvgaUrl"];
    
    if (self.channelId){
        [dataDict setObject:self.channelId forKey:@"channelId"];
    }
    
    if (self.giveNum){
        [dataDict setObject:self.giveNum forKey:@"giveNum"];
    }
    
    if (self.userCategory){
        [dataDict setObject:self.userCategory forKey:@"userCategory"];
    }
    
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}


    ///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.type = dictionary[@"type"];
            self.channelId = dictionary[@"channelId"];
            self.giftId = dictionary[@"giftId"];
            self.giftCode = dictionary[@"giftCode"];
            self.userId = dictionary[@"userId"];
            self.userCategory = dictionary[@"userCategory"];
            self.nickName = dictionary[@"nickName"];
            self.giveNum = dictionary[@"giveNum"];
            self.userRole = dictionary[@"userRole"];
            self.giftUrl = dictionary[@"giftUrl"];
            self.giftName = dictionary[@"giftName"];
            self.giftPrice = dictionary[@"giftPrice"];
            self.giftSvgaUrl = dictionary[@"giftSvgaUrl"];
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


    ///消息的类型名
+ (NSString *)getObjectName {
    return RCGiftMessageIdentifier;
}


@end


@implementation JLAskGiftMessage

+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                         giftId:(NSString *)giftId
                       giftCode:(NSString *)giftCode
                         userId:(NSString *)userId
                   userCategory:(NSString *)userCategory
                        giveNum:(NSString *)giveNum
                       nickName:(NSString *)nickName
                       userRole:(NSString *)userRole
                        giftUrl:(NSString *)giftUrl
                       giftName:(NSString *)giftName
                      giftPrice:(NSString *)giftPrice
                    giftSvgaUrl:(NSString *)giftSvgaUrl {
    JLAskGiftMessage *message = [[JLAskGiftMessage alloc] init];
    if (message) {
        message.type = type;
        message.channelId = channelId;
        message.giftId = giftId;
        message.giftCode = giftCode;
        message.userId = userId;
        message.userCategory = userCategory;
        message.giveNum = giveNum;
        message.nickName = nickName;
        message.userRole = userRole;
        message.giftUrl = giftUrl;
        message.giftName = giftName;
        message.giftPrice = giftPrice;
        message.giftSvgaUrl = giftSvgaUrl;
    }
    return message;
}

    ///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISCOUNTED;
}

    /// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.channelId = [aDecoder decodeObjectForKey:@"channelId"];
        self.giftId = [aDecoder decodeObjectForKey:@"giftId"];
        self.giftCode = [aDecoder decodeObjectForKey:@"giftCode"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userCategory = [aDecoder decodeObjectForKey:@"userCategory"];
        self.giveNum = [aDecoder decodeObjectForKey:@"giveNum"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.userRole = [aDecoder decodeObjectForKey:@"userRole"];
        self.giftUrl = [aDecoder decodeObjectForKey:@"giftUrl"];
        self.giftName = [aDecoder decodeObjectForKey:@"giftName"];
        self.giftPrice = [aDecoder decodeObjectForKey:@"giftPrice"];
        self.giftSvgaUrl = [aDecoder decodeObjectForKey:@"giftSvgaUrl"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

    /// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.channelId forKey:@"channelId"];
    [aCoder encodeObject:self.giftId forKey:@"giftId"];
    [aCoder encodeObject:self.giftCode forKey:@"giftCode"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userCategory forKey:@"userCategory"];
    [aCoder encodeObject:self.giveNum forKey:@"giveNum"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.userRole forKey:@"userRole"];
    [aCoder encodeObject:self.giftUrl forKey:@"giftUrl"];
    [aCoder encodeObject:self.giftName forKey:@"giftName"];
    [aCoder encodeObject:self.giftPrice forKey:@"giftPrice"];
    [aCoder encodeObject:self.giftSvgaUrl forKey:@"giftSvgaUrl"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    
}

    ///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.channelId forKey:@"channelId"];
    [dataDict setObject:self.giftId forKey:@"giftId"];
    [dataDict setObject:self.giftCode forKey:@"giftCode"];
    [dataDict setObject:self.userId forKey:@"userId"];
    [dataDict setObject:self.userCategory forKey:@"userCategory"];
    [dataDict setObject:self.giveNum forKey:@"giveNum"];
    [dataDict setObject:self.nickName forKey:@"nickName"];
    [dataDict setObject:self.userRole forKey:@"userRole"];
    [dataDict setObject:self.giftUrl forKey:@"giftUrl"];
    [dataDict setObject:self.giftName forKey:@"giftName"];
    [dataDict setObject:self.giftPrice forKey:@"giftPrice"];
    [dataDict setObject:self.giftSvgaUrl forKey:@"giftSvgaUrl"];
    
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}


    ///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.type = dictionary[@"type"];
            self.channelId = dictionary[@"channelId"];
            self.giftId = dictionary[@"giftId"];
            self.giftCode = dictionary[@"giftCode"];
            self.userId = dictionary[@"userId"];
            self.userCategory = dictionary[@"userCategory"];
            self.nickName = dictionary[@"nickName"];
            self.giveNum = dictionary[@"giveNum"];
            self.userRole = dictionary[@"userRole"];
            self.giftUrl = dictionary[@"giftUrl"];
            self.giftName = dictionary[@"giftName"];
            self.giftPrice = dictionary[@"giftPrice"];
            self.giftSvgaUrl = dictionary[@"giftSvgaUrl"];
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


    ///消息的类型名
+ (NSString *)getObjectName {
    return RCAskGiftMessageIdentifier;
}


@end

@implementation JLDeviceInviteMessage

+ (instancetype)messageWithType:(NSString *)type
                        content:(NSString *)content {
    JLDeviceInviteMessage *message = [[JLDeviceInviteMessage alloc] init];
    if (message) {
        message.type = type;
        message.content = content;
    }
    return message;
}

    ///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISCOUNTED;
}

    /// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

    /// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    
}

    ///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.content forKey:@"content"];
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}


    ///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.type = dictionary[@"type"];
            self.content = dictionary[@"content"];
   
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


    ///消息的类型名
+ (NSString *)getObjectName {
    return RCDeviceInviteMessageIdentifier;
}


@end


@implementation JLDeviceControlMessage

    ///初始化
+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                       giftCode:(NSString *)giftCode
                         userId:(NSString *)userId
                   userCategory:(NSString *)userCategory
                   headFileName:(NSString *)headFileName
                        giveNum:(NSString *)giveNum
                       nickName:(NSString *)nickName
                     followFlag:(NSString *)followFlag
                       userRole:(NSString *)userRole {
    JLDeviceControlMessage *message = [[JLDeviceControlMessage alloc] init];
    if (message) {
        message.type = type;
        message.channelId = channelId;
        message.userId = userId;
        message.userCategory = userCategory;
        message.headFileName = headFileName;
        message.giveNum = giveNum;
        message.nickName = nickName;
        message.followFlag = followFlag;
        message.userRole = userRole;
    }
    return message;
}

    ///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_STATUS;
}

    /// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.channelId = [aDecoder decodeObjectForKey:@"channelId"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userCategory = [aDecoder decodeObjectForKey:@"userCategory"];
        self.headFileName = [aDecoder decodeObjectForKey:@"headFileName"];
        self.giveNum = [aDecoder decodeObjectForKey:@"giveNum"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.followFlag = [aDecoder decodeObjectForKey:@"followFlag"];
        self.userRole = [aDecoder decodeObjectForKey:@"userRole"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

    /// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.channelId forKey:@"channelId"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userCategory forKey:@"userCategory"];
    [aCoder encodeObject:self.headFileName forKey:@"headFileName"];
    [aCoder encodeObject:self.giveNum forKey:@"giveNum"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.followFlag forKey:@"followFlag"];
    [aCoder encodeObject:self.userRole forKey:@"userRole"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

    ///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.channelId forKey:@"channelId"];
    [dataDict setObject:self.userId forKey:@"userId"];
    [dataDict setObject:self.userCategory forKey:@"userCategory"];
    [dataDict setObject:self.headFileName forKey:@"headFileName"];
    [dataDict setObject:self.giveNum forKey:@"giveNum"];
    [dataDict setObject:self.nickName forKey:@"nickName"];
    [dataDict setObject:self.followFlag forKey:@"followFlag"];
    [dataDict setObject:self.userRole forKey:@"userRole"];
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}


    ///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.type = dictionary[@"type"];
            self.channelId = dictionary[@"channelId"];
            self.userId = dictionary[@"userId"];
            self.userCategory = dictionary[@"userCategory"];
            self.headFileName = dictionary[@"headFileName"];
            self.giveNum = dictionary[@"giveNum"];
            self.nickName = dictionary[@"nickName"];
            self.followFlag = dictionary[@"followFlag"];
            self.userRole = dictionary[@"userRole"];
            
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


    ///消息的类型名
+ (NSString *)getObjectName {
    return RCDeviceControlMessageIdentifier;
}


@end


@implementation JLDeviceOrderMessage

    ///初始化
+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                         userId:(NSString *)userId
                   userCategory:(NSString *)userCategory
                   headFileName:(NSString *)headFileName
                        giveNum:(NSString *)giveNum
                       nickName:(NSString *)nickName
                     followFlag:(NSString *)followFlag
                       userRole:(NSString *)userRole
                        command:(NSString *)command {
    JLDeviceOrderMessage *message = [[JLDeviceOrderMessage alloc] init];
    if (message) {
        message.type = type;
        message.channelId = channelId;
        message.userId = userId;
        message.userCategory = userCategory;
        message.headFileName = headFileName;
        message.giveNum = giveNum;
        message.nickName = nickName;
        message.followFlag = followFlag;
        message.userRole = userRole;
        message.command = command;
    }
    return message;
}

    ///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_STATUS;
}

    /// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.channelId = [aDecoder decodeObjectForKey:@"channelId"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userCategory = [aDecoder decodeObjectForKey:@"userCategory"];
        self.headFileName = [aDecoder decodeObjectForKey:@"headFileName"];
        self.giveNum = [aDecoder decodeObjectForKey:@"giveNum"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.followFlag = [aDecoder decodeObjectForKey:@"followFlag"];
        self.userRole = [aDecoder decodeObjectForKey:@"userRole"];
        self.command = [aDecoder decodeObjectForKey:@"command"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

    /// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.channelId forKey:@"channelId"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userCategory forKey:@"userCategory"];
    [aCoder encodeObject:self.headFileName forKey:@"headFileName"];
    [aCoder encodeObject:self.giveNum forKey:@"giveNum"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.followFlag forKey:@"followFlag"];
    [aCoder encodeObject:self.userRole forKey:@"userRole"];
    [aCoder encodeObject:self.command forKey:@"command"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

    ///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.channelId forKey:@"channelId"];
    [dataDict setObject:self.userId forKey:@"userId"];
    [dataDict setObject:self.userCategory forKey:@"userCategory"];
    [dataDict setObject:self.headFileName forKey:@"headFileName"];
    [dataDict setObject:self.giveNum forKey:@"giveNum"];
    [dataDict setObject:self.nickName forKey:@"nickName"];
    [dataDict setObject:self.followFlag forKey:@"followFlag"];
    [dataDict setObject:self.userRole forKey:@"userRole"];
    [dataDict setObject:self.command forKey:@"command"];
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}


    ///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.type = dictionary[@"type"];
            self.channelId = dictionary[@"channelId"];
            self.userId = dictionary[@"userId"];
            self.userCategory = dictionary[@"userCategory"];
            self.headFileName = dictionary[@"headFileName"];
            self.giveNum = dictionary[@"giveNum"];
            self.nickName = dictionary[@"nickName"];
            self.followFlag = dictionary[@"followFlag"];
            self.userRole = dictionary[@"userRole"];
            self.command = dictionary[@"command"];
            
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


    ///消息的类型名
+ (NSString *)getObjectName {
    return RCDeviceOrderMessageIdentifier;
}


@end


@implementation JLRecommendMessage

///初始化
+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                       anchorId:(NSInteger )anchorId
                       userCode:(NSString *)userCode
                   headFileName:(NSString *)headFileName
                   showVideoUrl:(NSString *)showVideoUrl
                       nickName:(NSString *)nickName
                         gender:(NSString *)gender
                            age:(NSString *)age
                        country:(NSString *)country
                       showText:(NSString *)showText
                          token:(NSString *)token
                          price:(NSInteger )price
                     nationFlag:(NSString *)nationFlag; {
    JLRecommendMessage *message = [[JLRecommendMessage alloc] init];
    if (message) {
        message.type = type;
        message.channelId = channelId;
        message.anchorId = anchorId;
        message.userCode = userCode;
        message.headFileName = headFileName;
        message.showVideoUrl = showVideoUrl;
        message.nickName = nickName;
        message.gender = gender;
        message.age = age;
        message.country = country;
        message.showText = showText;
        message.token = token;
        message.price = price;
        message.nationFlag = nationFlag;
    }
    return message;
}

    ///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_STATUS;
}

    /// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.channelId = [aDecoder decodeObjectForKey:@"channelId"];
        self.anchorId = [[aDecoder decodeObjectForKey:@"anchorId"] integerValue];
        self.userCode = [aDecoder decodeObjectForKey:@"userCode"];
        self.headFileName = [aDecoder decodeObjectForKey:@"headFileName"];
        self.showVideoUrl = [aDecoder decodeObjectForKey:@"showVideoUrl"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.age = [aDecoder decodeObjectForKey:@"age"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
        self.showText = [aDecoder decodeObjectForKey:@"showText"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.price = [[aDecoder decodeObjectForKey:@"price"] integerValue];
        self.nationFlag = [aDecoder decodeObjectForKey:@"nationFlag"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

    /// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.channelId forKey:@"channelId"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.anchorId] forKey:@"anchorId"];
    [aCoder encodeObject:self.userCode forKey:@"userCode"];
    [aCoder encodeObject:self.headFileName forKey:@"headFileName"];
    [aCoder encodeObject:self.showVideoUrl forKey:@"showVideoUrl"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.age forKey:@"age"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.price] forKey:@"price"];
    [aCoder encodeObject:self.nationFlag forKey:@"nationFlag"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

    ///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.channelId forKey:@"channelId"];
    [dataDict setObject:[NSNumber numberWithInteger:self.anchorId] forKey:@"anchorId"];
    [dataDict setObject:self.userCode forKey:@"userCode"];
    [dataDict setObject:self.headFileName forKey:@"headFileName"];
    [dataDict setObject:self.showVideoUrl forKey:@"showVideoUrl"];
    [dataDict setObject:self.nickName forKey:@"nickName"];
    [dataDict setObject:self.gender forKey:@"gender"];
    [dataDict setObject:self.age forKey:@"age"];
    [dataDict setObject:self.country forKey:@"country"];
    [dataDict setObject:self.showText forKey:@"showText"];
    [dataDict setObject:self.token forKey:@"token"];
    [dataDict setObject:[NSNumber numberWithInteger:self.price] forKey:@"price"];
    [dataDict setObject:self.nationFlag forKey:@"nationFlag"];

    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

    ///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.type = dictionary[@"type"];
            self.channelId = dictionary[@"channelId"];
            self.anchorId = [dictionary[@"anchorId"] integerValue];
            self.userCode = dictionary[@"userCode"];
            self.headFileName = dictionary[@"headFileName"];
            self.showVideoUrl = dictionary[@"showVideoUrl"];
            self.nickName = dictionary[@"nickName"];
            self.gender = dictionary[@"gender"];
            self.age = dictionary[@"age"];
            self.country = dictionary[@"country"];
            self.showText = dictionary[@"showText"];
            self.token = dictionary[@"token"];
            self.price = [dictionary[@"price"] integerValue];
            self.nationFlag = dictionary[@"nationFlag"];

            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


    ///消息的类型名
+ (NSString *)getObjectName {
    return RCRecommendMessageIdentifier;
}


@end


@implementation JLHeartBeatMessage

    ///初始化
+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                     noticeTime:(NSString *)noticeTime
                       anchorId:(NSInteger )anchorId
                     anchorCode:(NSString *)anchorCode
             anchorHeadFileName:(NSString *)anchorHeadFileName
                 anchorNickName:(NSString *)anchorNickName
                  anchorCountry:(NSString *)anchorCountry
                 anchorRtcToken:(NSString *)anchorRtcToken
          anchorNationalFlagUrl:(NSString *)anchorNationalFlagUrl
                         userId:(NSInteger )userId
               userHeadFileName:(NSString *)userHeadFileName
                   userNickName:(NSString *)userNickName
                    userCountry:(NSString *)userCountry
                   userRtcToken:(NSString *)userRtcToken
            userNationalFlagUrl:(NSString *)userNationalFlagUrl
                     followFlag:(NSInteger )followFlag
                 coinVideoPrice:(NSInteger )coinVideoPrice
                     devicesNum:(NSInteger )devicesNum {
    JLHeartBeatMessage *message = [[JLHeartBeatMessage alloc] init];
    if (message) {
        message.type = type;
        message.channelId = channelId;
        message.noticeTime = noticeTime;
        message.anchorId = anchorId;
        message.anchorCode = anchorCode;
        message.anchorHeadFileName = anchorHeadFileName;
        message.anchorNickName = anchorNickName;
        message.anchorCountry = anchorCountry;
        message.anchorRtcToken = anchorRtcToken;
        message.anchorNationalFlagUrl = anchorNationalFlagUrl;
        message.userId = userId;
        message.userHeadFileName = userHeadFileName;
        message.userNickName = userNickName;
        message.userCountry = userCountry;
        message.userRtcToken = userRtcToken;
        message.userNationalFlagUrl = userNationalFlagUrl;
        message.followFlag = followFlag;
        message.coinVideoPrice = coinVideoPrice;
        message.devicesNum = devicesNum;

    }
    return message;
}

    ///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_STATUS;
}

    /// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.channelId = [aDecoder decodeObjectForKey:@"channelId"];
        self.noticeTime = [aDecoder decodeObjectForKey:@"noticeTime"];
        self.anchorId = [[aDecoder decodeObjectForKey:@"anchorId"] integerValue];
        self.anchorCode = [aDecoder decodeObjectForKey:@"anchorCode"];
        self.anchorHeadFileName = [aDecoder decodeObjectForKey:@"anchorHeadFileName"];
        self.anchorNickName = [aDecoder decodeObjectForKey:@"anchorNickName"];
        self.anchorCountry = [aDecoder decodeObjectForKey:@"anchorCountry"];
        self.anchorRtcToken = [aDecoder decodeObjectForKey:@"anchorRtcToken"];
        self.anchorNationalFlagUrl = [aDecoder decodeObjectForKey:@"anchorNationalFlagUrl"];
        self.userId = [[aDecoder decodeObjectForKey:@"userId"] integerValue];
        self.userHeadFileName = [aDecoder decodeObjectForKey:@"userHeadFileName"];
        self.userNickName = [aDecoder decodeObjectForKey:@"userNickName"];
        self.userCountry = [aDecoder decodeObjectForKey:@"userCountry"];
        self.userRtcToken = [aDecoder decodeObjectForKey:@"userRtcToken"];
        self.userNationalFlagUrl = [aDecoder decodeObjectForKey:@"userNationalFlagUrl"];
        self.followFlag = [[aDecoder decodeObjectForKey:@"followFlag"] integerValue];
        self.coinVideoPrice = [[aDecoder decodeObjectForKey:@"coinVideoPrice"] integerValue];
        self.devicesNum = [[aDecoder decodeObjectForKey:@"devicesNum"] integerValue];

        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

    /// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.channelId forKey:@"channelId"];
    [aCoder encodeObject:self.noticeTime forKey:@"noticeTime"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.anchorId] forKey:@"anchorId"];
    [aCoder encodeObject:self.anchorCode forKey:@"anchorCode"];
    [aCoder encodeObject:self.anchorHeadFileName forKey:@"anchorHeadFileName"];
    [aCoder encodeObject:self.anchorNickName forKey:@"anchorNickName"];
    [aCoder encodeObject:self.anchorCountry forKey:@"anchorCountry"];
    [aCoder encodeObject:self.anchorRtcToken forKey:@"anchorRtcToken"];
    [aCoder encodeObject:self.anchorNationalFlagUrl forKey:@"anchorNationalFlagUrl"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.userId] forKey:@"userId"];
    [aCoder encodeObject:self.userHeadFileName forKey:@"userHeadFileName"];
    [aCoder encodeObject:self.userNickName forKey:@"userNickName"];
    [aCoder encodeObject:self.userCountry forKey:@"userCountry"];
    [aCoder encodeObject:self.userRtcToken forKey:@"userRtcToken"];
    [aCoder encodeObject:self.userNationalFlagUrl forKey:@"userNationalFlagUrl"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.followFlag] forKey:@"followFlag"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.coinVideoPrice] forKey:@"coinVideoPrice"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.devicesNum] forKey:@"devicesNum"];

    [aCoder encodeObject:self.extra forKey:@"extra"];
}

    ///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.channelId forKey:@"channelId"];
    [dataDict setObject:self.noticeTime forKey:@"noticeTime"];
    [dataDict setObject:[NSNumber numberWithInteger:self.anchorId] forKey:@"anchorId"];
    [dataDict setObject:self.anchorCode forKey:@"anchorCode"];
    [dataDict setObject:self.anchorHeadFileName forKey:@"anchorHeadFileName"];
    [dataDict setObject:self.anchorNickName forKey:@"anchorNickName"];
    [dataDict setObject:self.anchorCountry forKey:@"anchorCountry"];
    [dataDict setObject:self.anchorRtcToken forKey:@"anchorRtcToken"];
    [dataDict setObject:self.anchorNationalFlagUrl forKey:@"anchorNationalFlagUrl"];
    [dataDict setObject:[NSNumber numberWithInteger:self.userId] forKey:@"userId"];
    [dataDict setObject:self.userHeadFileName forKey:@"userHeadFileName"];
    [dataDict setObject:self.userNickName forKey:@"userNickName"];
    [dataDict setObject:self.userCountry forKey:@"userCountry"];
    [dataDict setObject:self.userRtcToken forKey:@"userRtcToken"];
    [dataDict setObject:self.userNationalFlagUrl forKey:@"userNationalFlagUrl"];
    [dataDict setObject:[NSNumber numberWithInteger:self.followFlag] forKey:@"followFlag"];
    [dataDict setObject:[NSNumber numberWithInteger:self.coinVideoPrice] forKey:@"coinVideoPrice"];
    [dataDict setObject:[NSNumber numberWithInteger:self.devicesNum] forKey:@"devicesNum"];

    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

    ///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.type = dictionary[@"type"];
            self.channelId = dictionary[@"channelId"];
            self.noticeTime = dictionary[@"noticeTime"];
            self.anchorId = [dictionary[@"anchorId"] integerValue];
            self.anchorCode = dictionary[@"anchorCode"];
            self.anchorNickName = dictionary[@"anchorNickName"];
            self.anchorCountry = dictionary[@"anchorCountry"];
            self.anchorRtcToken = dictionary[@"anchorRtcToken"];
            self.anchorHeadFileName = dictionary[@"anchorHeadFileName"];
            self.anchorNationalFlagUrl = dictionary[@"anchorNationalFlagUrl"];
            self.userId = [dictionary[@"userId"] integerValue];
            self.userCountry = dictionary[@"userCountry"];
            self.userNickName = dictionary[@"userNickName"];
            self.userRtcToken = dictionary[@"userRtcToken"];
            self.userHeadFileName = dictionary[@"userHeadFileName"];
            self.userNationalFlagUrl = dictionary[@"userNationalFlagUrl"];
            self.followFlag = [dictionary[@"followFlag"] integerValue];
            self.coinVideoPrice = [dictionary[@"coinVideoPrice"] integerValue];
            self.devicesNum = [dictionary[@"devicesNum"] integerValue];

            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


    ///消息的类型名
+ (NSString *)getObjectName {
    return RCHeartBeatMessageIdentifier;
}


@end

@implementation JLJoinHeartBeatMessage

    ///初始化
+ (instancetype)messageWithType:(NSString *)type
                      channelId:(NSString *)channelId
                 anchorRtcToken:(NSString *)anchorRtcToken {
    JLJoinHeartBeatMessage *message = [[JLJoinHeartBeatMessage alloc] init];
    if (message) {
        message.type = type;
        message.channelId = channelId;
        message.anchorRtcToken = anchorRtcToken;
    }
    return message;
}

    ///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_STATUS;
}

    /// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.channelId = [aDecoder decodeObjectForKey:@"channelId"];
        self.anchorRtcToken = [aDecoder decodeObjectForKey:@"anchorRtcToken"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

    /// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.channelId forKey:@"channelId"];
    [aCoder encodeObject:self.anchorRtcToken forKey:@"anchorRtcToken"];

    [aCoder encodeObject:self.extra forKey:@"extra"];
}

    ///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.channelId forKey:@"channelId"];
    [dataDict setObject:self.anchorRtcToken forKey:@"anchorRtcToken"];

    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

    ///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.type = dictionary[@"type"];
            self.channelId = dictionary[@"channelId"];
            self.anchorRtcToken = dictionary[@"anchorRtcToken"];
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


    ///消息的类型名
+ (NSString *)getObjectName {
    return RCJoinHeartBeatMessageIdentifier;
}
@end


@implementation JLMediaPrivateMessage

///初始化
+ (instancetype)messageWithType:(NSString *)type
                     inviteTime:(NSString *)inviteTime
                 expirationTime:(NSInteger )expirationTime
                       unlockId:(NSInteger )unlockId
                       giftCode:(NSString *)giftCode
                        giftUrl:(NSString *)giftUrl
                       giftName:(NSString *)giftName
                      giftPrice:(NSInteger )giftPrice
                         giftId:(NSInteger )giftId
                    giftSvgaUrl:(NSString *)giftSvgaUrl
                     privacyUrl:(NSString *)privacyUrl
             firstFrameImageUrl:(NSString *)firstFrameImageUrl
                       duration:(NSInteger)duration {
    JLMediaPrivateMessage *message = [[JLMediaPrivateMessage alloc] init];
    if (message) {
        message.type = type;
        message.inviteTime = inviteTime;
        message.expirationTime = expirationTime;
        message.unlockId = unlockId;
        message.giftCode = giftCode;
        message.giftUrl = giftUrl;
        message.giftName = giftName;
        message.giftPrice = giftPrice;
        message.giftId = giftId;
        message.giftSvgaUrl = giftSvgaUrl;
        message.privacyUrl = privacyUrl;
        message.firstFrameImageUrl = firstFrameImageUrl;
        message.duration = duration;
    }
    return message;
}

    ///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISCOUNTED;
}

    /// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.inviteTime = [aDecoder decodeObjectForKey:@"inviteTime"];
        self.expirationTime = [[aDecoder decodeObjectForKey:@"expirationTime"] integerValue];
        self.unlockId = [[aDecoder decodeObjectForKey:@"unlockId"] integerValue];
        self.giftCode = [aDecoder decodeObjectForKey:@"giftCode"];
        self.giftUrl = [aDecoder decodeObjectForKey:@"giftUrl"];
        self.giftName = [aDecoder decodeObjectForKey:@"giftName"];
        self.giftPrice = [[aDecoder decodeObjectForKey:@"giftPrice"] integerValue];
        self.giftId = [[aDecoder decodeObjectForKey:@"giftId"] integerValue];
        self.giftSvgaUrl = [aDecoder decodeObjectForKey:@"giftSvgaUrl"];
        self.privacyUrl = [aDecoder decodeObjectForKey:@"privacyUrl"];
        self.firstFrameImageUrl = [aDecoder decodeObjectForKey:@"firstFrameImageUrl"];
        self.duration = [[aDecoder decodeObjectForKey:@"duration"] integerValue];

        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

    /// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.inviteTime forKey:@"inviteTime"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.expirationTime] forKey:@"expirationTime"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.unlockId] forKey:@"unlockId"];
    [aCoder encodeObject:self.giftCode forKey:@"giftCode"];
    [aCoder encodeObject:self.giftUrl forKey:@"giftUrl"];
    [aCoder encodeObject:self.giftName forKey:@"giftName"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.giftPrice] forKey:@"giftPrice"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.giftId] forKey:@"giftId"];
    [aCoder encodeObject:self.giftSvgaUrl forKey:@"giftSvgaUrl"];
    [aCoder encodeObject:self.privacyUrl forKey:@"privacyUrl"];
    [aCoder encodeObject:self.firstFrameImageUrl forKey:@"firstFrameImageUrl"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.duration] forKey:@"duration"];

    [aCoder encodeObject:self.extra forKey:@"extra"];
}

    ///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.inviteTime forKey:@"inviteTime"];
    [dataDict setObject:[NSNumber numberWithInteger:self.expirationTime] forKey:@"expirationTime"];
    [dataDict setObject:[NSNumber numberWithInteger:self.unlockId] forKey:@"unlockId"];
    [dataDict setObject:self.giftCode forKey:@"giftCode"];
    [dataDict setObject:self.giftUrl forKey:@"giftUrl"];
    [dataDict setObject:self.giftName forKey:@"giftName"];
    [dataDict setObject:[NSNumber numberWithInteger:self.giftPrice] forKey:@"giftPrice"];
    [dataDict setObject:[NSNumber numberWithInteger:self.giftId] forKey:@"giftId"];
    [dataDict setObject:self.giftSvgaUrl forKey:@"giftSvgaUrl"];
    [dataDict setObject:self.privacyUrl forKey:@"privacyUrl"];
    [dataDict setObject:self.firstFrameImageUrl forKey:@"firstFrameImageUrl"];
    [dataDict setObject:[NSNumber numberWithInteger:self.duration] forKey:@"duration"];

    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

    ///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.type = dictionary[@"type"];
            self.inviteTime = dictionary[@"inviteTime"];
            self.expirationTime = [dictionary[@"expirationTime"] integerValue];
            self.unlockId = [dictionary[@"unlockId"] integerValue];
            self.giftCode = dictionary[@"giftCode"];
            self.giftUrl = dictionary[@"giftUrl"];
            self.giftName = dictionary[@"giftName"];
            self.giftPrice = [dictionary[@"giftPrice"] integerValue];
            self.giftId = [dictionary[@"giftId"] integerValue];
            self.giftSvgaUrl = dictionary[@"giftSvgaUrl"];
            self.privacyUrl = dictionary[@"privacyUrl"];
            self.firstFrameImageUrl = dictionary[@"firstFrameImageUrl"];
            self.duration = [dictionary[@"duration"] integerValue];

            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


    ///消息的类型名
+ (NSString *)getObjectName {
    return RCPrivateMediaMessageIdentifier;
}

@end


@implementation JLAnchorCallMessage

///初始化
+ (instancetype)messageWithType:(NSString *)type
                   headFileName:(NSString *)headFileName
                         userId:(NSInteger )userId
                       nickName:(NSString *)nickName
                      channelId:(NSString *)channelId
                       rtcToken:(NSString *)rtcToken{
    JLAnchorCallMessage *message = [[JLAnchorCallMessage alloc] init];
    if (message) {
        message.type = type;
        message.headFileName = headFileName;
        message.userId = userId;
        message.nickName = nickName;
        message.channelId = channelId;
        message.rtcToken = rtcToken;
    }
    return message;
}

    ///消息是否存储，是否计入未读数
+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISCOUNTED;
}

    /// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.headFileName = [aDecoder decodeObjectForKey:@"headFileName"];
        self.userId = [[aDecoder decodeObjectForKey:@"userId"] integerValue];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.channelId = [aDecoder decodeObjectForKey:@"channelId"];
        self.rtcToken = [aDecoder decodeObjectForKey:@"rtcToken"];
        
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

    /// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.headFileName forKey:@"headFileName"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.userId] forKey:@"userId"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.channelId forKey:@"channelId"];
    [aCoder encodeObject:self.rtcToken forKey:@"rtcToken"];
    
    [aCoder encodeObject:self.extra forKey:@"extra"];
}

    ///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.type forKey:@"type"];
    [dataDict setObject:self.headFileName forKey:@"headFileName"];
    [dataDict setObject:[NSNumber numberWithInteger:self.userId] forKey:@"userId"];
    [dataDict setObject:self.nickName forKey:@"nickName"];
    [dataDict setObject:self.channelId forKey:@"channelId"];
    [dataDict setObject:self.rtcToken forKey:@"rtcToken"];
    
    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

    ///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (dictionary) {
            self.type = dictionary[@"type"];
            self.headFileName = dictionary[@"headFileName"];
            self.userId = [dictionary[@"userId"] integerValue];
            self.nickName = dictionary[@"nickName"];
            self.channelId = dictionary[@"channelId"];
            self.rtcToken = dictionary[@"rtcToken"];
            
            self.extra = dictionary[@"extra"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}


    ///消息的类型名
+ (NSString *)getObjectName {
    return RCAnchorCallMessageIdentifier;
}

@end

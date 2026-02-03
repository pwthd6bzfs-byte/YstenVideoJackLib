    //
    //  RCConversationCell.m
    //  RongIMKit
    //
    //  Created by xugang on 15/1/24.
    //  Copyright (c) 2015年 RongCloud. All rights reserved.
    //

    //
    //  RCDChatListCell.m
    //  RCloudMessage
    //
    //  Created by Liv on 15/4/15.
    //  Copyright (c) 2015年 RongCloud. All rights reserved.
    //

#import "JLRCConversationCell.h"
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>
#import <RongCloudOpenSource/RongIMKit.h>
#import "JLCustomMessage.h"
//#import "RCDUserInfoManager.h"
//#import "RCDContactNotificationMessage.h"
//#import "RCDUtilities.h"
//#import "RCDSemanticContext.h"

@interface JLRCConversationCell ()
@property (nonatomic, strong) UIImageView *ivAva;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblDetail;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) UILabel *labelCount;

@end

@implementation JLRCConversationCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    JLRCConversationCell *cell = (JLRCConversationCell *)[tableView dequeueReusableCellWithIdentifier:RCDChatListCellIdentifier];
    if (!cell) {
        cell = [[JLRCConversationCell alloc] init];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setupSubviews];
    }
    return self;
}

- (void)setDataModel:(RCConversationModel *)model {
    self.model = model;
    __block NSString *userName = nil;
    __block NSString *portraitUri = nil;
        //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
    
    if ((int)model.unreadMessageCount > 0) {
        self.labelCount.text = [NSString stringWithFormat:@"%d",(int)model.unreadMessageCount];
        self.labelCount.hidden = NO;
    }else{
        self.labelCount.text = @"";
        self.labelCount.hidden = YES;
    }
    
    RCUserInfo *userInfo = [[RCIM sharedRCIM] getUserInfoCache:model.targetId];
    if (userInfo) {
        portraitUri = userInfo.portraitUri;
    }

    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleURL = [bundle URLForResource:@"YstenVideoJackLib" withExtension:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];
    [self.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"jl_un_auth_cer" inBundle:resourceBundle compatibleWithTraitCollection:nil]];
    
    self.lblName.text = userInfo.name;
    
    
    NSString *contentString = @"";
    if ([model.lastestMessage isMemberOfClass:[JLAskGiftMessage class]] || [model.lastestMessage isMemberOfClass:[JLGiftMessage class]]) {
        contentString = @"[Gift]";
    }else if ([model.lastestMessage isMemberOfClass:[JLVideoMessage class]]){
        contentString = @"[Video Calls]";
    }else if ([model.lastestMessage isMemberOfClass:[JLMediaPrivateMessage class]]){
        JLMediaPrivateMessage * mediaPrivateMessage = (JLMediaPrivateMessage *)model.lastestMessage;
//        NSString *statusName = @"";
        if ([mediaPrivateMessage.type isEqualToString:@"1"]) {
            contentString = @"[Intimate Photo]";
        }else{
            contentString = @"[Intimate Video]";
        }
    }else if ([model.lastestMessage isMemberOfClass:[RCImageMessage class]]){
        contentString = @"[Photo]";
    }else if ([model.lastestMessage isMemberOfClass:[RCVoiceMessage class]] || [model.lastestMessage isMemberOfClass:[RCHQVoiceMessage class]]){
        contentString = @"[Voice]";
    }else if([model.lastestMessage isMemberOfClass:[RCTextMessage class]]){
        RCTextMessage * message = (RCTextMessage *)model.lastestMessage;
        contentString = message.content;
    }
    
    self.lblDetail.text = contentString;
    self.labelTime.text = [RCKitUtility convertConversationTime:model.sentTime / 1000];
}



- (void)setupSubviews {
    _ivAva = [UIImageView new];
    _ivAva.layer.cornerRadius = 46/2.0f;
    _ivAva.layer.masksToBounds  = YES;
    _ivAva.clipsToBounds = YES;
    _ivAva.contentMode = UIViewContentModeScaleAspectFill;
    [_ivAva setBackgroundColor:[UIColor colorWithHexString:@"#D9D9D9"]];
    
    
    _lblDetail = [UILabel new];
    [_lblDetail setFont:[UIFont systemFontOfSize:13]];
    [_lblDetail setTextColor:[UIColor colorWithHexString:@"#666666"]];
    _lblDetail.accessibilityLabel = @"_lblDetail";
    
    
    _lblName = [UILabel new];
    [_lblName setFont:[UIFont boldSystemFontOfSize:15.f]];
    [_lblName setTextColor:[UIColor blackColor]];
    _lblName.text = @"";
//    _lblName.accessibilityLabel = @"_lblName";
    
    _labelTime = [[UILabel alloc] init];
    _labelTime.backgroundColor = [UIColor clearColor];
    _labelTime.font = [UIFont systemFontOfSize:10];
    _labelTime.textColor = [UIColor blackColor];
//    _labelTime.accessibilityLabel = @"_labelTime";
    
    
    
    _labelCount = [[UILabel alloc] init];
    _labelCount.backgroundColor = [UIColor redColor];
    _labelCount.font = [UIFont systemFontOfSize:10];
    _labelCount.textColor = [UIColor whiteColor];
    _labelCount.layer.cornerRadius = 16/2.0;
    _labelCount.layer.masksToBounds = YES;
    _labelCount.textAlignment = NSTextAlignmentCenter;
        //    _labelTime.accessibilityLabel = @"_labelTime";

    
    
    [self.contentView addSubview:_ivAva];
    [self.contentView addSubview:_lblDetail];
    [self.contentView addSubview:_lblName];
    [self.contentView addSubview:_labelTime];
    [self.contentView addSubview:_labelCount];
    
    
    
    [self.ivAva mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(16);
        make.size.mas_offset(CGSizeMake(46, 46));
    }];
    
    [self.lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ivAva.mas_top).offset(1.2);
        make.left.equalTo(self.ivAva.mas_right).offset(12);
    }];

    
    [self.lblDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ivAva.mas_bottom).offset(-1.2);
        make.left.equalTo(self.ivAva.mas_right).offset(12);
    }];

    
    [self.labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lblName);
        make.right.equalTo(self.contentView).offset(-16);
    }];

    [self.labelCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lblDetail);
        make.right.equalTo(self.contentView).offset(-16);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
    
}
@end

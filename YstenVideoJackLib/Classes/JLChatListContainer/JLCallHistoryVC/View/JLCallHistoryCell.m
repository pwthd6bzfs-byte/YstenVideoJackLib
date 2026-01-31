//
//  JLCallHistoryCell.m
//  LJChatSDK
//
//  Created by percent on 2026/1/26.
//

#import "JLCallHistoryCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Add.h"
@interface JLCallHistoryCell ()

@property (nonatomic, strong) UIView *vContainer;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *explainLab;


@end

@implementation JLCallHistoryCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initialize];
    }
    return self;
}






- (void)initialize{
    [self.contentView addSubview:self.vContainer];
    [self.vContainer addSubview:self.headImageView];
    [self.vContainer addSubview:self.titleLab];
    [self.vContainer addSubview:self.timeLab];
    [self.vContainer addSubview:self.iconImageView];
    [self.vContainer addSubview:self.explainLab];
    
    
    [self.vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@64);
    }];
    
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.vContainer);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];

    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vContainer.mas_top).offset(3);
        make.right.equalTo(self.vContainer);
        make.left.equalTo(self.headImageView.mas_right).offset(8);
    }];
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageView.mas_bottom).offset(-3);
        make.left.equalTo(self.headImageView.mas_right).offset(8);
        make.size.mas_offset(CGSizeMake(16, 16));
    }];
    
    
    [self.explainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(4);
    }];
    
    
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vContainer);
        make.right.equalTo(self.vContainer).offset(-16);
    }];
    
}


//subStatus = 201,202,203,402,406,405
//
//WAIT_CONNECT(100, "待接通", UN_CONNECT),
//ON_CONNECT(101, "通话中", VIDEOING),
//ANCHOR_HANG_UP(201, "主播结束", VIDEO_FINISH),// 通话过程中，主播主动挂断
//USER_HANG_UP(202, "用户结束", VIDEO_FINISH),// 通话过程中，用户主动挂断
//INSUFFICIENT(203, "系统结束-余额不足", VIDEO_FINISH), // 通话过程中，用户余额不足扣下一分钟
//ABNORMAL_CANCEL(301, "系统取消-通话异常", VIDEO_ERROR), // 未接通情况下未知异常取消
//ABNORMAL_CLOSE(302, "系统结束-通话异常", VIDEO_ERROR), // 接通情况下未知异常结束
//ROOM_NOT_EXIST(303, "房间不存在", VIDEO_ERROR),
//ANCHOR_NOT_EXIST(304, "达人不存在", VIDEO_ERROR),
//USER_NOT_JOIN(305, "用户未加入房间", VIDEO_ERROR),
//INSUFFICIENT_CANCEL(401, "系统取消-余额不足", CANCEL),// 发起通话时余额不足取消
//TIMEOUT_CANCEL(402, "超时未接听", CANCEL), // 接听方超时未接听，系统取消
//USER_CANCEL(403, "用户取消", CANCEL),// 用户取消主动发起的未接听的通话
//USER_REJECT(404, "用户拒绝", CANCEL), // 用户拒绝主播发起的通话邀请
//ANCHOR_CANCEL(405, "主播取消", CANCEL), // 主播取消主动发起的未接听通话
//ANCHOR_REJECT(406, "主播拒绝", CANCEL), // 主播拒绝用户发起的通话邀请
//PLATFORM_CANCEL(407, "平台取消-超时未拨", CANCEL), // 用户未进行推送拨打消息，系统取消（/video/push）

- (void)setModel:(JLCallHistoryModel *)model{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headFileName]];
    
    self.titleLab.text = model.nickName;
    self.timeLab.text = model.createTime;
    
    
    if (model.subStatus == 201 || model.subStatus == 202 || model.subStatus == 203) {
        self.iconImageView.image = [UIImage jl_name:@"jl_history_complete" class:self];
        self.explainLab.text = [NSString stringWithFormat:@"Call duration %@",model.duration];
        self.explainLab.textColor = [UIColor colorWithHexString:@"#066B1F"];
    }else if (model.subStatus == 403 || model.subStatus == 405){
        self.iconImageView.image = [UIImage jl_name:@"jl_history_cancel" class:self];
        self.explainLab.textColor = [UIColor blackColor];
        self.explainLab.text = @"Canceled";
    }else if (model.subStatus == 407){
        self.iconImageView.image =  [UIImage jl_name:@"jl_history_cancel" class:self];
        self.explainLab.text = @"Platform canceled";
        self.explainLab.textColor = [UIColor blackColor];
    }else if(model.subStatus == 402){
        self.iconImageView.image = [UIImage jl_name:@"jl_history_miss" class:self];
        self.explainLab.text = @"the other party did not answer";
        self.explainLab.textColor = [UIColor colorWithHexString:@"#F22828"];
    }else if(model.subStatus == 406) {
        self.iconImageView.image = [UIImage jl_name:@"jl_history_cancel" class:self];
        self.explainLab.text = @"Reject";
        self.explainLab.textColor = [UIColor blackColor];
    }else{
        self.iconImageView.image = [UIImage jl_name:@"jl_history_miss" class:self];
        self.explainLab.text = @"missed";
        self.explainLab.textColor = [UIColor colorWithHexString:@"#F22828"];
    }
}



- (UIView *)vContainer{
    if (!_vContainer) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        _vContainer = view;
    }
    return  _vContainer;
}



- (UILabel *)titleLab{
    if (!_titleLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor colorWithHexString:@"#000000"];
        view.text = @"";
        view.font = [UIFont boldSystemFontOfSize:14];
        _titleLab = view;
    }
    return  _titleLab;
}


- (UIImageView *)headImageView{
    if (!_headImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.layer.cornerRadius = 44/2;
        view.layer.masksToBounds = YES;
        view.backgroundColor = [UIColor colorWithHexString:@"#D9D9D9"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView = view;
    }
    return  _headImageView;
}



- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView = view;
    }
    return  _iconImageView;
}




- (UILabel *)explainLab{
    if (!_explainLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.8];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:12];
        _explainLab = view;
    }
    return  _explainLab;
}




- (UILabel *)timeLab{
    if (!_timeLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        view.text = @"";
        view.font = [UIFont systemFontOfSize:10];
        _timeLab = view;
    }
    return  _timeLab;
}


@end

    //
    //  JLCallHistoryCell.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/26.
    //

#import "JLFollowCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Add.h"

@interface JLFollowCell ()

@property (nonatomic, strong) UIView *vContainer;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *followBtn;


@end

@implementation JLFollowCell



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
    [self.vContainer addSubview:self.followBtn];

    
    [self.vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
        make.bottom.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@66);
    }];
    
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.centerY.equalTo(self.vContainer);
        make.size.mas_offset(CGSizeMake(44, 44));
    }];
    
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vContainer);
        make.left.equalTo(self.headImageView.mas_right).offset(8);
    }];
    
    
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vContainer);
        make.right.equalTo(self.vContainer).offset(-16);
    }];

}



- (void)setModel:(JLFollowModel *)model{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.followHeadFileName]];
    
    self.titleLab.text = model.followNickName;
//    if ([model.followFlag isEqualToString:@"1"]) {
        self.followBtn.selected = YES;
        self.followBtn.backgroundColor = [UIColor colorWithHexString:@"#ECECEC"];
        self.followBtn.hidden = false;
//    }else{
//        self.followBtn.backgroundColor = [UIColor colorWithHexString:@"#D6007E"];
//        self.followBtn.selected = NO;
//        self.followBtn.hidden = YES;
//    }
}


- (void)clickFollowBtnEvnet{
    if (self.clickFollowBtnBlock) {
        self.clickFollowBtnBlock();
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






- (UIButton *)followBtn{
    if (!_followBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setTitle:@"Follow" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        view.titleLabel.font = [UIFont systemFontOfSize:13];
        view.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [view setTitle:@"Follow" forState:UIControlStateNormal];
        [view setTitle:@"UnFollow" forState:UIControlStateSelected];
        [view setImage:[UIImage jl_name:@"jl_follow_add" class:self] forState:UIControlStateNormal];
        [view setImage:[UIImage jl_name:@"jl_follow_no" class:self] forState:UIControlStateSelected];
        [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        view.layer.cornerRadius = 8;
        view.layer.masksToBounds = YES;
        [view addTarget:self action:@selector(clickFollowBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        _followBtn = view;
    }
    return  _followBtn;
}


@end

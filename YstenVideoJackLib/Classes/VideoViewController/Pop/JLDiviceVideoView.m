    //
    //  JLGiftListView.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/12.
    //

#import "JLDiviceVideoView.h"
#import "Config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JLUserService.h"
#import "UIImage+Add.h"

@interface JLDiviceVideoView()<UITableViewDelegate,UITableViewDataSource>
/// 视图容器
@property (nonatomic, strong) UIView *vContainer;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *deviceList;

    /// 点击开始视频回调方法
@property (nonatomic, copy) void(^cliclStarVideoBtnBlock)(void);


@end

@implementation JLDiviceVideoView


- (instancetype)initDeviceList:(NSArray *)deviceList WitCliclStarVideoBtnBlock:(void(^)(void))starVideoBtnBlock{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
        self.deviceList = deviceList;
        self.cliclStarVideoBtnBlock = starVideoBtnBlock;
        [self setup];
    }
    return self;
}


- (void)setup{
    
//    [self addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *vContainer = [[UIView alloc] init];
    vContainer.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.9];
    vContainer.layer.cornerRadius = 16;
    self.vContainer = vContainer;
    [self addSubview:vContainer];
    Weakself(ws)
    
    UILabel *labTitle = [[UILabel alloc] init];
    labTitle.text = @"Unlock toy fun together";
    labTitle.textColor = [UIColor colorWithHexString:@"#000000"];
    labTitle.font = [UIFont systemFontOfSize:16];
    [vContainer addSubview:labTitle];

    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[UIImage jl_name:@"jl_close_gray" class:self] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(clickCloseEvent) forControlEvents:UIControlEventTouchUpInside];
    [vContainer addSubview:closeBtn];

    
    [vContainer addSubview:self.tableView];
    
    
//    UIView *viewContainer = [[UIView alloc] init];
//    viewContainer.backgroundColor = [UIColor whiteColor];
//    viewContainer.layer.cornerRadius = 16;
//    viewContainer.layer.masksToBounds = YES;
//    [vContainer addSubview:viewContainer];
//
//    
//    UIImageView *imgIcon = [[UIImageView alloc] init];
////    imgIcon.image = [UIImage jl_name:@"" class:self];
//    imgIcon.backgroundColor = [UIColor redColor];
//    imgIcon.contentMode = UIViewContentModeScaleAspectFill;
//    [vContainer addSubview:imgIcon];
//
//    
//    UILabel *labVibratorTitle = [[UILabel alloc] init];
//    labVibratorTitle.text = @"Vibrator";
//    labVibratorTitle.textColor = [UIColor blackColor];
//    labVibratorTitle.font = [UIFont systemFontOfSize:14];
//    [vContainer addSubview:labVibratorTitle];
    
    
    UILabel *labMark = [[UILabel alloc] init];
    labMark.text = @"I have prepared the toy and want to\n experience it with you. Start a video now~";
    labMark.textColor = [UIColor colorWithHexString:@"#888888"];
    labMark.font = [UIFont systemFontOfSize:12];
    labMark.numberOfLines = 2;
    [vContainer addSubview:labMark];
    
    
    
    UIButton *starVideoBtn = [[UIButton alloc] init];
    [starVideoBtn setTitle:@"Star Video" forState:UIControlStateNormal];
    [starVideoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    starVideoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    starVideoBtn.layer.cornerRadius = 24;
    [starVideoBtn setBackgroundImage:[UIImage jl_name:@"jl_button_bg" class:self] forState:UIControlStateNormal];
    [starVideoBtn addTarget:self action:@selector(cliclStarVideoBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
    [vContainer addSubview:starVideoBtn];

    
    [vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle.mas_top).offset(-16);
        make.bottom.equalTo(starVideoBtn.mas_bottom).offset(18);
        make.width.equalTo(@(285));
        make.center.equalTo(ws);
    }];

    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.vContainer).offset(16);
        make.centerX.equalTo(ws.vContainer);
    }];
    
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labTitle);
        make.right.equalTo(vContainer).offset(-10);
        make.size.mas_offset(CGSizeMake(24, 24));
    }];

    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle.mas_bottom).offset(14);
        make.left.equalTo(ws.vContainer).offset(17);
        make.right.equalTo(ws.vContainer).offset(-17);
        make.height.equalTo(@(48*self.deviceList.count));
    }];

        
    
    [labMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vContainer);
        make.top.equalTo(self.tableView.mas_bottom).offset(19);
    }];
    
    
    [starVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labMark.mas_bottom).offset(17);
        make.centerX.equalTo(vContainer);
        make.size.mas_offset(CGSizeMake(241, 48));
    }];

}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.deviceList.count;
}







- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JLDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLDeviceCell"];
    JLDeviceModel *model = self.deviceList[indexPath.row];
    cell.model = model;
    return  cell;
}






- (void)cliclStarVideoBtnEvnet{
    [self hide];
    if (self.cliclStarVideoBtnBlock) {
        self.cliclStarVideoBtnBlock();
    }
}



- (void)clickCloseEvent{
    [self hide];
}



- (void)show{
    Weakself(ws)
//    [self layoutIfNeeded];
//    [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(234));
//        make.width.equalTo(@(285));
//        make.center.equalTo(ws);
//    }];
    
//    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
//        [self layoutIfNeeded];
//    }];
}



- (void)hide{
    Weakself(ws)
//    [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(@(0));
//        make.top.equalTo(ws.mas_bottom);
//        make.height.equalTo(@(175));
//    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}




-(UITableView *) tableView
{
    if (!_tableView)
        {
        
        UITableView * view = [[UITableView alloc]initWithFrame:
                              CGRectMake(0,
                                         0,
                                         0,
                                         0 ) style:UITableViewStylePlain];
        view.delegate = self;
        view.dataSource = self;
        view.contentInset = UIEdgeInsetsMake(0 , 0, 0, 0);
        view.separatorColor = [UIColor clearColor];
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.estimatedRowHeight = 60;
        view.rowHeight = UITableViewAutomaticDimension;
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.backgroundColor = [UIColor clearColor];
        view.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        view.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        view.sectionHeaderHeight = 0;
        view.sectionFooterHeight = 0;
        view.layer.cornerRadius = 24.0;
        view.scrollEnabled = NO;
        view.rowHeight = 48;
        [view registerClass:[JLDeviceCell class] forCellReuseIdentifier:@"JLDeviceCell"];
        
        if (@available(iOS 11.0, *)) {
            view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView = view;
        }
    return _tableView;
}



@end






@interface JLDeviceCell ()

//@property (nonatomic, strong) UIView *vContainer;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation JLDeviceCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initialize];
    }
    return self;
}






- (void)initialize{
//    [self.contentView addSubview:self.vContainer];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.titleLab];
    
//    [self.vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(20);
//        make.bottom.equalTo(self.contentView);
//        make.left.right.equalTo(self.contentView);
//        make.height.equalTo(@64);
//    }];
    
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_offset(CGSizeMake(28, 28));
    }];
    
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.headImageView.mas_right).offset(10);
    }];
    
}


- (void)setModel:(JLDeviceModel *)model{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    
    self.titleLab.text = model.title;
}



//- (UIView *)vContainer{
//    if (!_vContainer) {
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor clearColor];
//        _vContainer = view;
//    }
//    return  _vContainer;
//}



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
        view.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView = view;
    }
    return  _headImageView;
}




@end

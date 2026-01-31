//
//  JLGiftListView.m
//  LJChatSDK
//
//  Created by percent on 2026/1/12.
//

#import "JLGiftListView.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "JLUserService.h"
#import "UIImage+Add.h"

@interface JLGiftListView()<UICollectionViewDelegate,UICollectionViewDataSource>
    /// 视图容器
@property (nonatomic, strong) UIView *vContainer;
@property (nonatomic, strong) UITableView *tableView;
    /// 当前索引路径
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

/// 数量
@property (nonatomic, strong) UILabel *labCount;

/// 模型
@property (nonatomic, strong) JLGiftListModel *model;

/// 当前选择礼物模型
@property (nonatomic, strong) JLGiftModel *selectModel;


/// 选择礼物回调方法
@property (nonatomic, copy) void(^clickSelectModelBlock)(JLGiftModel *model,NSString *count);

@end

@implementation JLGiftListView


- (instancetype)initWithModel:(JLGiftListModel *)model returnModel:(void(^)(JLGiftModel *model,NSString *count))block{
    self = [super init];
    if (self) {
        self.model = model;
        self.clickSelectModelBlock = block;
        [self setupModel:model];
    }
    return self;
}


- (void)setupModel:(JLGiftListModel *)model{
    
    if (model.giftsList.count > 0) {
        
        for (JLGiftModel *model in self.model.giftsList) {
            model.indexPath = nil;
        }

        JLGiftModel *giftModel =  model.giftsList[0];
        self.selectModel = giftModel;
        // 默认选择第一个
        giftModel.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    [self addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *vContainer = [[UIView alloc] init];
    vContainer.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    vContainer.layer.cornerRadius = 10;
    self.vContainer = vContainer;
    [self addSubview:vContainer];
    Weakself(ws)
    [vContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(390));
        make.left.right.equalTo(@(0));
        make.top.equalTo(ws.mas_bottom);
    }];
    
    
    UILabel *labTitle = [[UILabel alloc] init];
    labTitle.text = @"Gift";
    labTitle.textColor = [UIColor blackColor];
    labTitle.font = [UIFont systemFontOfSize:14];
    [vContainer addSubview:labTitle];
    
    [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.vContainer).offset(18);
        make.left.equalTo(@(16));
    }];

    
    
    UIButton *rechargeBtn = [[UIButton alloc] init];
    rechargeBtn.backgroundColor = [UIColor whiteColor];
    rechargeBtn.layer.cornerRadius = 8;
    rechargeBtn.layer.masksToBounds = YES;
    [vContainer addSubview:rechargeBtn];

    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage jl_name:@"jl_coin" class:self];
    [rechargeBtn addSubview:iconView];
    
    UILabel *labMoney = [[UILabel alloc] init];
    JLUserModel *user = [JLUserService shared].userInfo;
    if (user) {
        labMoney.text = [NSString stringWithFormat:@"%ld",(long)user.coins];
    }else{
        labMoney.text = @"0";
    }
    labMoney.textColor = [UIColor blackColor];
    labMoney.font = [UIFont systemFontOfSize:12];
    [rechargeBtn addSubview:labMoney];
    
    UIImageView *iconArrowView = [[UIImageView alloc] init];
    iconArrowView.image = [UIImage jl_name:@"jl_arrow" class:self];
    [rechargeBtn addSubview:iconArrowView];
    
    UIView *vline = [[UIView alloc] init];
    vline.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.1];
    [self addSubview:vline];

    
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(labTitle);
        make.height.equalTo(@(32));
        make.left.equalTo(iconView.mas_left).offset(-8);
        make.right.equalTo(self).offset(-16);
    }];

    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rechargeBtn);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.right.equalTo(labMoney.mas_left).offset(-2);
    }];

    
    [labMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(rechargeBtn);
    }];
    
    
    [iconArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(rechargeBtn);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.left.equalTo(labMoney.mas_right).offset(2);
    }];
    
    
    [vline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labTitle.mas_bottom).offset(18);
        make.left.right.equalTo(self);
        make.height.equalTo(@(0.5));
    }];

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 8; // cell左右间距
        layout.minimumInteritemSpacing = 8;
    layout.itemSize = CGSizeMake(80, 108);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *_collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.frame.size.height) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#EFEFEF"];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.contentInset = UIEdgeInsetsMake(12, 16, 0, 16);
    [_collectionView registerClass:[JLGiftCell class] forCellWithReuseIdentifier:@"JLGiftCell"];
//    self.listTableView = tableView;
    [vContainer addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vline.mas_bottom);;
        make.left.right.equalTo(@(0));
        make.height.equalTo(@(248));
    }];
    
    
    UIView *countView = [[UIView alloc] init];
    countView.backgroundColor = [UIColor whiteColor];
    countView.layer.cornerRadius = 16;
    countView.layer.masksToBounds = YES;
    [self addSubview:countView];
    
    
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn setImage:[UIImage jl_name:@"jl_add" class:self] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(clickAddBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [countView addSubview:addBtn];

    
    UILabel *labCount = [[UILabel alloc] init];
    labCount.text = @"1";
    labCount.textColor = [UIColor blackColor];
    labCount.font = [UIFont systemFontOfSize:16];
    labCount.textAlignment = UITextAlignmentCenter;
    self.labCount = labCount;
    [countView addSubview:labCount];
    
    
    UIButton *reduceBtn = [[UIButton alloc] init];
    [reduceBtn setImage:[UIImage jl_name:@"jl_reduce" class:self] forState:UIControlStateNormal];
    [reduceBtn addTarget:self action:@selector(clickReduceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [countView addSubview:reduceBtn];
    
    
    UIButton *giveAwayBtn = [[UIButton alloc] init];
    giveAwayBtn.backgroundColor = [UIColor colorWithHexString:@"#FE006B"];
    [giveAwayBtn setTitle:@"Give Away" forState:UIControlStateNormal];
    [giveAwayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    giveAwayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    giveAwayBtn.layer.cornerRadius = 16;
    giveAwayBtn.layer.masksToBounds = YES;
    [giveAwayBtn addTarget:self action:@selector(clickRiveAwayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:giveAwayBtn];

    
    [giveAwayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(90));
        make.height.equalTo(@(32));
        make.right.equalTo(self).offset(-16);
        make.bottom.equalTo(self).offset(-34);
    }];

    
    [countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(giveAwayBtn.mas_left).offset(18);
        make.width.equalTo(@(140));
        make.height.equalTo(@(32));
        make.centerY.equalTo(giveAwayBtn);
    }];
    
    [reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(8));
        make.width.equalTo(@(28));
        make.height.equalTo(@(28));
        make.centerY.equalTo(countView);
    }];
    
    [labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reduceBtn.mas_right).offset(2);
        make.width.equalTo(@(50));
        make.centerY.equalTo(countView);
    }];

    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labCount.mas_right).offset(2);
        make.width.equalTo(@(28));
        make.height.equalTo(@(28));
        make.centerY.equalTo(countView);
    }];


}



- (void)clickAddBtnClick{
    NSInteger count = [self.labCount.text integerValue];
    count += 1;
    self.labCount.text = [NSString stringWithFormat:@"%ld",count];
}



- (void)clickReduceBtnClick{
    NSInteger count = [self.labCount.text integerValue];
    if (count <= 1) {
        return;
    }
    
    count -= 1;
    self.labCount.text = [NSString stringWithFormat:@"%ld",count];
}



- (void)clickRiveAwayBtnClick{
    if(self.clickSelectModelBlock){
        [self hide];
        
        CGFloat priceCount = self.selectModel.coin *[self.labCount.text integerValue];
        
        JLUserModel *user = [JLUserService shared].userInfo;

        if (priceCount > user.coins) {
            [SVProgressHUD showImage:nil status:@"你的金币不足"];
            return;
        }
                
        self.clickSelectModelBlock(self.selectModel,self.labCount.text);
    }
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.model.giftsList.count;
}



- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JLGiftModel *model =  self.model.giftsList[indexPath.row];
    JLGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLGiftCell" forIndexPath:indexPath];
    cell.model = model;
    
    if (model.indexPath == indexPath) {
        cell.layer.borderColor = [UIColor colorWithHexString:@"#FE006B"].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.layer.borderColor = [UIColor clearColor].CGColor;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    for (JLGiftModel *model in self.model.giftsList) {
        model.indexPath = nil;
    }
    
    JLGiftModel *model =  self.model.giftsList[indexPath.row];
    model.indexPath = indexPath;
    self.selectModel = model;
    
    [collectionView reloadData];
}



- (void)show{
    Weakself(ws)
    [self layoutIfNeeded];
    [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws);
        make.left.right.equalTo(@(0));
        make.height.equalTo(@(390));
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        [self layoutIfNeeded];
    }];
}



- (void)hide{
    Weakself(ws)
    [self.vContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(ws.mas_bottom);
        make.height.equalTo(@(390));
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end





@interface JLGiftCell()


@property (nonatomic, strong) UIImageView *imageIcon;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIImageView *coinIcon;
@property (nonatomic, strong) UILabel *coinLab;


@end

@implementation JLGiftCell



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        [self creatUI];
    }
    return  self;
}



- (void)creatUI{
    
    [self addSubview:self.imageIcon];
    [self addSubview:self.nameLab];
    [self addSubview:self.coinLab];
    [self addSubview:self.coinIcon];
    
    
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@64);
        make.height.equalTo(@64);
        make.top.equalTo(self).offset(8);
        make.centerX.equalTo(self);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageIcon);
        make.top.equalTo(self.imageIcon.mas_bottom).offset(2);
    }];
    
    [self.coinLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(2);
        make.centerX.equalTo(self).offset(-10);
    }];
    

    [self.coinIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.coinLab);
        make.centerX.equalTo(self).offset(10);
        make.size.mas_offset(CGSizeMake(8, 8));
    }];

}

- (void)setModel:(JLGiftModel *)model{
    [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:model.giftIcon]];
    self.nameLab.text = model.giftName;
    self.coinLab.text = [NSString stringWithFormat:@"%ld",model.coin];
}



- (UIImageView *)imageIcon{
    if (!_imageIcon) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage imageNamed:@""];
        _imageIcon = view;
    }
    
    return  _imageIcon;
}


- (UIImageView *)coinIcon{
    if (!_coinIcon) {
        UIImageView *view = [[UIImageView alloc] init];
        view.image = [UIImage jl_name:@"jl_coin" class:self];
        view.contentMode = UIViewContentModeScaleAspectFill;
        _coinIcon = view;
    }
    
    return  _coinIcon;
}


- (UILabel *)nameLab{
    if (!_nameLab) {
        UILabel *view = [[UILabel alloc] init];
        view.text = @"";
        view.textColor = [UIColor colorWithHexString:@"#000000"];
        view.font = [UIFont systemFontOfSize:10];
        _nameLab = view;
    }
    return  _nameLab;
}


- (UILabel *)coinLab{
    if (!_coinLab) {
        UILabel *view = [[UILabel alloc] init];
        view.text = @"";
        view.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.5];
        view.font = [UIFont systemFontOfSize:8];
        _coinLab = view;
    }
    return  _coinLab;
}



@end

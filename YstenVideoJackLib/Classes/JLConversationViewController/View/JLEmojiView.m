//
//  JLEmojiView.m
//  LJChatSDK
//
//  Created by percent on 2026/1/9.
//

#import "JLEmojiView.h"
#import "RCKitUtility.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Add.h"

@interface JLEmojiView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *faceEmojiArray;

@property (nonatomic,strong) UIButton *delBtn;

@end

@implementation JLEmojiView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}


- (void)createUI{
    [self addSubview:self.collectionView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]; // 可选: Light, Dark, ExtraLight等
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self addSubview:effectView];

    [self addSubview:self.delBtn];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    
    
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-13);
        make.bottom.equalTo(self).offset(-34);
        make.width.equalTo(@70);
        make.height.equalTo(@53);
    }];

    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-13);
        make.bottom.equalTo(self).offset(-34);
        make.width.equalTo(@70);
        make.height.equalTo(@53);
    }];
    
    NSString *bundlePath = [RCKitUtility filePathForName:@"Emoji.plist"];
    self.faceEmojiArray = [[NSArray alloc] initWithContentsOfFile:bundlePath];
    
    

    
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.faceEmojiArray.count;
}



- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string =  self.faceEmojiArray[indexPath.row];
    
    JLEmojiViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JLEmojiViewCell" forIndexPath:indexPath];
    if (cell) {
        cell.emojiLabel.text = string;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string =  self.faceEmojiArray[indexPath.row];
    
    if (self.clickSelectEmojiBlock) {
        self.clickSelectEmojiBlock(string);
    }
}

- (void)clickDelBtnEvent{
    
    if (self.clickDelEmojiBlock) {
        self.clickDelEmojiBlock();
    }
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        CGFloat width = ([UIScreen mainScreen].bounds.size.width-10.0)/7.0;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(width, width);
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [view registerClass:[JLEmojiViewCell class] forCellWithReuseIdentifier:@"JLEmojiViewCell"];
        view.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
        view.delegate = self;
        view.dataSource = self;
        _collectionView = view;
    }
    
    return  _collectionView;
}



- (UIButton *)delBtn{
    if (!_delBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage jl_name:@"jl_emojiDelete" class:self] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickDelBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        _delBtn = btn;
    }
    
    return  _delBtn;
}


@end






@interface JLEmojiViewCell ()


@end

@implementation JLEmojiViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}




- (void)createUI{
    [self addSubview:self.emojiLabel];

    [self.emojiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40,40));
    }];
}

- (UILabel *)emojiLabel{
    if (!_emojiLabel) {
        UILabel *view = [[UILabel alloc] init];
        _emojiLabel = view;
    }
    return  _emojiLabel;
}



@end

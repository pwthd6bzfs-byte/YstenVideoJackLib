    //
    //  JLChatListContainer.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/26.
    //

#import "JLFollowContainer.h"
#import "JLFansVC.h"
#import "JLFollowVC.h"
#import "CustomNaviBarView.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Add.h"
@interface JLFollowContainer ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, strong) JLFollowVC *vc;

@property (nonatomic, strong) JLFansVC *vc1;

@property (nonatomic, strong) UIButton *navBackBtn;


@end

@implementation JLFollowContainer


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    Weakself(ws)
    
        // 初始化 JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, self.view.frame.size.width, 44)];
    
        // 设置标题数组
    self.categoryView.titles = @[@"Follow", @"Fans"];
        // 配置基本属性[citation:2][citation:9]
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"#FE006B"];
    self.categoryView.titleFont = [UIFont systemFontOfSize:15];
    self.categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:15];
    self.categoryView.titleColorGradientEnabled = YES; // 启用颜色渐变
    self.categoryView.cellSpacing = 20; // 设置单元格之间的间距
    CGFloat left =  (kScreenWidth - 120 - 20)/2.0;
    self.categoryView.contentEdgeInsetLeft = left; // 左边距
    self.categoryView.contentEdgeInsetRight = left; // 右边距，可以设置为0，但为了美观可以设置一个值
    self.categoryView.cellWidth = 60;
    self.categoryView.averageCellSpacingEnabled = YES; // 禁用平均分布
    
        // 添加指示器（下划线）
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor clearColor];
    lineView.indicatorWidth = 30; // 自适应标题宽度
    lineView.indicatorHeight = 2;
    self.categoryView.indicators = @[lineView];
        // 在 viewDidLoad 中设置代理
    self.categoryView.delegate = self;
    self.categoryView.listContainer = self.listContainerView;
    
    
    
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.listContainerView];
    [self.view addSubview:self.navBackBtn];

    
    
    [self.navBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(6 + kStatusBarHeight);
        make.left.equalTo(self.view).offset(16);
        make.size.mas_offset(CGSizeMake(32, 32));
    }];
}





- (void)clickNavBackBtnEvnet{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - JXCategoryListContainerViewDelegate
    // 返回列表数量[citation:9]
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.controllers.count;
}

    // 创建并返回每个索引对应的列表实例（懒加载）[citation:9]
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    if (index == 0) {
        JLFollowVC *listVC = [[JLFollowVC alloc] init];
            // 可以传入index或title来让列表页面加载不同的数据
        return listVC;
    }else{
        JLFansVC *listVC = [[JLFansVC alloc] init];
            // 可以传入index或title来让列表页面加载不同的数据
        return listVC;
    }
    
        // 这里根据你的业务返回不同的列表视图控制器或视图
}

#pragma mark - JXCategoryViewDelegate (可选)

    // 实现代理方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
        // 当用户点击某个标题时调用，index 为选中项的索引
        // 在这里，你可以根据 index 切换下方内容区域的视图或控制器
    NSLog(@"选中了索引为: %ld", (long)index);
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
        // 当用户通过滑动切换内容时调用，index 为当前选中项的索引
        // 可用于实现联动效果
}


    //子控制器数组
- (NSArray<__kindof UIViewController *> *)controllers{
    return @[
        self.vc,
        self.vc1,
    ];
}





- (JXCategoryListContainerView *)listContainerView{
    if (!_listContainerView) {
        JXCategoryListContainerView *view = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        view.scrollView.scrollEnabled = NO;
        view.frame = CGRectMake(0, kStatusBarHeight+44, self.view.bounds.size.width, kScreenHeight-kStatusBarHeight-44);
        view.backgroundColor = [UIColor whiteColor];
        _listContainerView = view;
    }
    
    return _listContainerView;
}



- (JLFollowVC *)vc{
    if (!_vc) {
        JLFollowVC *vc = [[JLFollowVC alloc] init];
        _vc = vc;
    }
    return _vc;
}




- (JLFansVC *)vc1{
    if (!_vc1) {
        JLFansVC *vc = [[JLFansVC alloc] init];
        _vc1 = vc;
    }
    return _vc1;
}

- (UIButton *)navBackBtn{
    if (!_navBackBtn) {
        UIButton *view = [[UIButton alloc] init];
        
        [view setImage:[UIImage jl_name:@"jl_navBackBlackIcon" class:self] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(clickNavBackBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        _navBackBtn = view;
    }
    return  _navBackBtn;
}







@end

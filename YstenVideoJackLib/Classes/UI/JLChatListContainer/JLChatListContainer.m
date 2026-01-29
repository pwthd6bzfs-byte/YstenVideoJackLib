//
//  JLChatListContainer.m
//  LJChatSDK
//
//  Created by percent on 2026/1/26.
//

#import "JLChatListContainer.h"
#import "JLConversationListVC.h"
#import "JLFollowContainer.h"
#import "JLCallHistoryVC.h"
#import "CustomNaviBarView.h"
#import "Config.h"
#import "UIColor+HexColor.h"
#import <Masonry/Masonry.h>

@interface JLChatListContainer ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>

@property (nonatomic, strong) CustomNaviBarView *customNaviBarView;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;

@property (nonatomic, strong) JLConversationListVC *vc;

@property (nonatomic, strong) JLCallHistoryVC *vc1;


@end

@implementation JLChatListContainer


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
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, kNavigationBar_Height, self.view.frame.size.width, 44)];
    
        // 设置标题数组
    self.categoryView.titles = @[@"Depth Message", @"Call History"];
        // 配置基本属性[citation:2][citation:9]
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleSelectedColor = [UIColor colorWithHexString:@"#FE006B"];
    self.categoryView.titleFont = [UIFont systemFontOfSize:12];
    self.categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:12];
    self.categoryView.titleColorGradientEnabled = YES; // 启用颜色渐变
    self.categoryView.cellSpacing = 15; // 设置单元格之间的间距
    self.categoryView.contentEdgeInsetLeft = 20; // 左边距
//    self.categoryView.contentEdgeInsetRight = 10; // 右边距，可以设置为0，但为了美观可以设置一个值
    self.categoryView.cellWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.averageCellSpacingEnabled = NO; // 禁用平均分布

        // 添加指示器（下划线）
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor colorWithHexString:@"#FE006B"];
    lineView.indicatorWidth = 30; // 自适应标题宽度
    lineView.indicatorHeight = 2;
    self.categoryView.indicators = @[lineView];
        // 在 viewDidLoad 中设置代理
    self.categoryView.delegate = self;
    self.categoryView.listContainer = self.listContainerView;
    
    
    
    // 将其添加到父视图
    [self.view addSubview:self.customNaviBarView];
    // 返回
    self.customNaviBarView.clickBackBtnEvent = ^{
        [ws.navigationController popViewControllerAnimated:YES];
    };
    
    //关注
    self.customNaviBarView.clickRightBtnEvent = ^{
        JLFollowContainer *vc = [[JLFollowContainer alloc] init];
        [ws.navigationController pushViewController:vc animated:YES];
    };

    [self.customNaviBarView setRightFirstButtonWithImageName:@"jl_follow"];
        // 自定义导航栏
    [self.customNaviBarView setTitle:@"Depth Message"];

    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.listContainerView];
    
    
    
    
    [self.customNaviBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@44);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kStatusBarHeight);
    }];
    
        
}






#pragma mark - JXCategoryListContainerViewDelegate
    // 返回列表数量[citation:9]
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.controllers.count;
}

    // 创建并返回每个索引对应的列表实例（懒加载）[citation:9]
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    if (index == 0) {
        JLConversationListVC *listVC = [[JLConversationListVC alloc] init];
            // 可以传入index或title来让列表页面加载不同的数据
        return listVC;
    }else{
        JLCallHistoryVC *listVC = [[JLCallHistoryVC alloc] init];
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
        view.frame = CGRectMake(0, kNavigationBar_Height+44, self.view.bounds.size.width, kScreenHeight-kNavigationBar_Height-44);
        view.backgroundColor = [UIColor whiteColor];
        _listContainerView = view;
    }
    
    return _listContainerView;
}



- (JLConversationListVC *)vc{
    if (!_vc) {
        JLConversationListVC *vc = [[JLConversationListVC alloc] init];
        _vc = vc;
    }
    return _vc;
}




- (JLCallHistoryVC *)vc1{
    if (!_vc1) {
        JLCallHistoryVC *vc = [[JLCallHistoryVC alloc] init];
        _vc1 = vc;
    }
    return _vc1;
}


-(CustomNaviBarView *)customNaviBarView {
    
    if (!_customNaviBarView) {
        CustomNaviBarView *view = [[CustomNaviBarView alloc] init];
        _customNaviBarView = view;
    }
    return _customNaviBarView;
}










@end

    //
    //  JLCallHistoryVC.m
    //  LJChatSDK
    //
    //  Created by percent on 2026/1/26.
    //

#import "JLFansVC.h"
#import "JLFansCell.h"
#import "VideoViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "JLAPIService.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Config.h"
#import "JLRTCService.h"
#import "YYKit.h"
#import "UIImage+Add.h"
#import "JLAnchorUserModel.h"
#import "VideoViewController.h"

@interface JLFansVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

    // 消息TableView
@property (nonatomic, strong) UITableView *tableView;
    // 数据源
@property (nonatomic, strong) JLFansListModel *model;

@property (nonatomic, assign) int page;

@property (nonatomic, assign) int size;

@property (nonatomic, assign) BOOL isReuqest;

@end

@implementation JLFansVC



- (void)dealloc{
    NSLog(@"JLCallHistoryVC 销毁");
}


- (void)viewWillAppear:(BOOL)animatedw{
    [super viewWillAppear:animatedw];
    [self requestData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 0;
    self.size = 100;
    [self initialize];
}




- (void)headRefreshEvent{
    [self.model.records removeAllObjects];
    self.size = 100;
    self.page = 0;
    [JLAPIService getFansInfowithWithPage:self.page size:self.size success:^(NSDictionary * _Nonnull result) {
        
        self.page += 1;
        self.size += 100;

        [self.tableView.mj_header endRefreshing];
        
        self.model = [JLFansListModel modelWithJSON:result[@"data"]];
        [self.tableView reloadData];
        
    } failued:^(NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}






- (void)footRefreshEvent{
    
    
    [JLAPIService getFansInfowithWithPage:0 size:self.size success:^(NSDictionary * _Nonnull result) {
        
        self.page += 1;
        self.size += 100;

        [self.tableView.mj_footer endRefreshing];

        self.model = [JLFansListModel modelWithJSON:result[@"data"]];
        [self.tableView reloadData];
        
    } failued:^(NSError * _Nonnull error) {
        
        [self.tableView.mj_footer endRefreshing];
    }];
}






- (void)requestData{
    [self.model.records removeAllObjects];
    self.page = 0;
    self.size = 100;
    
    [SVProgressHUD show];
    [JLAPIService getFansInfowithWithPage:0 size:self.size success:^(NSDictionary * _Nonnull result) {
        
        [SVProgressHUD dismiss];
        self.isReuqest = YES;

        self.page += 1;
        self.size += 100;

        self.model = [JLFansListModel modelWithJSON:result[@"data"]];
        [self.tableView reloadData];
        
    } failued:^(NSError * _Nonnull error) {
        self.isReuqest = YES;
        [SVProgressHUD dismiss];
    }];
}






// 关注主播
- (void)requestFollowData:(NSString *)ID{
    [SVProgressHUD show];
    [JLAPIService addFollowWithAnchorID:[ID integerValue] success:^(NSDictionary * _Nonnull result) {
        [SVProgressHUD dismiss];
        [self requestData];
        
    } failued:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}





- (void)showVideo:(NSString *)jlAnchorId{
    
    if (jlAnchorId) {
            // 拨打视频
        [[JLRTCService shared] videoCallWithAnchorID:[jlAnchorId integerValue] success:^(NSString * _Nonnull channel, NSString * _Nonnull token,JLAnchorUserModel * _Nonnull anchorUserInfo) {
            VideoViewController *controller = [[VideoViewController alloc] init];
            controller.modalPresentationStyle = 0;
            controller.channel = channel;
            controller.token = token;
            controller.isNeedPush = YES;
            controller.anchorID = [jlAnchorId integerValue];
            controller.anchorRtcToken = @"";
            controller.anchorUserInfo = anchorUserInfo;
            [self presentViewController:controller animated:YES completion:nil];
            
        } failued:^(NSError * _Nonnull error) {
            
        }];
    }
}




- (void)initialize{
    [self.view addSubview:self.tableView];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];

    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
}







- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.records.count;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JLFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLFansCell"];
    JLFansModel *model = self.model.records[indexPath.row];
    cell.model = model;

    Weakself(ws);
    cell.clickFansBtnBlock = ^(BOOL result,NSString *userID) {
        if (result == YES) {
            [ws showVideo:userID];
        }else{
            [ws requestFollowData:model.userId];
        }
    };
    
    return  cell;
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.isReuqest == NO) {
            /// 空数据界面
        return [UIImage imageNamed:@""];
    }else{
        
            /// 空数据界面
        return [UIImage jl_name:@"jl_follow_noData" class:self];
    }
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.isReuqest == NO) {
            /// 空数据界面
        return  [self titleAttributedString:@""] ;
    }else{
            /// 空数据界面
        return  [self titleAttributedString:@"No more data~"] ;
    }
}


    //- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    //    return  [self descriptionAttributedString:@"左右滑动查看新页面"] ;
    //}


    // 空页面是否可滚动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -100;
}


- (NSMutableAttributedString *)titleAttributedString:(NSString *)text {
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: [UIColor blackColor] ,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}





#pragma mark - JXCategoryListContentViewDelegate
    // 协议核心方法：返回列表视图[citation:9]
- (UIView *)listView {
    return self.view;
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
        view.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefreshEvent)];
        view.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefreshEvent)];
        view.mj_footer.automaticallyChangeAlpha = YES;
        [view registerClass:[JLFansCell class] forCellReuseIdentifier:@"JLFansCell"];
        
        if (@available(iOS 11.0, *)) {
            view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView = view;
        }
    return _tableView;
}



@end

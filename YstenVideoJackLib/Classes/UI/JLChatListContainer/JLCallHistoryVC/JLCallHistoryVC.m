//
//  JLCallHistoryVC.m
//  LJChatSDK
//
//  Created by percent on 2026/1/26.
//

#import "JLCallHistoryVC.h"
#import "JLCallHistoryCell.h"
#import "VideoViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "JLAPIService.h"
#import "JLRTCService.h"
#import <MJRefresh/MJRefresh.h>
#import "Config.h"
#import "UIImage+Add.h"

@interface JLCallHistoryVC ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

    // 消息TableView
@property (nonatomic, strong) UITableView *tableView;
    // 数据源
@property (nonatomic, strong) JLCallHistoryListModel *model;

@property (nonatomic, assign) int page;

@property (nonatomic, assign) int size;

@property (nonatomic, assign) BOOL isReuqest;

@end

@implementation JLCallHistoryVC



- (void)dealloc{
    NSLog(@"JLCallHistoryVC 销毁");
}



- (void)viewWillAppear:(BOOL)animatedw{
    [super viewWillAppear:animatedw];
    
    [self requestData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialize];
}


- (void)headRefreshEvent{
    
    [self.model.records removeAllObjects];
    self.size = 100;
    self.page = 0;
    
    [JLAPIService getVideoCallHistoryInfoWithPage:self.page size:self.size success:^(NSDictionary * _Nonnull result) {
        
        self.page += 1;
        self.size += 100;
        
        [self.tableView.mj_header endRefreshing];
        
        self.model = [JLCallHistoryListModel modelWithJSON:result[@"data"]];
        [self.tableView reloadData];

    } failued:^(NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    
}




- (void)footRefreshEvent{
    [self.model.records removeAllObjects];
    self.size = 100;
    self.page = 0;

    [JLAPIService getVideoCallHistoryInfoWithPage:self.page size:self.size success:^(NSDictionary * _Nonnull result) {
        
        self.page += 1;
        self.size += 100;
        
        [self.tableView.mj_footer endRefreshing];
        
        self.model = [JLCallHistoryListModel modelWithJSON:result[@"data"]];
        [self.tableView reloadData];

    } failued:^(NSError * _Nonnull error) {
        
        [self.tableView.mj_footer endRefreshing];
    }];
}






- (void)requestData{
    
    
    [SVProgressHUD show];
    [JLAPIService getVideoCallHistoryInfoWithPage:self.page size:self.size success:^(NSDictionary * _Nonnull result) {
        [SVProgressHUD dismiss];
        self.isReuqest = YES;
        self.model = [JLCallHistoryListModel modelWithJSON:result[@"data"]];
        [self.tableView reloadData];
        
    } failued:^(NSError * _Nonnull error) {
        self.isReuqest = YES;
        [SVProgressHUD dismiss];
    }];
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
    JLCallHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLCallHistoryCell"];
    cell.model = self.model.records[indexPath.row];
    return  cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

    // iOS 11及以后使用这个方法
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    
    Weakself(ws);
        // 删除动作
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction *action, __kindof UIView *sourceView, void (^completionHandler)(BOOL)) {
        
            // 融云删除消息单元Cell
        JLCallHistoryModel *model = self.model.records[indexPath.row];

        [JLAPIService delCallHistory:model.ID success:^(NSDictionary * _Nonnull result) {
            NSLog(@"通话历史删除成功");
//            [ws.model.records removeObjectAtIndex:indexPath.row];
//            [ws.tableView reloadData];
            [ws requestData];
        } failued:^(NSError * _Nonnull error) {
            NSLog(@"通话历史删除失败");
        }];
        
        
        completionHandler(YES);
    }];
    
    
    deleteAction.image = [UIImage jl_name:@"jl_delete" class:self];
    deleteAction.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    return configuration;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JLCallHistoryModel *model = self.model.records[indexPath.row];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips"
                                                                   message:@"Confirm to call?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *goToSettings = [UIAlertAction actionWithTitle:@"Call" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *jlAnchorId = model.anchorUserId;
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

    }];
    [alert addAction:cancel];
    [alert addAction:goToSettings];
    [self presentViewController:alert animated:YES completion:nil];

}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.isReuqest == NO) {
            /// 空数据界面
        return [UIImage imageNamed:@""];
    }else{
            /// 空数据界面
        return [UIImage jl_name:@"jl_history_empt" class:self];
    }
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.isReuqest == NO) {
            /// 空数据界面
        return  [self titleAttributedString:@""] ;
    }else{
            /// 空数据界面
        return  [self titleAttributedString:@"no conversation"] ;
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
        [view registerClass:[JLCallHistoryCell class] forCellReuseIdentifier:@"JLCallHistoryCell"];
        view.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefreshEvent)];
        view.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefreshEvent)];
        view.mj_footer.automaticallyChangeAlpha = YES;
        
        if (@available(iOS 11.0, *)) {
            view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView = view;
        }
    return _tableView;
}



@end

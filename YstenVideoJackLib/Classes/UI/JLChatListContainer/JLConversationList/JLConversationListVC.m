//
//  JLConversationListVC.m
//  JuliFrameworkDemo
//
//  Created by percent on 2026/1/5.
//

#import "JLConversationListVC.h"
#import "JLConversationViewController.h"
#import "JLRCConversationCell.h"
#import "UIScrollView+RCMJRefresh.h"
#import "JLCustomMessage.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Config.h"
#import <MJRefresh/MJRefresh.h>
#import "UIImage+Add.h"
@class ChatViewController;
@interface JLConversationListVC ()<RCIMClientReceiveMessageDelegate>

// 背景颜色
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UIView *emptyView;

@end

@implementation JLConversationListVC

- (void)dealloc{
    NSLog(@"JLConversationListVC 销毁");
}

- (void)viewDidLoad {
    

    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [super viewDidLoad];
    
    [self.conversationListTableView registerClass:[JLRCConversationCell class] forCellReuseIdentifier:@"JLRCConversationCell"];
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.conversationListTableView.rcmj_footer = [UIView new];
    self.conversationListTableView.backgroundColor = [UIColor clearColor];
    self.conversationListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefreshEvent)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"kNotificationMessageRecive" object:nil];
    
    
    
        // 自定义空视图
    self.emptyConversationView = self.emptyView;
    
}



- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {
    for (int i = 0; i < dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        if ([model.lastestMessage isMemberOfClass:[JLAskGiftMessage class]] || [model.lastestMessage isMemberOfClass:[JLGiftMessage class]]) {
            RCTextMessage *message = [[RCTextMessage alloc] init];
            message.content = @"[Gift]";
            model.lastestMessage = message;
        }else if ([model.lastestMessage isMemberOfClass:[JLVideoMessage class]]){
            NSString *statusName = @"[Video Calls]";
            RCTextMessage *message = [[RCTextMessage alloc] init];
            message.content = statusName;
            model.lastestMessage = message;
        }else if ([model.lastestMessage isMemberOfClass:[JLMediaPrivateMessage class]]){
            JLMediaPrivateMessage * mediaPrivateMessage = (JLMediaPrivateMessage *)model.lastestMessage;
            
            NSString *statusName = @"";
            if ([mediaPrivateMessage.type isEqualToString:@"1"]) {
                statusName = @"[Intimate Photo]";
            }else{
                statusName = @"[Intimate Video]";
            }
            
            RCTextMessage *message = [[RCTextMessage alloc] init];
            message.content = statusName;
            model.lastestMessage = message;
        }
    }
    return dataSource;
}



-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JLRCConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JLRCConversationCell"];
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    cell.model = model;
    return cell;
}

    // 高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  76.0;
}


- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    if (self.navigationController) {
        JLConversationViewController *conversationVC = [[JLConversationViewController alloc] initWithConversationType:model.conversationType targetId:model.targetId];
        conversationVC.conversationType = model.conversationType;
        conversationVC.targetId = model.targetId;
        conversationVC.title = model.conversationTitle;
        if (model.conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
            conversationVC.unReadMessage = model.unreadMessageCount;
            conversationVC.enableNewComingMessageIcon = YES; //开启消息提醒
            conversationVC.enableUnreadMessageIcon = YES;
        }
        [self.navigationController pushViewController:conversationVC animated:YES];
    }else{
        RCLogI(@"navigationController is nil , Please Rewrite `onSelectedTableRow:conversationModel:atIndexPath:` method to implement the conversation cell click to push RCConversationViewController vc");
    }
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
        
        // 融云删除消息单元Cell
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];

        // 置顶动作
    UIContextualAction *moreAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:nil handler:^(UIContextualAction *action, __kindof UIView *sourceView, void (^completionHandler)(BOOL)) {

        BOOL top = !model.isTop;
        __weak typeof(self) weakSelf = self;
        [[RCCoreClient sharedCoreClient] setConversationToTop:ConversationType_PRIVATE targetId:model.targetId isTop:top completion:^(BOOL ret) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf refreshUI];
            });
        }];
                
        completionHandler(YES);
    }];
    
        
    if (model.isTop == YES) {
        moreAction.image = [UIImage jl_name:@"jl_message_dwon" class:self];
    }else{
        moreAction.image = [UIImage jl_name:@"jl_message_dwon" class:self];
    }
    moreAction.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    
    
        // 删除动作
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction *action, __kindof UIView *sourceView, void (^completionHandler)(BOOL)) {
        
        // 融云删除消息单元Cell
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];

        [[RCCoreClient sharedCoreClient] removeConversation:model.conversationType targetId:model.targetId completion:^(BOOL ret) {
            if(ret){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
                    [self.conversationListTableView reloadData];
                });
            }
        }];

        completionHandler(YES);
    }];
    deleteAction.image = [UIImage jl_name:@"jl_delete" class:self];
    
    deleteAction.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction,moreAction]];
    return configuration;
}




#pragma mark - JXCategoryListContentViewDelegate
    // 协议核心方法：返回列表视图[citation:9]
- (UIView *)listView {
    return self.view;
}



- (void)headRefreshEvent{
    [self refreshUI];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.conversationListTableView.mj_header endRefreshing];
    });
}


- (void)refreshUI{
    [self refreshConversationTableViewIfNeeded];
}


-(UIView *)emptyView{
    if (!_emptyView) {
        UIView *view = [[UIView alloc] init];
            //视图的 frame 需要开发者根据需求设定
        UIImageView *empty = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-120)/2, (kScreenHeight-54-kNavigationBar_Height-220)/2, 120, 120)];
        empty.backgroundColor = [UIColor clearColor];
        
        empty.image = [UIImage jl_name:@"jl_history_empt" class:self];
        [view addSubview:empty];
        
        _emptyView = empty;
    }
    return _emptyView;
}



@end

//
//  JLHeartMatchController.m
//  LJChatSDK
//
//  Created by percent on 2026/1/23.
//

#import "JLHeartMatchController.h"
#import "AnimationView.h"
#import "JLHeartMatchModel.h"
#import "config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JLUserService.h"
#import "JLAPIService.h"
#import "YYKit.h"
#import "UIImage+Add.h"

@interface JLHeartMatchController ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *headTimer;
@property (nonatomic, strong) AnimationView *animationView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *explainLab;
//随机视图
@property (nonatomic, strong) UIImageView *randomView;
//随机视图(相对俯视图)
@property (nonatomic, strong) UIView *allowedAreaView;

@property (nonatomic, strong) UIButton *navBackBtn;

@property (nonatomic, strong) JLHeartMatchModel *model;

@property (nonatomic, assign) BOOL isCancel;

@end

@implementation JLHeartMatchController



- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
        // 在视图控制器销毁时，确保定时器被销毁
    NSLog(@"JLHeartMatchController 销毁");
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
    [self.headTimer invalidate];
    self.headTimer = nil;

    self.isCancel = YES;

    // 取消速配
    [self cancaelHeartMatchReuqestData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessage)
                                                 name:kNotificationRcMessageSuccess
                                               object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self createUI];
    [self requestData];
    [self startHeadTimer];
    
    
}


- (void)createUI{
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.animationView];
    [self.view addSubview:self.navBackBtn];
    
    [self.animationView radAnimation:[UIColor colorWithHexString:@"#FE8990"]];
    
    [self.navBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(6 + kStatusBarHeight);
        make.left.equalTo(self.view).offset(16);
        make.size.mas_offset(CGSizeMake(32, 32));
    }];

    
    UIImageView *headImageContent = [[UIImageView alloc] init];
    headImageContent.backgroundColor = [UIColor whiteColor];
    headImageContent.layer.cornerRadius = 40;
    headImageContent.layer.masksToBounds = YES;
    [self.view addSubview:headImageContent];
    
    
    [self.view addSubview:self.headImageView];
    [self.view addSubview:self.explainLab];
    [self.view addSubview:self.randomView];
    JLUserModel *userInfo =  [JLUserService shared].userInfo;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.headFileName]] ;
    
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [headImageContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(-100);
        make.centerX.equalTo(self.view);
        make.size.mas_offset(CGSizeMake(80, 80));
    }];
    
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).offset(-100);
        make.centerX.equalTo(self.view);
        make.size.mas_offset(CGSizeMake(78, 78));
    }];
    
    
    
    [self.explainLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(headImageContent.mas_bottom).offset(180);
    }];

    
    
    
    // 用来判断
    CGRect allowedArea = CGRectMake(20, 190, kScreenWidth-40, kScreenWidth-80);
    UIView *allowedAreaView = [[UIView alloc] initWithFrame:allowedArea];
    self.allowedAreaView = allowedAreaView;
    allowedAreaView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:allowedAreaView];
}




- (void)clickNavBackBtnEvnet{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:NO];
    });
}



- (void)didReceiveMessage{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
    });
}







// 重新请求
- (void)resetRequstData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestData];
    });
}






// 设置匹配头像随机定时器
- (void)startHeadTimer{
        // 如果定时器已经存在，先暂停（避免多个定时器同时运行）
    if (self.headTimer) {
        [self.headTimer invalidate];
        self.headTimer = nil;
    }
    
        // 创建并启动定时器，每隔1秒触发一次timerFired方法
    self.headTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                  target:self
                                                selector:@selector(timerHeadFired)
                                                userInfo:nil
                                                 repeats:YES];
}





- (void)timerHeadFired{
    self.randomView.alpha = 1;
    self.randomView.hidden = NO;
    
    [self addSubviewAtRandomPosition:self.randomView toView:self.allowedAreaView];

    [UIView animateWithDuration:5 animations:^{
        self.randomView.alpha = 0;
    }];
    
}





    // 在父视图中添加子视图到随机位置（避开中心区域）
- (void)addSubviewAtRandomPosition:(UIView *)subview toView:(UIView *)parentView {
        // 获取父视图和子视图的尺寸
    CGFloat parentWidth = CGRectGetWidth(parentView.bounds);
    CGFloat parentHeight = CGRectGetHeight(parentView.bounds);
    CGFloat subviewWidth = CGRectGetWidth(subview.bounds);
    CGFloat subviewHeight = CGRectGetHeight(subview.bounds);
    
        // 定义中心区域的尺寸（例如：视图的1/3区域）
    CGFloat centerAreaWidth = parentWidth / 3.0;
    CGFloat centerAreaHeight = parentHeight / 3.0;
    
        // 计算中心区域的边界
    CGFloat centerAreaX = (parentWidth - centerAreaWidth) / 2.0;
    CGFloat centerAreaY = (parentHeight - centerAreaHeight) / 2.0;
    
        // 随机生成位置，确保不在中心区域内
    CGFloat randomX, randomY;
    BOOL isInCenterArea = YES;
    int maxAttempts = 100; // 最大尝试次数，避免无限循环
    int attempts = 0;
    
    while (isInCenterArea && attempts < maxAttempts) {
            // 生成随机位置（确保子视图完全在父视图内）
        randomX = arc4random_uniform(parentWidth - subviewWidth);
        randomY = arc4random_uniform(parentHeight - subviewHeight);
        
            // 计算子视图中心点
        CGFloat subviewCenterX = randomX + subviewWidth / 2.0;
        CGFloat subviewCenterY = randomY + subviewHeight / 2.0;
        
            // 检查是否在中心区域内
        isInCenterArea = (subviewCenterX > centerAreaX &&
                          subviewCenterX < centerAreaX + centerAreaWidth &&
                          subviewCenterY > centerAreaY &&
                          subviewCenterY < centerAreaY + centerAreaHeight);
        
        attempts++;
    }
    
        // 设置子视图位置
    subview.frame = CGRectMake(randomX, randomY, subviewWidth, subviewHeight);
    [parentView addSubview:subview];
}





// 设置超时定时器
- (void)startTimer {
        // 如果定时器已经存在，先暂停（避免多个定时器同时运行）
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
        // 创建并启动定时器，每隔1秒触发一次timerFired方法
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.model.heartbeatMatchTimeOut
                                                  target:self
                                                selector:@selector(timerFired)
                                                userInfo:nil
                                                 repeats:YES];
}


- (void)timerFired{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}



// 发起心动速配请求
- (void)requestData{
    
    if (self.isCancel == YES) {
        return;
    }
    
    Weakself(ws)
    [JLAPIService heartBeatWithSuccess:^(NSDictionary * _Nonnull result) {

        ws.model = [JLHeartMatchModel modelWithJSON:result[@"data"]];
        // 重起速配
        if (ws.model.anchors.count <= 0) {
            [ws resetRequstData];
            NSLog(@"发起心动速配 没有主播");
            return;
        }
        
        [ws startTimer];
        
        NSLog(@"发起心动速配成功");

        
    } failued:^(NSError * _Nonnull error) {
        NSLog(@"心动速配发起失败");
    }];
}





// 取消心动速配请求
- (void)cancaelHeartMatchReuqestData{
    
    if (!self.model.batchId || self.model.batchId.length <= 0) {
        self.model.batchId = @"";
    }
    
    [JLAPIService cancelHeartBeatWithBatchId:self.model.batchId success:^(NSDictionary * _Nonnull result) {
        NSLog(@"取消心动速配成功");
    } failued:^(NSError * _Nonnull error) {
        NSLog(@"取消速配发起失败");
    }];
}




- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.image = [UIImage jl_name:@"chat_bg_2" class:self];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.layer.masksToBounds = YES;
        _bgImageView = view;
    }
    return _bgImageView;
}





- (UIImageView *)headImageView{
    if (!_headImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 78/2.0;
        view.layer.masksToBounds = YES;
        _headImageView = view;
    }
    return _headImageView;
}




- (AnimationView *)animationView{
    if (!_animationView) {
        AnimationView *view = [[AnimationView alloc] initWithFrame:CGRectMake(0, -100, kScreenWidth, kScreenHeight)];
        view.backgroundColor = [UIColor clearColor];
//        view.layer.cornerRadius = 78/2.0;
//        view.layer.masksToBounds = YES;
        _animationView = view;
    }
    return _animationView;
}



- (UILabel *)explainLab{
    if (!_explainLab) {
        UILabel *view = [[UILabel alloc] init];
        view.textColor = [UIColor blackColor];
        view.text = @"Matching for you...";
        view.font = [UIFont boldSystemFontOfSize:16];
        _explainLab = view;
    }
    return  _explainLab;
}




- (UIImageView *)randomView{
    if (!_randomView) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
        view.backgroundColor = [UIColor clearColor];
        view.image = [UIImage jl_name:@"jl_heatMatch" class:self];
        view.hidden = YES;
        view.layer.cornerRadius = 56/2.0;
        view.layer.masksToBounds = YES;
        _randomView = view;
    }
    return _randomView;
}


- (UIButton *)navBackBtn{
    if (!_navBackBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setImage:[UIImage jl_name:@"navBackBlackIcon" class:self] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(clickNavBackBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        _navBackBtn = view;
    }
    return  _navBackBtn;
}








@end

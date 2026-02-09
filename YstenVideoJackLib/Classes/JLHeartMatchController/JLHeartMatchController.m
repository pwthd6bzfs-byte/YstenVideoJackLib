//
//  JLHeartMatchController.m
//  LJChatSDK
//
//  Created by percent on 2026/1/23.
//

#import "JLHeartMatchController.h"
#import "AnimationView.h"
#import "JLHeartMatchModel.h"
#import "Config.h"
#import <Masonry/Masonry.h>
#import "UIColor+HexColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JLUserService.h"
#import "JLAPIService.h"
#import "YYKit.h"
#import "UIImage+Add.h"
#import <AVFoundation/AVFoundation.h>
#import "JLAnchorUserModel.h"
#import <RongCloudOpenSource/RongIMKit.h>


@interface JLHeartMatchController ()<AVAudioPlayerDelegate>

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

@property (nonatomic, strong) UILabel *labTitle;

@property (nonatomic, strong) UIButton *musicBtn;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;


@property (nonatomic, strong) JLHeartMatchModel *model;

@property (nonatomic, strong) NSMutableArray *iamges;

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
    
    
        // 默认关闭深色模式
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    } else {
            // Fallback on earlier versions
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessage)
                                                 name:kNotificationRcMessageSuccess
                                               object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self createUI];
    [self requestData];
    [self startHeadTimer];
    [self setupAudioPlayer];
    [self setupAudioSession];
}


- (void)createUI{
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.animationView];
    [self.view addSubview:self.navBackBtn];
    [self.view addSubview:self.labTitle];
    [self.view addSubview:self.musicBtn];
    
    [self.animationView radAnimation:[UIColor colorWithHexString:@"#FE8990"]];
    
    [self.navBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(6 + kStatusBarHeight);
        make.left.equalTo(self.view).offset(16);
        make.size.mas_offset(CGSizeMake(32, 32));
    }];
    
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBackBtn);
        make.centerX.equalTo(self.view);
    }];
    
    [self.musicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navBackBtn);
        make.right.equalTo(self.view).offset(-16);
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
        [self.audioPlayer pause];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:NO];
    });
}



- (void)didReceiveMessage{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioPlayer pause];
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:NO];
    });
}




- (void)clickMusicBtnEvnet{
    self.musicBtn.selected = !self.musicBtn.selected;
    if (self.musicBtn.selected == NO) {
        [self.audioPlayer play];
    }else{
        [self.audioPlayer pause];
    }
}


- (void)setupAudioPlayer {
        // 获取本地音频文件路径
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleURL = [bundle URLForResource:@"YstenVideoJackLib" withExtension:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:bundleURL];

    NSString *path = [resourceBundle pathForResource:@"jl_music" ofType:@"mp3"];
    NSURL *audioURL = [NSURL fileURLWithPath:path];
    
        // 或者使用网络音频（注意：AVAudioPlayer不支持直接播放网络音频）
        // NSURL *audioURL = [NSURL URLWithString:@"https://example.com/audio.mp3"];
    
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    
    if (error) {
        NSLog(@"初始化播放器失败: %@", error.localizedDescription);
        return;
    }
    
    self.audioPlayer.delegate = self;
//    self.audioPlayer.enableRate = YES; // 允许调节播放速率
    self.audioPlayer.numberOfLoops = -1; // 0:不循环，-1:无限循环，n:循环n次
    
        // 预加载音频（缓冲）
    [self.audioPlayer prepareToPlay];
        // 4. 开始播放
    [self.audioPlayer play];
}


- (void)setupAudioSession {
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
        // 设置类别
    [audioSession setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers |
     AVAudioSessionCategoryOptionDuckOthers
                        error:&error];
    
    if (error) {
        NSLog(@"❌ 音频会话设置失败: %@", error.localizedDescription);
    } else {
        NSLog(@"✅ 音频会话设置成功");
    }
    
        // 激活会话
    [audioSession setActive:YES error:&error];
    if (error) {
        NSLog(@"❌ 激活音频会话失败: %@", error.localizedDescription);
    }
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
    
    NSInteger count = self.model.anchors.count;
    int randomNumber = arc4random_uniform(count);

    if ((self.iamges) != nil && (self.iamges.count) >= count) {
        [self.randomView sd_setImageWithURL:self.iamges[randomNumber] placeholderImage:[UIImage jl_name:@"jl_heartMatch_head" class:self]];
    }else{
        self.randomView.image = [UIImage jl_name:@"jl_heartMatch_head" class:self];
    }
    
    
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
        [self.audioPlayer pause];
        self.navigationController.navigationBarHidden = NO;
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
        
        [ws dwonImage];
        
        [ws startTimer];
        
        NSLog(@"发起心动速配成功");

        
    } failued:^(NSError * _Nonnull error) {
        NSLog(@"心动速配发起失败");
    }];
}





- (void)dwonImage{
    
    Weakself(ws)
    self.iamges = [[NSMutableArray alloc] init];
    [[RCCoreClient sharedCoreClient] getUserProfiles:self.model.anchors success:^(NSArray<RCUserProfile *> *userProfiles) {
        for (int i = 0; i < userProfiles.count; i++) {
            RCUserProfile *model =  userProfiles[i];
            [self.iamges addObject:model.portraitUri];
        }
        
    } error:^(RCErrorCode errorCode) {
            // 获取失败
    }];
    
        
    [ws downloadImagesWithURLs:self.iamges];
}


- (void)downloadImagesWithURLs:(NSArray<NSString *> *)urlStrings {
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    for (NSString *urlString in urlStrings) {
        NSURL *url = [NSURL URLWithString:urlString];
        if (!url) continue;
        
        [manager loadImageWithURL:url
                          options:SDWebImageHighPriority | SDWebImageRetryFailed
                         progress:nil
                        completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (image && finished) {
                NSLog(@"下载完成: %@", imageURL.absoluteString);
                    // 处理下载完成的图片
//                [self handleDownloadedImage:image forURL:imageURL];
            }
        }];
    }
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


    // AVAudioPlayerDelegate 方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"音频播放完成");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"解码错误: %@", error.localizedDescription);
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
        view.image = [UIImage jl_name:@"jl_heartMatch_head" class:self];
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
        [view setImage:[UIImage jl_name:@"jl_navBackBlackIcon" class:self] forState:UIControlStateNormal];
        [view addTarget:self action:@selector(clickNavBackBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        _navBackBtn = view;
    }
    return  _navBackBtn;
}


- (UIButton *)musicBtn{
    if (!_musicBtn) {
        UIButton *view = [[UIButton alloc] init];
        [view setImage:[UIImage jl_name:@"jl_music" class:self] forState:UIControlStateNormal];
        [view setImage:[UIImage jl_name:@"jl_music_no" class:self] forState:UIControlStateSelected];
        [view addTarget:self action:@selector(clickMusicBtnEvnet) forControlEvents:UIControlEventTouchUpInside];
        _musicBtn = view;
    }
    return  _musicBtn;
}



- (UILabel *)labTitle {
    if (!_labTitle) {
        UILabel *lab = [UILabel new];
        lab.font = [UIFont boldSystemFontOfSize:17];
        lab.textColor =  [UIColor blackColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"Heartmatch";
        _labTitle = lab;
    }
    return _labTitle;
}








@end

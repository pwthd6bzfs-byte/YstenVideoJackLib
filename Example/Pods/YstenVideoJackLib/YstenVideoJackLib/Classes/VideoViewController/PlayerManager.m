//
//  VideoCacheManager.m
//  LJChatSDK
//
//  Created by percent on 2026/1/22.
//

#import <objc/runtime.h>
#include <CommonCrypto/CommonDigest.h>

// PlayerManager.m
#import "PlayerManager.h"

@interface PlayerManager()
@property (nonatomic, strong) id timeObserver;
@end

@implementation PlayerManager

+ (instancetype)sharedManager {
    static PlayerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PlayerManager alloc] init];
    });
    return instance;
}

- (void)playVideoWithURL:(NSString *)urlString inView:(UIView *)containerView {
    if ([urlString isEqualToString:self.currentVideoURL] && self.player) {
        [self.player play];
        return;
    }
    
    self.currentVideoURL = urlString;
    
        // 清除之前的播放器
    [self cleanPlayer];
    
        // 创建 AVAsset
    NSURL *videoURL = [NSURL URLWithString:urlString];
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    
        // 创建 AVPlayerItem
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
        // 添加观察者
    [self addObservers];
    
        // 创建 AVPlayer
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
        // 创建 AVPlayerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = containerView.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
        // 添加到容器视图
    [containerView.layer addSublayer:self.playerLayer];
    
        // 开始播放
    [self.player play];
}

- (void)addObservers {
        // 播放状态观察
    [self.playerItem addObserver:self
                      forKeyPath:@"status"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    
        // 缓冲进度观察
    [self.playerItem addObserver:self
                      forKeyPath:@"loadedTimeRanges"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    
        // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准备播放");
                break;
            case AVPlayerItemStatusFailed:
                NSLog(@"播放失败: %@", self.playerItem.error);
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"未知状态");
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            // 计算缓冲进度
        NSArray *loadedTimeRanges = self.playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval bufferedTime = startSeconds + durationSeconds;
        
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        CGFloat progress = bufferedTime / totalDuration;
        
        NSLog(@"缓冲进度: %.2f%%", progress * 100);
    }
}

- (void)playbackFinished:(NSNotification *)notification {
    NSLog(@"播放完成");
    [self.player seekToTime:kCMTimeZero];
}

- (void)cleanPlayer {
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    if (self.player) {
        [self.player pause];
        self.player = nil;
    }
    
    if (self.playerLayer) {
        [self.playerLayer removeFromSuperlayer];
        self.playerLayer = nil;
    }
}

@end

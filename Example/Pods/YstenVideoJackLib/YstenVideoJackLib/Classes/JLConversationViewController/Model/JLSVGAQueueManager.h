//
//  JLSVGAQueueManager.h
//  LJChatSDK
//
//  Created by percent on 2026/1/13.
//

#import <Foundation/Foundation.h>
#import <SVGAPlayer/SVGAPlayer.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SVGAAnimationCompletion)(BOOL success);

@interface JLSVGAQueueManager : NSObject

@property (nonatomic, weak) SVGAPlayer *player;
@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign, readonly) NSInteger pendingCount;

- (instancetype)initWithPlayer:(SVGAPlayer *)player;

    // 添加动画到队列（本地文件）
- (void)enqueueAnimationWithName:(NSString *)name
                           loops:(NSInteger)loops
                      completion:(nullable SVGAAnimationCompletion)completion;

    // 添加动画到队列（网络 URL）
- (void)enqueueAnimationWithURL:(NSURL *)url
                          loops:(NSInteger)loops
                     completion:(nullable SVGAAnimationCompletion)completion;

    // 播放控制
- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;

    // 队列管理
- (void)clearQueue;
- (void)skipCurrent;

@end

NS_ASSUME_NONNULL_END

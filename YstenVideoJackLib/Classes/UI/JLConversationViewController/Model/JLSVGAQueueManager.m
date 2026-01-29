//
//  JLSVGAQueueManager.m
//  LJChatSDK
//
//  Created by percent on 2026/1/13.
//

#import "JLSVGAQueueManager.h"
#import "SVGAParser.h"

@interface JLSVGAQueueManager () <SVGAPlayerDelegate>

@property (nonatomic, strong) SVGAParser *parser;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *animationQueue;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, copy, nullable) SVGAAnimationCompletion currentCompletion;
@property (nonatomic, strong, nullable) NSDictionary *currentAnimation;

@end

@implementation JLSVGAQueueManager

- (instancetype)initWithPlayer:(SVGAPlayer *)player {
    self = [super init];
    if (self) {
        _player = player;
        _player.delegate = self;
        _player.loops = 1;
        _parser = [[SVGAParser alloc] init];
        _queue = dispatch_queue_create("com.svga.queue", DISPATCH_QUEUE_SERIAL);
        _semaphore = dispatch_semaphore_create(0);
        _animationQueue = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public Methods

- (void)enqueueAnimationWithName:(NSString *)name loops:(NSInteger)loops completion:(SVGAAnimationCompletion)completion {
    if (!name) return;
    
    NSDictionary *animationInfo = @{
        @"type": @"local",
        @"name": name,
        @"loops": @(loops),
        @"completion": completion ?: ^(BOOL success){}
    };
    
    dispatch_async(_queue, ^{
        [self.animationQueue addObject:animationInfo];
        
        if (!self.isPlaying) {
            [self start];
        }
    });
}

- (void)enqueueAnimationWithURL:(NSURL *)url loops:(NSInteger)loops completion:(SVGAAnimationCompletion)completion {
    if (!url) return;
    
    NSDictionary *animationInfo = @{
        @"type": @"remote",
        @"url": url,
        @"loops": @(loops),
        @"completion": completion ?: ^(BOOL success){}
    };
    
    dispatch_async(_queue, ^{
        [self.animationQueue addObject:animationInfo];
        
        if (!self.isPlaying) {
            [self start];
        }
    });
}

- (void)start {
    dispatch_async(_queue, ^{
        self.isPlaying = YES;
        [self playNextAnimation];
    });
}

- (void)pause {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.player pauseAnimation];
    });
}

- (void)resume {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.player startAnimation];
    });
}

- (void)stop {
    dispatch_async(_queue, ^{
        [self.animationQueue removeAllObjects];
        self.isPlaying = NO;
        self.currentAnimation = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.player stopAnimation];
        });
    });
}

- (void)clearQueue {
    dispatch_async(_queue, ^{
        [self.animationQueue removeAllObjects];
    });
}

- (void)skipCurrent {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.player stopAnimation];
    });
}

- (NSInteger)pendingCount {
    __block NSInteger count = 0;
    dispatch_sync(_queue, ^{
        count = self.animationQueue.count;
    });
    return count;
}

#pragma mark - Private Methods

- (void)playNextAnimation {
    dispatch_async(_queue, ^{
        if (self.animationQueue.count == 0) {
            self.isPlaying = NO;
            return;
        }
        
        self.currentAnimation = [self.animationQueue firstObject];
        [self.animationQueue removeObjectAtIndex:0];
        
        NSString *type = self.currentAnimation[@"type"];
        NSInteger loops = [self.currentAnimation[@"loops"] integerValue];
        self.currentCompletion = self.currentAnimation[@"completion"];
        
        if ([type isEqualToString:@"local"]) {
            [self loadLocalAnimation:self.currentAnimation[@"name"] loops:loops];
        } else if ([type isEqualToString:@"remote"]) {
            [self loadRemoteAnimation:self.currentAnimation[@"url"] loops:loops];
        }
    });
}

- (void)loadLocalAnimation:(NSString *)name loops:(NSInteger)loops {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"svga"];
    if (!filePath) {
        [self animationCompleted:NO];
        return;
    }
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    __weak typeof(self) weakSelf = self;
    [self.parser parseWithURL:fileURL completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (videoItem) {
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.player.videoItem = videoItem;
                strongSelf.player.loops = loops;
                [strongSelf.player startAnimation];
            });
        } else {
            [strongSelf animationCompleted:NO];
        }
    } failureBlock:^(NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf animationCompleted:NO];
    }];
}

- (void)loadRemoteAnimation:(NSURL *)url loops:(NSInteger)loops {
    __weak typeof(self) weakSelf = self;
    [self.parser parseWithURL:url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (videoItem) {
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.player.videoItem = videoItem;
                strongSelf.player.loops = loops;
                [strongSelf.player startAnimation];
            });
        } else {
            [strongSelf animationCompleted:NO];
        }
    } failureBlock:^(NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf animationCompleted:NO];
    }];
}

- (void)animationCompleted:(BOOL)success {
    dispatch_async(_queue, ^{
        if (self.currentCompletion) {
            self.currentCompletion(success);
            self.currentCompletion = nil;
        }
        
        self.currentAnimation = nil;
        [self playNextAnimation];
    });
}

#pragma mark - SVGAPlayerDelegate

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    
    [self animationCompleted:YES];
}






@end


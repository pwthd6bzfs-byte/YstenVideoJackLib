//
//  VideoCacheManager.h
//  LJChatSDK
//
//  Created by percent on 2026/1/22.
//

    // PlayerManager.h
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface PlayerManager : NSObject

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, copy) NSString *currentVideoURL;

+ (instancetype)sharedManager;
- (void)playVideoWithURL:(NSString *)urlString inView:(UIView *)containerView;
- (void)pause;
- (void)resume;

@end
NS_ASSUME_NONNULL_END

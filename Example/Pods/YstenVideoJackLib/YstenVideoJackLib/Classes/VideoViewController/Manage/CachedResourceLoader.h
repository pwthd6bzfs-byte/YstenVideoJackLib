//
//  AVAssetResourceLoader.h
//  LJChatSDK
//
//  Created by percent on 2026/1/23.
//

    // CachedResourceLoader.h
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface CachedResourceLoader : NSObject <AVAssetResourceLoaderDelegate>

@property (nonatomic, strong) NSString *cacheDirectory;
@property (nonatomic, strong) NSMutableDictionary *pendingRequests;

- (instancetype)initWithURL:(NSURL *)url;

@end
NS_ASSUME_NONNULL_END

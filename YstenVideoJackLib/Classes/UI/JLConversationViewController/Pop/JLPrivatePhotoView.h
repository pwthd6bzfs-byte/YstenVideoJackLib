//
//  JLPrivatePhotoView.h
//  LJChatSDK
//
//  Created by percent on 2026/1/27.
//

#import <UIKit/UIKit.h>
#import "JLCustomMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLPrivatePhotoView : UIButton

- (instancetype)initWithModel:(JLMediaPrivateMessage *)model;

- (void)show;

- (void)hide;


@end

NS_ASSUME_NONNULL_END

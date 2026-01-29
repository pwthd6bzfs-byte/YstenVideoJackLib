//
//  JLGiftListView.h
//  LJChatSDK
//
//  Created by percent on 2026/1/12.
//

#import <UIKit/UIKit.h>
#import "JLGiftListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLGiftListView : UIButton

- (instancetype)initWithModel:(JLGiftListModel *)model returnModel:(void(^)(JLGiftModel *model,NSString *count))block;

- (void)show;

- (void)hide;


@end


NS_ASSUME_NONNULL_END


@interface JLGiftCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath * _Nonnull indexPath;

@property (nonatomic, strong) JLGiftModel * _Nullable model;

@end



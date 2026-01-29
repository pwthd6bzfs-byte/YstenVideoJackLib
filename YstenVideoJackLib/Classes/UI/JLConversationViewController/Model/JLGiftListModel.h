//
//  JLGiftModel.h
//  Pods
//
//  Created by percent on 2026/1/12.
//

#import <UIKit/UIKit.h>
#import "NSObject+YYModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JLGiftModel : NSObject

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *giftName;
//@property (nonatomic,strong) NSString *giftPrice;
@property (nonatomic,assign) NSInteger coin;
@property (nonatomic,strong) NSString *giftSvgaUrl;
@property (nonatomic,strong) NSString *giftIcon;
@property (nonatomic,strong) NSString *giftCode;
@property (nonatomic,strong) NSIndexPath *indexPath;


@end

@interface JLGiftListModel : NSObject

@property (nonatomic,strong) NSString *giftTypeId;
@property (nonatomic,strong) NSString *giftTypeName;
@property (nonatomic,copy) NSArray<JLGiftModel *> *giftsList;
@end




NS_ASSUME_NONNULL_END

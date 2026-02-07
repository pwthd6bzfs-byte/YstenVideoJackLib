//
//  JLDeviceOrderMessageCel.m
//  YstenVideoJackLib
//
//  Created by percent on 2026/2/7.
//

#import "JLDeviceOrderMessageCell.h"

@implementation JLDeviceOrderMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self initialize];
    }
    return self;
}



+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight{
    return CGSizeMake(0, 0);
}

@end

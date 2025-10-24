//
//  TTSendGiftItemCell.h
//  TTSendGiftView
//
//  Created by Macx on 2019/4/25.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSendGiftView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTSendGiftItemCell : UICollectionViewCell
- (void)configCellBySelectedType:(SelectGiftType)selectedType data:(id)data;
@end

NS_ASSUME_NONNULL_END

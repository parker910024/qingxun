//
//  TTSendGiftAvatarCell.h
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GiftSendAllMicroAvatarInfo;
@interface TTSendGiftAvatarCell : UICollectionViewCell
- (void)configModle:(GiftSendAllMicroAvatarInfo *)model isAllMicSend:(BOOL)isAllMicSend;
@end

NS_ASSUME_NONNULL_END

//
//  TTGoddessChatContentCell.h
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//  大厅热聊内容 - 头像+聊天内容

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//头像大小
extern CGFloat const TTGoddessChatContentCellAvatarSize;
//头像和文本间距
extern CGFloat const TTGoddessChatContentCellInterval;
//文本最大长度
extern CGFloat const TTGoddessChatContentCellLabelMaxWidth;

@class NIMMessageModel;

@interface TTGoddessChatContentCell : UICollectionViewCell
@property (nonatomic, strong) NSArray<NIMMessageModel *> *modelArray;
@end

NS_ASSUME_NONNULL_END

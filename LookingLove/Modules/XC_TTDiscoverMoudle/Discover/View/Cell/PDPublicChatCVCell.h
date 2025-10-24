//
//  PDPublicChatCVCell.h
//  TuTu
//
//  Created by lvjunhang on 2018/12/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  发现 - 公聊大厅

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DidSelectRowBlock)(void);
extern CGFloat const PDPublicChatCVCellTopMargin;//顶部边距
extern CGFloat const PDPublicChatCVCellBottomMargin;//底部边距
extern CGFloat const PDPublicChatCVCellRows;//行数
extern CGFloat const PDPublicChatCVCellTableViewCellHeight;//cell 高度
extern CGFloat const PDPublicChatCVCellTableHeaderHeight;//cell header 高度

@class NIMMessageModel;
@class PDPublicChatCVCell;
@class LLPublicHeadView;
@protocol PDPublicChatCVCellDelegate <NSObject>

- (void)didSelectTableViewRowWith:(PDPublicChatCVCell *)cell;

@end

@interface PDPublicChatCVCell : UICollectionViewCell
@property (nonatomic, strong) NSMutableArray<NIMMessageModel *> *dataModelArray;
@property (nonatomic, copy) NSString *ATmeName;//@wo name

@property (nonatomic, assign) id<PDPublicChatCVCellDelegate> delegate;

@property (nonatomic, assign) BOOL discoverType;

@end

NS_ASSUME_NONNULL_END

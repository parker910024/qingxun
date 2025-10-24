//
//  TTGuildAddMemberSheetView.h
//  TTPlay
//
//  Created by lee on 2019/2/21.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TTSheetViewClickType) {
    TTSheetViewClickTypeTuTu = 0,
    TTSheetViewClickTypeWX = 1,
    TTSheetViewClickTypeQQ = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface TTGuildAddMemberSheetCell : UICollectionViewCell

@end

@protocol TTGuildAddMemberSheetViewDelegate <NSObject>

/**
 点击事件

 @param indexType 点击的 item 类型
 */
- (void)didClickSheetViewItemAction:(TTSheetViewClickType)indexType;

/** 点击取消事件 */
- (void)didClickCancelAction;

@end

@interface TTGuildAddMemberSheetView : UIView

@property (nonatomic, weak) id<TTGuildAddMemberSheetViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

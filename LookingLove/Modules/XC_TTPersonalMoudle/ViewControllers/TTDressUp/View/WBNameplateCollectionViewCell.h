//
//  WBNameplateCollectionViewCell.h
//  WanBan
//
//  Created by ShenJun_Mac on 2020/9/4.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBUserNameplate.h"

NS_ASSUME_NONNULL_BEGIN


@protocol WBNameplateCollectionViewCellDelegate <NSObject>

- (void)onMakeButtonClicked:(WBUserNameplate *)model;

@end
@interface WBNameplateCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) WBUserNameplate *model;
/**
 代理
 */
@property(nonatomic, weak) id<WBNameplateCollectionViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

//
//  PDPublicChatSectionHeaderView.h
//  TuTu
//
//  Created by lvjunhang on 2018/12/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickActionHandle)(void);

@interface PDPublicChatSectionHeaderView : UICollectionReusableView
@property (nonatomic, copy) ClickActionHandle clickHandle;
@end

NS_ASSUME_NONNULL_END

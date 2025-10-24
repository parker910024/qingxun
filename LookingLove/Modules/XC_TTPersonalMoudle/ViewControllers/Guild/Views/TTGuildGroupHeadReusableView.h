//
//  TTGuildGroupHeadReusableView.h
//  TuTu
//
//  Created by lee on 2019/1/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kGuildGroupChatHeadConst = @"kGuildGroupChatHeadConst";

@protocol TTGuildGroupHeadReusableViewDelegate <NSObject>

- (void)onClickCreatGroupChatBtnHandler:(UIButton *)btn;

@end


@interface TTGuildGroupHeadReusableView : UICollectionReusableView
@property (nonatomic, weak) id<TTGuildGroupHeadReusableViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIButton *creatGroupChatBtn;
@end

NS_ASSUME_NONNULL_END

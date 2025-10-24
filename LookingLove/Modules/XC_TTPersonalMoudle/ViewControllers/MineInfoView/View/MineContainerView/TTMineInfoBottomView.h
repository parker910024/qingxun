//
//  TTMineInfoBottomView.h
//  TuTu
//
//  Created by lee on 2018/11/1.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TTMineInfoBtnClickHandler)(UIButton *btn);

@interface TTMineInfoBottomView : UIView

@property (nonatomic, copy) TTMineInfoBtnClickHandler btnClickHandler;
@property (nonatomic, assign, getter=isAttentioned) BOOL attentioned;

@end

NS_ASSUME_NONNULL_END

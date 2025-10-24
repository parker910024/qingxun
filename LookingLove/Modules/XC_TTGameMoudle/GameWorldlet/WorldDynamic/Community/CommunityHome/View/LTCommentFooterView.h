//
//  LTCommentFooterView.h
//  UKiss
//
//  Created by apple on 2018/12/10.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTCommentFooterViewDelegate <NSObject>

- (void)historyButtonClick;

@end

@interface LTCommentFooterView : UIView

@property (nonatomic, weak) id<LTCommentFooterViewDelegate> delegate;

@property (nonatomic, strong) UIButton * historyButton;
@property (nonatomic, strong) UIView * lineView;
@end

//
//  TTLittleWorldEditTopicView.h
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/1.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTLittleWorldEditTopicView : UIView

/** 编辑的按钮*/
@property (nonatomic,strong, readonly) UIButton *editButton;
/** 话题的标题*/
@property (nonatomic,strong) UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END

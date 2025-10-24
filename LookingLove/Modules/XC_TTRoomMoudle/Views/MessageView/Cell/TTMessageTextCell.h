//
//  TTMessageTextCell.h
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTMessageCell.h"
#import <YYText.h>

@interface TTMessageTextCell : TTMessageCell

//文字富文本显示
@property (strong, nonatomic) YYLabel *messageLabel;
//文字背景
@property (strong, nonatomic) UIView *labelContentView;
//cell气泡
@property (strong, nonatomic) UIImageView *chatBubleImageView;

@end

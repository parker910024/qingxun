//
//  TTMessageFaceCell.h
//  TuTu
//
//  Created by KevinWang on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText.h>
#import "TTMessageCell.h"

@interface TTMessageFaceCell : TTMessageCell

@property (strong, nonatomic) YYLabel *messageLabel;
@property (strong, nonatomic) UIView *messageBgView;
@property (strong, nonatomic) UIImageView *chatBubleImageView;

@end

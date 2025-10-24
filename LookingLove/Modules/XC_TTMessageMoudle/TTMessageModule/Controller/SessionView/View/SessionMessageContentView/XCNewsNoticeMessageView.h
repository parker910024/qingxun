//
//  XCNewsNoticeMessageView.h
//  XChat
//
//  Created by 卫明何 on 2017/10/16.
//  Copyright © 2017年 XC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCNewsNoticeMessageView : UIView
@property (strong, nonatomic)  UILabel *title;
@property (strong, nonatomic)  UIImageView *picImageView;
@property (strong, nonatomic)  UILabel *contentLabel;
@property (strong, nonatomic) UIView * sepLineView;
@property (strong, nonatomic) UIImageView * arrowImageView;
@property (strong, nonatomic) UILabel * clickCheckLabel;
@end

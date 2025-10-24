//
//  TTWelcomeNobleView.h
//  TuTu
//
//  Created by KevinWang on 2018/11/26.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTWelcomeNobleView : UIView

@property (nonatomic, strong) UIImageView *welcomeBgView;
@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, copy) NSAttributedString *title;

@end

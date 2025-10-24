//
//  TTHomeRoomSelectView.h
//  TuTu
//
//  Created by new on 2019/1/3.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTHomeRoomSelectViewDelegate <NSObject>

-(void)ordinaryButtonActionResponse;
-(void)companyButtonActionResponse;

/**
 点击蒙层背景
 */
- (void)touchMaskBackground;

@end

NS_ASSUME_NONNULL_BEGIN

@interface TTHomeRoomSelectView : UIView

@property (nonatomic, strong) UIView *roomSelectBackView;
@property (nonatomic, strong) UIButton *ordinaryButton; // 普通
@property (nonatomic, strong) UIButton *companyButton; // 陪伴

@property (nonatomic, strong) UILabel *ordinaryLabel;
@property (nonatomic, strong) UILabel *companyLabel;

@property (nonatomic, strong) UIButton *roomShowsButton; // 房间说明
@property (nonatomic, strong) UIView *roomShowsView;
@property (nonatomic, strong) UILabel *roomTitleLabel; 
@property (nonatomic, strong) UILabel *roomOrdinaryTitleLabel;
@property (nonatomic, strong) UILabel *roomOrdinaryContentLabel;
@property (nonatomic, strong) UILabel *roomCompanyTitleLabel;
@property (nonatomic, strong) UILabel *roomCompanyContentLabel;
@property (nonatomic, strong) UIButton *roomShowsCloseButton;
@property (nonatomic, weak) id<TTHomeRoomSelectViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

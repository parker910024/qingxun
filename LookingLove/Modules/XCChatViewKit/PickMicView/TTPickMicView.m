//
//  TTPickMicView.m
//  WanBan
//
//  Created by lvjunhang on 2020/10/13.
//  Copyright © 2020 WUJIE INTERACTIVE. All rights reserved.
//  选择麦位

#import "TTPickMicView.h"
#import "TTPickMicContentView.h"
#import "TTUserCardUserInfoContainerView.h"

#import "UserCore.h"

#import "UIView+NTES.h"
#import "XCCurrentVCStackManager.h"

#import "XCMacros.h"
#import "TTPopup.h"
#import "TTStatisticsService.h"

@interface TTPickMicView()
<
TTUserCardUserInfoContainerViewDelegate
>

@property (nonatomic, assign) UserID uid;
@property (nonatomic, assign) RoomType roomType;

@property (nonatomic, strong) TTUserCardUserInfoContainerView *headerView;
@property (nonatomic, strong) TTPickMicContentView *contentView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation TTPickMicView

- (void)dealloc {
    
}

- (instancetype)initWithRoomType:(RoomType)roomType uid:(UserID)uid {
    if (self = [super init]) {
        self.uid = uid;
        self.roomType = roomType;
        
        [self layoutView];
    }
    return self;
}

- (void)layoutView {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.headerView];
    [self.containerView addSubview:self.contentView];
    [self addSubview:self.closeButton];
    
    CGFloat width = KScreenWidth - 30 * 2;
    CGFloat headerHeight = 122;
    CGFloat contentHeight = 186;
    
    if (self.roomType == RoomType_Love || self.roomType == RoomType_Game) {
        contentHeight = 248;
    } else if (self.roomType == RoomType_CP) {
        contentHeight = 25 + 44 + 44;
    }
    
    CGFloat closeHeight = 40;
    CGFloat containerViewHeight = headerHeight + contentHeight;
    CGFloat closeMargin = 25;
    CGFloat height = containerViewHeight + closeMargin + closeHeight;
    
    self.frame = CGRectMake(0, 0, width, height);
    self.containerView.frame = CGRectMake(0, 0, width, containerViewHeight);
    self.headerView.frame = CGRectMake(0, 0, width, headerHeight);
    self.contentView.frame = CGRectMake(0, self.headerView.bottom, width, contentHeight);
    self.closeButton.frame = CGRectMake(0, 0, closeHeight, closeHeight);
    self.closeButton.centerX = self.centerX;
    self.closeButton.top = containerViewHeight + closeMargin;
}

- (void)onClickCloseButton:(UIButton *)sender {
    [TTPopup dismiss];
}

#pragma mark - setter & getter
- (TTUserCardUserInfoContainerView *)headerView {
    if (!_headerView) {
        _headerView = [[TTUserCardUserInfoContainerView alloc] initWithFrame:CGRectZero uid:self.uid];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (TTPickMicContentView *)contentView {
    if (!_contentView) {
        _contentView = [[TTPickMicContentView alloc] initWithRoomType:self.roomType uid:self.uid];
    }
    return _contentView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setBackgroundImage:[UIImage imageNamed:@"userCard_close_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(onClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 20.f;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

@end

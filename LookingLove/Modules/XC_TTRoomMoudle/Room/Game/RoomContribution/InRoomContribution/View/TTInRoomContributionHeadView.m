//
//  XC_MSRoomContributionHeaderView.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/10/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTInRoomContributionHeadView.h"
#import "TTInRoomContributionHeaderSegementView.h"
#import "TTRoomUIClient.h"
#import <Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTInRoomContributionHeadView()

@property (nonatomic, strong) UIImageView *bgImageView;

//@"贡献榜", @"魅力榜"
@property (nonatomic, strong) TTInRoomContributionHeaderSegementView *typeSegmentView;

@property (nonatomic, strong) UIView *segmentContainerView;
@property (nonatomic, strong) UIView *lineContentView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *daysBtn;//日榜
@property (nonatomic, strong) UIButton *weekBtn;//周榜

@property (nonatomic, assign) RankType rankType;
@property (nonatomic, assign) RankDataType dataType;

@end

@implementation TTInRoomContributionHeadView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self initSubViews];
        [self makeConstraints];
    }
    return self;
}

#pragma mark - action
- (void)dataButtonClick:(UIButton *)dataButton{
    self.dataType = dataButton.tag;
    if (self.headViewSelectDataBlock) {
        self.headViewSelectDataBlock(self.rankType, dataButton.tag);
    }
    [self actionBtnStateChange:dataButton];
}

#pragma mark - private method
- (void)initSubViews {
    [self addSubview:self.bgImageView];
    [self addSubview:self.typeSegmentView];
    
    [self addSubview:self.segmentContainerView];
    [self.segmentContainerView addSubview:self.daysBtn];
    [self.segmentContainerView addSubview:self.weekBtn];
    
    [self addSubview:self.lineContentView];
    [self.lineContentView addSubview:self.lineView];
}

- (void)makeConstraints {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.typeSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(52);
        make.left.right.mas_equalTo(self).inset(15);
        make.height.mas_equalTo(34);
    }];

    [self.segmentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeSegmentView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
    [self.daysBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.segmentContainerView).offset(20);
        make.top.bottom.equalTo(self.segmentContainerView);
    }];
    [self.weekBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.daysBtn.mas_right).offset(16);
        make.top.bottom.equalTo(self.daysBtn);
    }];
    
    [self.lineContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.mas_equalTo(self.daysBtn).offset(6+4);
        make.height.mas_equalTo(4);
        make.left.right.mas_equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(4);
        make.width.mas_equalTo(9);
        make.centerY.mas_equalTo(self.lineContentView);
        make.centerX.mas_equalTo(self.daysBtn);
    }];
}

- (void)actionBtnStateChange:(UIButton *)btn {
    self.weekBtn.selected = self.daysBtn.selected = NO;
    btn.selected = YES;
    [self lineMoveTo:btn];
}

- (void)lineMoveTo:(UIButton *)btn {
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(4);
        make.width.mas_equalTo(7);
        make.bottom.mas_equalTo(self.lineContentView);
        make.centerX.mas_equalTo(btn);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.lineContentView layoutIfNeeded];
    }];
}

- (UIButton *)buttonWithTitle:(NSString *)title tag:(RankDataType)dataType{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(dataButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xfffffff) forState:UIControlStateSelected];
    [button setTitleColor:UIColorRGBAlpha(0xffffff, 0.5) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.tag = dataType;
    return button;
}

#pragma mark - Getter && Setter
- (UIView *)segmentContainerView {
    if (!_segmentContainerView) {
        _segmentContainerView = [[UIView alloc] init];
    }
    return _segmentContainerView;
}

- (UIView *)lineContentView {
    if (!_lineContentView) {
        _lineContentView = [[UIView alloc] init];
    }
    return _lineContentView;
}

- (UIView *)lineView {
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xffffff);
        _lineView.layer.cornerRadius = 2;
        _lineView.layer.masksToBounds = YES;
    }
    return _lineView;
}

- (UIButton *)daysBtn {
    if (!_daysBtn) {
        _daysBtn = [self buttonWithTitle:@"日榜" tag:RankDataType_Day];
    }
    return _daysBtn;
}
- (UIButton *)weekBtn {
    if (!_weekBtn) {
        _weekBtn = [self buttonWithTitle:@"周榜" tag:RankDataType_Week];
    }
    return _weekBtn;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_contribution_bg_inRoom_top"]];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

- (TTInRoomContributionHeaderSegementView *)typeSegmentView {
    if (!_typeSegmentView) {
        TTInRoomContributionHeaderSegementView *view = [[TTInRoomContributionHeaderSegementView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth-15*2, 34) items:@[@"贡献榜", @"魅力榜"]];
        view.layer.cornerRadius = 17;
        view.layer.masksToBounds = YES;
        @weakify(self)
        view.segmentControlSelectedItem = ^(RankType rankType) {
            @strongify(self)
            self.rankType = rankType;
            if (self.headViewSelectedRankTypeBlock) {
                self.headViewSelectedRankTypeBlock(rankType, self.dataType);
            }
        };
        
        _typeSegmentView = view;
    }
    return _typeSegmentView;
}

@end

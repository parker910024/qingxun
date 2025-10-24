//
//  TTMasterHeaderView.m
//  TTPlay
//
//  Created by Macx on 2019/1/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMasterHeaderView.h"

#import "TTMasterRankingView.h"
#import "TTMasterAdvertisementView.h"

#import "TTMasterHeaderModel.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import <Masonry/Masonry.h>

@interface TTMasterHeaderView ()
/** TTMasterAdvertisementView */
@property (nonatomic, strong) TTMasterAdvertisementView *advView;
/** 背景图 */
@property (nonatomic, strong) UIImageView *bgImageView;
/** 去收徒 */
@property (nonatomic, strong) UILabel *acceptpPrenticeLabel;
/** arrowImageView */
@property (nonatomic, strong) UIImageView *arrowImageView;
/** 调戏小哥哥  一起赢金币 */
@property (nonatomic, strong) UILabel *tipLabel;
/** 每天最多三个徒弟哦 ~ */
@property (nonatomic, strong) UILabel *tip2Label;
/** ranking */
@property (nonatomic, strong) TTMasterRankingView *rankingView;
/** 灰色的分割区域 */
@property (nonatomic, strong) UIView *separateView;
@end

@implementation TTMasterHeaderView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didTapBgImageView:(UITapGestureRecognizer *)tap {
    
//    if (!self.headerModel.can) {
//        return;
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(masterHeaderView:didClickAcceptpPrenticeView:)]) {
        [self.delegate masterHeaderView:self didClickAcceptpPrenticeView:tap.view];
    }
}

- (void)didTapRankingView:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(masterHeaderView:didClickRankingView:)]) {
        [self.delegate masterHeaderView:self didClickRankingView:tap.view];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.advView];
    [self addSubview:self.bgImageView];
    
    [self.bgImageView addSubview:self.acceptpPrenticeLabel];
    [self.bgImageView addSubview:self.arrowImageView];
    [self.bgImageView addSubview:self.tipLabel];
    [self.bgImageView addSubview:self.tip2Label];
    
    [self addSubview:self.rankingView];
    [self addSubview:self.separateView];
    
    self.advView.hidden = YES;
    
    self.bgImageView.userInteractionEnabled = YES;
    [self.bgImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBgImageView:)]];
    self.rankingView.userInteractionEnabled = YES;
    [self.rankingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapRankingView:)]];
}

- (void)initConstrations {
    [self.advView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(22);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(125);
        make.top.mas_equalTo(16);
    }];
    
    [self.acceptpPrenticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(26);
        make.top.mas_equalTo(22);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.acceptpPrenticeLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.acceptpPrenticeLabel);
        make.width.height.mas_equalTo(22);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.acceptpPrenticeLabel);
        make.top.mas_equalTo(58);
    }];
    
    [self.tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.acceptpPrenticeLabel);
        make.top.mas_equalTo(82);
        make.width.mas_equalTo(104);
        make.height.mas_equalTo(20);
    }];
    
    [self.rankingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(5);;
        make.height.mas_equalTo(22 + 30);
    }];
    
    [self.separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.rankingView.mas_bottom);;
        make.height.mas_equalTo(10);
    }];
}

#pragma mark - getters and setters
- (void)setAdvModels:(NSArray *)advModels {
    _advModels = advModels;
    
    if (advModels.count == 0) {
        self.advView.hidden = YES;
        [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(125);
            make.top.mas_equalTo(16);
        }];
    } else {
        self.advView.hidden = NO;
        [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(125);
            make.top.mas_equalTo(38);
        }];
        self.advView.models = advModels;
    }
}

- (void)setHeaderModel:(TTMasterHeaderModel *)headerModel {
    _headerModel = headerModel;
    
    self.acceptpPrenticeLabel.text = headerModel.title;
    self.tipLabel.text = headerModel.content;
    self.tip2Label.text = headerModel.tips;
}

- (void)setRankingList:(NSArray *)rankingList {
    _rankingList = rankingList;
    
    self.rankingView.rankingList = rankingList;
}

- (TTMasterAdvertisementView *)advView {
    if (!_advView) {
        _advView = [[TTMasterAdvertisementView alloc] init];
    }
    return _advView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"discover_master_bg"];
    }
    return _bgImageView;
}

- (UILabel *)acceptpPrenticeLabel {
    if (!_acceptpPrenticeLabel) {
        _acceptpPrenticeLabel = [[UILabel alloc] init];
        _acceptpPrenticeLabel.text = @"---";
        _acceptpPrenticeLabel.textColor = [UIColor whiteColor];
        _acceptpPrenticeLabel.font = [UIFont boldSystemFontOfSize:22];
    }
    return _acceptpPrenticeLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"----"; // 调戏小姐姐，一起赢金币
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont systemFontOfSize:14];
    }
    return _tipLabel;
}

- (UILabel *)tip2Label {
    if (!_tip2Label) {
        _tip2Label = [[UILabel alloc] init];
        _tip2Label.text = @"----";
        _tip2Label.textColor = RGBACOLOR(255, 255, 255, 0.8);
        _tip2Label.font = [UIFont systemFontOfSize:11];
        _tip2Label.backgroundColor = RGBACOLOR(255, 255, 255, 0.1);
        _tip2Label.layer.cornerRadius = 10;
        _tip2Label.layer.masksToBounds = YES;
        _tip2Label.textAlignment = NSTextAlignmentCenter;
    }
    return _tip2Label;
}

- (TTMasterRankingView *)rankingView {
    if (!_rankingView) {
        _rankingView = [[TTMasterRankingView alloc] init];
    }
    return _rankingView;
}

- (UIView *)separateView {
    if (!_separateView) {
        _separateView = [[UIView alloc] init];
        _separateView.backgroundColor = RGBCOLOR(244, 244, 244);
    }
    return _separateView;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"discover_master_bg_arrow"];
    }
    return _arrowImageView;
}

@end

//
//  TTHalfhourContributionHeadView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/13.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTHalfhourContributionHeadView.h"

//t
#import "XCTheme.h"
#import "Masonry.h"
//cate
#import "UIImage+Utils.h"
#import "NSString+SpecialClean.h"
#import "UIImageView+QiNiu.h"

#import "RankData.h"

@interface TTHalfhourContributionHeadView()

@property (nonatomic, strong) UIImageView *bgImageView;//背景图片

@property (nonatomic, strong) UIView *dataContianerView;//容器

@property (nonatomic, strong) UIImageView *avatarImageView;//头像
@property (nonatomic, strong) UILabel *nameLabel;//房间名称
@property (nonatomic, strong) UILabel *uidLabel;//用户 ID
@property (nonatomic, strong) UILabel *notRankLabel;//未上榜
@property (nonatomic, strong) UIImageView *rankImageView;//当前名次

///上榜提示
@property (nonatomic, strong) UILabel *numberOneTipsLabel;//当前 NO.1
@property (nonatomic, strong) UILabel *farBeforeTipsLabel;//距离上一名
@property (nonatomic, strong) UILabel *accountTipsLabel;//流水数额

@end

@implementation TTHalfhourContributionHeadView

- (instancetype)init {
    if (self = [super init]) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    [self addSubview:self.bgImageView];
    [self addSubview:self.dataContianerView];
    
    [self.dataContianerView addSubview:self.notRankLabel];
    [self.dataContianerView addSubview:self.rankImageView];
    [self.dataContianerView addSubview:self.avatarImageView];
    [self.dataContianerView addSubview:self.nameLabel];
    [self.dataContianerView addSubview:self.uidLabel];
    [self.dataContianerView addSubview:self.numberOneTipsLabel];
    [self.dataContianerView addSubview:self.farBeforeTipsLabel];
    [self.dataContianerView addSubview:self.accountTipsLabel];

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDataContainerViewAction)];
    [self.dataContianerView addGestureRecognizer:tapGR];
    
    [self makeConstriants];
}

- (void)makeConstriants {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];

    [self.dataContianerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(52);
        make.left.right.mas_equalTo(self).inset(15);
        make.height.mas_equalTo(56);
    }];
    
    [self.notRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((50-20)/2.0);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.width.height.mas_equalTo(40);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarImageView).offset(5);
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(16);
        make.right.mas_lessThanOrEqualTo(self.numberOneTipsLabel.mas_left).offset(-20);
        make.right.mas_lessThanOrEqualTo(self.accountTipsLabel.mas_left).offset(-20);
    }];
    
    [self.uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_baseline).offset(8);
        make.left.mas_equalTo(self.nameLabel);
        make.right.mas_lessThanOrEqualTo(self.numberOneTipsLabel.mas_left).offset(-20);
        make.right.mas_lessThanOrEqualTo(self.farBeforeTipsLabel.mas_left).offset(-20);
    }];
    
    [self.numberOneTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.accountTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.centerY.mas_equalTo(self.nameLabel);
    }];
    
    [self.farBeforeTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.centerY.mas_equalTo(self.uidLabel);
    }];
}

///设置排名
- (void)setupRankStatus:(int)rank {
    //rank=0 是未上榜，rank > 20 也是未上榜
    BOOL isOnRank = rank != 0 && rank <= 20;
    self.notRankLabel.hidden = isOnRank;
    self.rankImageView.hidden = !isOnRank;
    
    if (isOnRank) {
        NSString *rankImage = [NSString stringWithFormat:@"room_contribution_rank_%d", rank];
        self.rankImageView.image = [UIImage imageNamed:rankImage];
    }
}

///设置上榜提示
- (void)setupOnRankTips {
    if (self.myRankData == nil) {
        self.numberOneTipsLabel.text = nil;
        return;
    }
    
    if (self.myRankData.seqNo == 1) {
        self.numberOneTipsLabel.hidden = NO;
        self.farBeforeTipsLabel.hidden = YES;
        self.accountTipsLabel.hidden = YES;
    } else if (self.myRankData.seqNo > 1 && self.myRankData.seqNo < 21) {
        self.numberOneTipsLabel.hidden = YES;
        self.farBeforeTipsLabel.hidden = NO;
        self.accountTipsLabel.hidden = NO;
        
        NSString *totalNum = [self accountCalculate: self.myRankData.totalNum.integerValue];
        self.accountTipsLabel.text = totalNum;
        
        if (self.myRankData.seqNo <= 10) {
            self.farBeforeTipsLabel.text = @"距离上一名";
        } else {
            self.farBeforeTipsLabel.text = @"距离上榜";
        }
        
    } else {
        self.numberOneTipsLabel.hidden = YES;
        self.farBeforeTipsLabel.hidden = YES;
        self.accountTipsLabel.hidden = NO;
        
        NSString *totalNum = [self accountCalculate: self.myRankData.totalNum.integerValue];
        self.accountTipsLabel.text = totalNum;
    }
}

/**
流水显示计算，过万时显示 xx万
 */
- (NSString *)accountCalculate:(NSInteger)totalNum {
    if (totalNum < 10000) {
        return @(totalNum).stringValue;
    }
    
    return [NSString stringWithFormat:@"%.2f万", totalNum/10000.0];
}

- (void)tapDataContainerViewAction {
    if (self.myRankData == nil || self.myRankData.uid <= 0) {
        return;
    }
    
    !self.tapInfoViewBlock ?: self.tapInfoViewBlock(self.myRankData.uid);
}

#pragma mark - Getter && Setter
- (void)setMyRankData:(RankData *)myRankData {
    _myRankData = myRankData;
    
    [self setupRankStatus:myRankData.seqNo];
    [self.avatarImageView qn_setImageImageWithUrl:_myRankData.avatar
                                 placeholderImage:[XCTheme defaultTheme].default_avatar
                                             type:ImageTypeUserIcon];
    self.nameLabel.text = [myRankData.roomTitle cleanSpecialText];
    self.uidLabel.text = [NSString stringWithFormat:@"ID:%@", myRankData.erbanNo];
    [self setupOnRankTips];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"room_contribution_bg_halfhour_top"];
    }
    return _bgImageView;
}

- (UIView *)dataContianerView {
    if (!_dataContianerView) {
        _dataContianerView = [[UIView alloc] init];
        _dataContianerView.backgroundColor = [UIColor whiteColor];
        _dataContianerView.layer.masksToBounds = YES;
        _dataContianerView.layer.cornerRadius = 14;
    }
    return _dataContianerView;
}

- (UILabel *)notRankLabel {
    if (!_notRankLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0xADADAD);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"未上榜";
        label.hidden = YES;
        
        _notRankLabel = label;
    }
    return _notRankLabel;
}

- (UIImageView *)rankImageView {
    if (!_rankImageView) {
        _rankImageView = [[UIImageView alloc] init];
        _rankImageView.hidden = YES;
        _rankImageView.userInteractionEnabled = YES;
    }
    return _rankImageView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 40/2;
        _avatarImageView.userInteractionEnabled = YES;
    }
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [XCTheme getTTMainTextColor];
        
        _nameLabel = label;
    }
    return _nameLabel;
}

- (UILabel *)uidLabel {
    if (!_uidLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        
        _uidLabel = label;
    }
    return _uidLabel;
}

- (UILabel *)numberOneTipsLabel {
    if (!_numberOneTipsLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.hidden = YES;
        
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        NSString *tips = @"当前 NO.1";
        NSString *no1 = @"NO.1";
        NSRange no1Range = [tips rangeOfString:no1];
        
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:tips];
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:no1Range];
        [attri addAttribute:NSForegroundColorAttributeName value:[XCTheme getSecondaryRedColor] range:no1Range];
        label.attributedText = attri;
        
        _numberOneTipsLabel = label;
    }
    return _numberOneTipsLabel;
}

- (UILabel *)farBeforeTipsLabel {
    if (!_farBeforeTipsLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.textAlignment = NSTextAlignmentRight;
        label.hidden = YES;
        
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        _farBeforeTipsLabel = label;
    }
    return _farBeforeTipsLabel;
}

- (UILabel *)accountTipsLabel {
    if (!_accountTipsLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [XCTheme getSecondaryRedColor];
        label.textAlignment = NSTextAlignmentRight;
        label.hidden = YES;
        
        [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        _accountTipsLabel = label;
    }
    return _accountTipsLabel;
}

@end


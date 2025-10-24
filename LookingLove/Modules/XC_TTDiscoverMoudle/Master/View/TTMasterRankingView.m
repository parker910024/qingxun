//
//  TTMasterRankingView.m
//  TTPlay
//
//  Created by Macx on 2019/1/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMasterRankingView.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import <Masonry/Masonry.h>
#import "UIImageView+QiNiu.h"
#import "UserInfo.h"

@interface TTMasterRankingView ()
/** leftIconImageView */
@property (nonatomic, strong) UIImageView *leftIconImageView;
/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;
/** arrow */
@property (nonatomic, strong) UIImageView *arrowImageView;
/** 头像数组 */
@property (nonatomic, strong) NSMutableArray *avatarArray;
@end

@implementation TTMasterRankingView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response

#pragma mark - private method

- (void)initView {
    [self addSubview:self.leftIconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowImageView];
}

- (void)initConstrations {
    [self.leftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(22);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(43);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(11);
    }];
}

#pragma mark - getters and setters
- (void)setRankingList:(NSArray *)rankingList {
    _rankingList = rankingList;
    
    [self.avatarArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.avatarArray removeAllObjects];
    
    for (int i = 0; i < self.rankingList.count; i++) {
        
        UserInfo *info = self.rankingList[i];
        
        UIImageView *avatar = [[UIImageView alloc] init];
        avatar.layer.cornerRadius = 10;
        avatar.layer.masksToBounds = YES;
        avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
        avatar.layer.borderWidth = 1;
        [self addSubview:avatar];
        [avatar qn_setImageImageWithUrl:info.avatar placeholderImage:[XCTheme defaultTheme].placeholder_image_cycle type:ImageTypeUserIcon];
        
        CGFloat right = 32 + 10 * i;
        [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-right);
            make.centerY.mas_equalTo(self);
            make.width.height.mas_equalTo(20);
        }];
        [self.avatarArray addObject:avatar];
    }
}

- (UIImageView *)leftIconImageView {
    if (!_leftIconImageView) {
        _leftIconImageView = [[UIImageView alloc] init];
        _leftIconImageView.image = [UIImage imageNamed:@"discover_master_ranking"];
    }
    return _leftIconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"名师排行榜";
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"discover_master_ranking_arrow"];
    }
    return _arrowImageView;
}

- (NSMutableArray *)avatarArray {
    if (!_avatarArray) {
        _avatarArray = [NSMutableArray array];
    }
    return _avatarArray;
}

@end

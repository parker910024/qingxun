//
//  TTSendGiftCountCell.m
//  TTSendGiftView
//
//  Created by Macx on 2019/5/6.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftCountCell.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"

@interface TTSendGiftCountCell()

@property (nonatomic, strong) UILabel *normalTitleLabel;
@property (nonatomic, strong) UILabel *countLabel;
/** arrow */
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation TTSendGiftCountCell
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self  initSubViews];
    }
    return self;
}

#pragma mark - puble method
- (void)setCountItem:(TTSendGiftCountItem *)countItem {
    _countItem = countItem;
    
    self.normalTitleLabel.text = countItem.giftNormalTitle;
    self.countLabel.text = countItem.giftCount;
    
    if (countItem.isCustomCount) {
        self.arrowImageView.hidden = NO;
    } else {
        self.arrowImageView.hidden = YES;
    }
}

#pragma mark - private method
- (void)initSubViews {
    
    [self.contentView addSubview:self.normalTitleLabel];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.arrowImageView];
    
    [self.normalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(0);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
        make.left.mas_greaterThanOrEqualTo(self.normalTitleLabel.mas_right).offset(5);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(10);
    }];
}

#pragma mark - Getter && Setter

- (UILabel *)normalTitleLabel {
    if (!_normalTitleLabel) {
        _normalTitleLabel = [[UILabel alloc] init];
        _normalTitleLabel.font = [UIFont systemFontOfSize:13];
        _normalTitleLabel.textColor = [UIColor whiteColor];
    }
    return _normalTitleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:14];
        _countLabel.textColor = [XCTheme getTTMainColor];
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"room_gift_count_arrow"];
    }
    return _arrowImageView;
}
@end

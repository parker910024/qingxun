//
//  TTSendGiftSegmentCell.m
//  TTSendGiftView
//
//  Created by Macx on 2019/4/24.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTSendGiftSegmentCell.h"
//t
#import <Masonry/Masonry.h>
#import "XCTheme.h"
//m
#import "TTSendGiftSegmentItem.h"

@interface TTSendGiftSegmentCell()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TTSendGiftSegmentCell

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        [self initSubViews];
        [self makeConstraints];
    }
    return self;
}

#pragma mark - puble method

#pragma mark - private method
- (void)initSubViews {
    [self.contentView addSubview:self.titleLabel];
}

- (void)makeConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Getter && Setter
- (void)setSegmentItem:(TTSendGiftSegmentItem *)segmentItem {
    _segmentItem = segmentItem;
    self.titleLabel.text = segmentItem.title;
    self.titleLabel.textColor = (segmentItem.isSelected ? [UIColor whiteColor] : RGBACOLOR(255, 255, 255, 0.3));
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end

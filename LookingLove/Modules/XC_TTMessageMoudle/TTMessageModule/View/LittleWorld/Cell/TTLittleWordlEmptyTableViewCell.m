//
//  TTLittleWordlEmptyTableViewCell.m
//  XC_TTMessageMoudle
//
//  Created by fengshuo on 2019/7/1.
//  Copyright © 2019 WJHD. All rights reserved.
//

#import "TTLittleWordlEmptyTableViewCell.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"

@interface TTLittleWordlEmptyTableViewCell ()

/** 显示图片*/
@property (nonatomic,strong) UIImageView *backImageView;
/** 显示文本*/
@property (nonatomic,strong) UILabel *titleLabel;
@end

@implementation TTLittleWordlEmptyTableViewCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - private method
- (void)initView {
    [self.contentView addSubview:self.backImageView];
    [self.contentView addSubview:self.titleLabel];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)initContrations {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(96);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.backImageView.mas_bottom).offset(4);
    }];
}


#pragma mark - setters and getters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"暂无派对";
    }
    return _titleLabel;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = NO;
        _backImageView.image = [UIImage imageNamed:@"common_noData_empty"];
        [_backImageView sizeToFit];
    }
    return _backImageView;
}

@end

//
//  TTGuildGroupMultiLineTextCell.m
//  TuTu
//
//  Created by lvjunhang on 2019/1/9.
//  Copyright © 2019年 YiZhuan. All rights reserved.
//

#import "TTGuildGroupMultiLineTextCell.h"

#import "XCTheme.h"

#import <Masonry/Masonry.h>

@interface TTGuildGroupMultiLineTextCell ()
@end

@implementation TTGuildGroupMultiLineTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.separateLine];

        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 15, 10, 15));
        }];
        
        [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView).inset(15);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UIView *)separateLine {
    if (_separateLine == nil) {
        _separateLine = [[UIView alloc] init];
        _separateLine.backgroundColor = [XCTheme getLineDefaultGrayColor];
    }
    return _separateLine;
}

@end

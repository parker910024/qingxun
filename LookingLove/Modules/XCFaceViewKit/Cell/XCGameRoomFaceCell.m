//
//  XCGameRoomFaceCell.m
//  XChat
//
//  Created by 卫明何 on 2017/9/29.
//  Copyright © 2017年 XC. All rights reserved.
//

#import "XCGameRoomFaceCell.h"

//3rd part
#import <Masonry/Masonry.h>

//theme
#import "XCTheme.h"

@implementation XCGameRoomFaceCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.faceImageView];
    [self.contentView addSubview:self.faceName];
    [self.contentView addSubview:self.nobleTagImageView];
}

- (void)initConstrations {
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.width.height.mas_equalTo(36);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    [self.nobleTagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.faceImageView.mas_top);
        make.trailing.mas_equalTo(self.faceImageView.mas_trailing).offset(20);
        make.width.mas_equalTo(27.5);
        make.height.mas_equalTo(14);
    }];
    [self.faceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.faceImageView.mas_bottom);
        make.centerX.mas_equalTo(self.faceImageView.mas_centerX);
    }];
}

#pragma mark - setter & getter

- (UIImageView *)faceImageView {
    if (!_faceImageView) {
        _faceImageView = [[UIImageView alloc]init];
    }
    return _faceImageView;
}

- (UILabel *)faceName {
    if (!_faceName) {
        _faceName = [[UILabel alloc]init];
        _faceName.font = [UIFont systemFontOfSize:12.f];
        _faceName.textColor = UIColorFromRGB(0xd6d6d6);
        _faceName.textAlignment = NSTextAlignmentCenter;
    }
    return _faceName;
}

- (UIImageView *)nobleTagImageView {
    if (!_nobleTagImageView) {
        _nobleTagImageView = [[UIImageView alloc]init];
    }
    return _nobleTagImageView;
}


@end

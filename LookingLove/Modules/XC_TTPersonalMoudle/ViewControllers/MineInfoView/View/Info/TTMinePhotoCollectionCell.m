//
//  TTMinePhotoCollectionCell.m
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMinePhotoCollectionCell.h"
#import <Masonry/Masonry.h>

@implementation TTMinePhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self.contentView addSubview:self.personalPhotoImagwView];
    [self.personalPhotoImagwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Getter && Setter

- (UIImageView *)personalPhotoImagwView {
    if (!_personalPhotoImagwView) {
        _personalPhotoImagwView = [[UIImageView alloc] init];
        _personalPhotoImagwView.layer.masksToBounds = YES;
        _personalPhotoImagwView.layer.cornerRadius = 5;
        _personalPhotoImagwView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _personalPhotoImagwView;
}

@end

//
//  TTPersonEditAvatarCell.m
//  TuTu
//
//  Created by Macx on 2018/11/6.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPersonEditPhotosCell.h"

#import <Masonry/Masonry.h>

@implementation TTPersonEditPhotosCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.photos];
        [self.photos mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
        [self.contentView setTransform:CGAffineTransformMakeScale(-1, 1)];
    }
    return self;
}

#pragma mark - Getter && Setter

- (UIImageView *)photos {
    if (!_photos) {
        _photos = [[UIImageView alloc] init];
        _photos.layer.masksToBounds = YES;
        _photos.layer.cornerRadius = 5;
    }
    return _photos;
}



@end

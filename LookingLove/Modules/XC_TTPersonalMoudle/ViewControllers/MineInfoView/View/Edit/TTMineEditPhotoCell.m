//
//  TTMineEditPhotoCell.m
//  TuTu
//
//  Created by lee on 2018/10/31.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTMineEditPhotoCell.h"
#import <Masonry/Masonry.h>
@implementation TTMineEditPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.personalPhotoImagwView];
    [self.contentView addSubview:self.deleteBtn];
    [self makaConstiants];
}

- (void)makaConstiants {
    [self.personalPhotoImagwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(21);
        make.top.right.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Event

- (void)didClickedDeleteBtn:(UIButton *)btn {
    if (_delegate && [_delegate respondsToSelector:@selector(deletePhoto:)]) {
        [self.delegate deletePhoto:self.indexPath];
    }
    
}


#pragma mark -  Getter && Setter

- (UIImageView *)personalPhotoImagwView {
    if (!_personalPhotoImagwView) {
        _personalPhotoImagwView = [[UIImageView alloc] init];
        _personalPhotoImagwView.layer.cornerRadius = 5;
        _personalPhotoImagwView.layer.masksToBounds = YES;
        _personalPhotoImagwView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _personalPhotoImagwView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"meInfo_photo_deleteicon"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(didClickedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}


@end

//
//  LLPickPicCollectionViewCell.m
//  XC_TTGameMoudle
//
//  Created by Lee on 2019/11/14.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLPickPicCollectionViewCell.h"
#import "View+MASAdditions.h"
#import "UIButton+EnlargeTouchArea.h"
#import <YYImage/YYImage.h>

@interface LLPickPicCollectionViewCell ()

@property (nonatomic, strong) UIImageView *picTypeIcon; // 图片类型icon (gif)

@end

@implementation LLPickPicCollectionViewCell
#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self initConstraints];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.imageView];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.picTypeIcon];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"littleWorld_postPic_add"]];
}
- (void)initConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.mas_equalTo(self);
    }];

    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.top.mas_equalTo(self).inset(5);
       make.height.width.mas_equalTo(19);
    }];

    [self.picTypeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       make.right.bottom.mas_equalTo(self).inset(4);
       make.width.mas_equalTo(30.5);
       make.height.mas_equalTo(17);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

#pragma mark - button Events
- (void)onDeleteBtnClickAction:(UIButton *)deleteBtn {
    !_deleteImageBlock ? : _deleteImageBlock(self.imageView.image);
}

#pragma mark - setter&&getter
- (YYAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[YYAnimatedImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"littleWorld_PicDeleteBtn"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(onDeleteBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        _deleteBtn.hidden = YES;
    }
    return _deleteBtn;
}

- (UIImageView *)picTypeIcon {
    if (!_picTypeIcon) {
        _picTypeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"littleWorld_pickPic_PicType_gif"]];
        _picTypeIcon.hidden = YES;
    }
    return _picTypeIcon;
}
@end

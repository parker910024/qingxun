//
//  XCPutPictureCell.m
//  UKiss
//
//  Created by apple on 2018/12/9.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "XCPutPictureCell.h"
#import "XCTheme.h"
#import "UIView+NTES.h"

@interface XCPutPictureCell ()
@property (nonatomic, strong) UIImageView *playView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *addIconBtn;

@end

@implementation XCPutPictureCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.contentView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.addIconBtn];
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.playView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconView.frame = CGRectMake(0, 0, self.width, self.height);
    self.addIconBtn.frame = self.iconView.frame;
    self.deleteBtn.frame = CGRectMake(self.width - 36, 0, 36, 36);
    [self.playView sizeToFit];
    self.playView.center = self.contentView.center;
}


- (void)deletePhotoAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deletePhotoCallBackWithCell:)]) {
        [self.delegate deletePhotoCallBackWithCell:self];
    }
}

- (void)addPhotoAction:(UIButton *)button {
    button.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.userInteractionEnabled = YES;
    });
    if (self.delegate && [self.delegate respondsToSelector:@selector(addPhotoCallBack)]) {
        [self.delegate addPhotoCallBack];
    }
}

#pragma mark - getters and setters

- (void)setImage:(UIImage *)image {
    _image = image;
    self.iconView.image = image;
    self.addIconBtn.hidden = image != nil;
    self.deleteBtn.hidden = image == nil;
}
- (void)setShowPlay:(BOOL)showPlay{
    _showPlay = showPlay;
    self.playView.hidden = !showPlay;
}
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconView;
}

- (UIButton *)addIconBtn {
    if (!_addIconBtn) {
        _addIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addIconBtn setImage:[UIImage imageNamed:@"community_issue_img_add"] forState:UIControlStateNormal];
        [_addIconBtn addTarget:self action:@selector(addPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addIconBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"community_issue_img_delete"] forState:UIControlStateNormal];
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -10);
        [_deleteBtn addTarget:self action:@selector(deletePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.hidden = YES;
    }
    return _deleteBtn;
}

- (UIImageView *)playView{
    if (!_playView) {
        _playView = [[UIImageView alloc] init];
        _playView.image = [UIImage imageNamed:@"temp_qu_play"];
        _playView.hidden = YES;
    }
    return _playView;
}
@end

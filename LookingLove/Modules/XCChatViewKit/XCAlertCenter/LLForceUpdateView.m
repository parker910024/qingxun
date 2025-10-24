//
//  LLForceUpdateView.m
//  XCChatViewKit
//
//  Created by fengshuo on 2019/7/29.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "LLForceUpdateView.h"

#import "XCTheme.h"
#import <Masonry.h>
#import "XCMacros.h"

@interface LLForceUpdateView ()
/** 背景*/
@property (nonatomic,strong) UIView *containerView;

/** 和关闭按钮分开的View*/
@property (nonatomic,strong) UIView *contentView;

/** 更新的图标*/
@property (nonatomic, strong) UIImageView *updateImageView;

/** 版本更新 */
@property (nonatomic, strong) UILabel *tagLabel;

/** Version Update */
@property (nonatomic, strong) UILabel *versionLabel;
/** 升级描述 */
@property (nonatomic, strong) UITextView *descriptionTextView;
/** 立即升级按钮 */
@property (nonatomic, strong) UIButton *updateButton;
/** close */
@property (nonatomic, strong) UIImageView *closeImageView;
@end

@implementation LLForceUpdateView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
       
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.descriptionTextView.contentSize.height > self.descriptionTextView.frame.size.height) {
        self.descriptionTextView.scrollEnabled = YES;
    } else {
        self.descriptionTextView.scrollEnabled = NO;
    }
}

#pragma mark - puble method
- (instancetype)initWithTitle:(NSString *)title
                descriptionText:(NSString *)descriptionText
                       isForced:(BOOL)isForced
                         update:(ForcedUpdateViewUpdateClickBlock)update
                          close:(ForcedUpdateViewCloseClickBlock)close {
    if (self = [self initWithFrame:CGRectZero]) {
        self.updateClickBlock = update;
        self.closeClickBlock = close;
        self.descriptionTextView.text = descriptionText;
        self.tagLabel.text = title;
        if (isForced) {
            self.closeImageView.hidden = YES;
        } else {
            self.closeImageView.hidden = NO;
        }
        
        [self initView];
        [self initEvent];
        [self initConstrations];
    }
    return self;
}

#pragma mark - Event
- (void)didClickedUpdateButton:(UIButton *)button {
    if (self.updateClickBlock) {
        self.updateClickBlock();
    }
}

- (void)didRecognizedCloseImageViewTapGestureRecognizer:(UIGestureRecognizer *)recognizer {
    if (self.closeClickBlock) {
        self.closeClickBlock();
    }
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.contentView];
    [self.containerView addSubview:self.closeImageView];
    [self.containerView addSubview:self.updateImageView];
    [self.containerView addSubview:self.tagLabel];
    [self.containerView addSubview:self.versionLabel];
    [self.containerView addSubview:self.descriptionTextView];
    [self.containerView addSubview:self.updateButton];

}

- (void)initEvent {
    self.closeImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *closeImageViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizedCloseImageViewTapGestureRecognizer:)];
    [self.closeImageView addGestureRecognizer:closeImageViewTapGestureRecognizer];
    
    [self.updateButton addTarget:self action:@selector(didClickedUpdateButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initConstrations {
     CGFloat scale = 1;
    self.frame = CGRectMake(0, 0, 280 , 380);
   
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(scale * 380);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self.containerView);
        make.top.mas_equalTo(self.containerView).offset(12 * scale);
        make.right.mas_equalTo(self.containerView).offset(-12 * scale);
    }];
    
    [self.updateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(34 *scale);
        make.top.mas_equalTo(self).offset(35 *scale);
        make.size.mas_equalTo(CGSizeMake(50 * scale, 58 * scale));
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.updateImageView.mas_right).offset(17 * scale);
        make.top.mas_equalTo(self.updateImageView).offset(9 * scale);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagLabel);
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(9 * scale);
    }];
   
    [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.containerView).offset(34 * scale);
        make.right.mas_equalTo(self.containerView).offset(-34 * scale);
        make.top.mas_equalTo(self.updateImageView.mas_bottom).offset(30 * scale);
        make.bottom.mas_equalTo(self.updateButton.mas_top).offset(-20 * scale);
    }];
    
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.containerView).offset(-29 *scale);
        make.width.mas_equalTo(189 * scale);
        make.height.mas_equalTo(51 * scale);
    }];
    
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_right).offset(-12);
        make.top.mas_equalTo(self.contentView).offset(-12);
        make.width.mas_equalTo(25 * scale);
        make.height.mas_equalTo(25 * scale);
    }];
}


#pragma mark - Getter & Setter
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
    }
    return _containerView;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 8;
    }
    return _contentView;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = [XCTheme getTTMainTextColor];
        _tagLabel.font = [UIFont boldSystemFontOfSize:20];
        _tagLabel.text = @"版本更新";
    }
    return _tagLabel;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textColor = [XCTheme getTTMainTextColor];
        _versionLabel.font = [UIFont boldSystemFontOfSize:13];
        _versionLabel.text = @"Version Update";
    }
    return _versionLabel;
}

- (UIImageView *)updateImageView {
    if (!_updateImageView) {
        _updateImageView = [[UIImageView alloc] init];
        _updateImageView.image = [UIImage imageNamed:@"broadcast_update_imageview_bg"];
    }
    return _updateImageView;
}

- (UITextView *)descriptionTextView {
    if (!_descriptionTextView) {
        _descriptionTextView = [[UITextView alloc] init];
        _descriptionTextView.textColor = RGBCOLOR(51, 51, 51);
        _descriptionTextView.font = [UIFont systemFontOfSize:14];
        _descriptionTextView.editable = NO;
        _descriptionTextView.selectable = NO;
    }
    return _descriptionTextView;
}

- (UIButton *)updateButton {
    if (!_updateButton) {
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updateButton setImage:[UIImage imageNamed:@"broadcast_update_btn_bg"] forState:UIControlStateNormal];
    }
    return _updateButton;
}

- (UIImageView *)closeImageView {
    if (!_closeImageView) {
        _closeImageView = [[UIImageView alloc] init];
        _closeImageView.image = [UIImage imageNamed:@"broadcast_close_btn_bg"];
    }
    return _closeImageView;
}

@end

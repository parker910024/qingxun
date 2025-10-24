//
//  XCForcedUpdateView.m
//  XCChatViewKit
//
//  Created by Macx on 2018/8/28.
//  Copyright © 2018年 KevinWang. All rights reserved.
//

#import "XCForcedUpdateView.h"

#import "XCTheme.h"
#import <Masonry.h>
#import "XCMacros.h"

@interface XCForcedUpdateView ()
/** 背景图 */
@property (nonatomic, strong) UIImageView *bgImageView;
/** 发现新版本 */
@property (nonatomic, strong) UILabel *tagLabel;
/** 升级描述 */
@property (nonatomic, strong) UITextView *descriptionTextView;
/** 立即升级按钮 */
@property (nonatomic, strong) UIButton *updateButton;
/** close */
@property (nonatomic, strong) UIImageView *closeImageView;
@end

@implementation XCForcedUpdateView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
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
- (instancetype)initWithBgImage:(UIImage *)bgImage
                          title:(NSString *)title
                descriptionText:(NSString *)descriptionText
                       isForced:(BOOL)isForced
                         update:(ForcedUpdateViewUpdateClickBlock)update
                          close:(ForcedUpdateViewCloseClickBlock)close {
    if (self = [self initWithFrame:CGRectZero]) {
        self.updateClickBlock = update;
        self.closeClickBlock = close;
        self.bgImageView.image = bgImage;
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
        
        [self.updateButton setTitle:@"立即升级" forState:UIControlStateNormal];
        [self.updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.updateButton.titleLabel.font = [UIFont systemFontOfSize:17];
        self.updateButton.backgroundColor = RGBCOLOR(43, 153, 248);
        self.updateButton.layer.cornerRadius = 33 * KScreenWidth / 375 * 0.5;
        self.updateButton.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)initMSWithBgImage:(UIImage *)bgImage
                 updateBtnBGImage:(UIImage *)updateBtnBGImage
                       closeImage:(UIImage *)closeImage
                  descriptionText:(NSString *)descriptionText
                         isForced:(BOOL)isForced
                           update:(ForcedUpdateViewUpdateClickBlock)update
                            close:(ForcedUpdateViewCloseClickBlock)close {
    if (self = [self initWithFrame:CGRectZero]) {
        self.updateClickBlock = update;
        self.closeClickBlock = close;
        self.bgImageView.image = bgImage;
        self.descriptionTextView.text = descriptionText;
        self.closeImageView.image = closeImage;
        [self.updateButton setBackgroundImage:updateBtnBGImage forState:UIControlStateNormal];
        
        if (isForced) {
            self.closeImageView.hidden = YES;
        } else {
            self.closeImageView.hidden = NO;
        }
        
        [self initView];
        [self initEvent];
        [self msInitConstrations];
        self.tagLabel.hidden = YES;
        
        [self.updateButton setTitle:@"立即升级" forState:UIControlStateNormal];
        [self.updateButton setTitleColor:RGBCOLOR(254, 254, 254) forState:UIControlStateNormal];
        self.updateButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
        self.descriptionTextView.textColor = RGBCOLOR(51, 51, 51);
        self.descriptionTextView.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (instancetype)initTTWithBgImage:(UIImage *)bgImage
                 updateBtnBGImage:(UIImage *)updateBtnBGImage
                       closeImage:(UIImage *)closeImage
                  descriptionText:(NSString *)descriptionText
                         isForced:(BOOL)isForced
                           update:(ForcedUpdateViewUpdateClickBlock)update
                            close:(ForcedUpdateViewCloseClickBlock)close {
    if (self = [self initWithFrame:CGRectZero]) {
        self.updateClickBlock = update;
        self.closeClickBlock = close;
        self.bgImageView.image = bgImage;
        self.descriptionTextView.text = descriptionText;
        self.closeImageView.image = closeImage;
        [self.updateButton setBackgroundImage:updateBtnBGImage forState:UIControlStateNormal];
        
        if (isForced) {
            self.closeImageView.hidden = YES;
        } else {
            self.closeImageView.hidden = NO;
        }
        
        [self initView];
        [self initEvent];
        [self ttInitConstrations];
        self.tagLabel.hidden = YES;
        
        [self.updateButton setTitle:@"" forState:UIControlStateNormal];
        
        self.descriptionTextView.textColor = RGBCOLOR(26, 26, 26);
        self.descriptionTextView.font = [UIFont systemFontOfSize:13];
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
    [self addSubview:self.bgImageView];
    [self addSubview:self.tagLabel];
    [self addSubview:self.descriptionTextView];
    [self addSubview:self.updateButton];
    [self addSubview:self.closeImageView];
}

- (void)initEvent {
    self.closeImageView.userInteractionEnabled = YES;

    UITapGestureRecognizer *closeImageViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizedCloseImageViewTapGestureRecognizer:)];
    [self.closeImageView addGestureRecognizer:closeImageViewTapGestureRecognizer];
    
    [self.updateButton addTarget:self action:@selector(didClickedUpdateButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initConstrations {
    
    CGFloat scale = KScreenWidth / 375;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32 * scale);
        make.right.mas_equalTo(-32 * scale);
        make.top.mas_equalTo(148 * scale + kSafeAreaTopHeight);
        make.height.mas_equalTo(scale * 398);
    }];
    
    [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgImageView).offset(25 * scale);
        make.right.mas_equalTo(self.bgImageView).offset(-25 * scale);
        make.bottom.mas_equalTo(self.bgImageView.mas_bottom).offset(-82 * scale);
        make.height.mas_equalTo(94 * scale);
    }];
    
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImageView);
        make.bottom.mas_equalTo(self.bgImageView.mas_bottom).offset(-17 *scale);
        make.width.mas_equalTo(166 * scale);
        make.height.mas_equalTo(33 * scale);
    }];
    
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImageView);
        make.top.mas_equalTo(self.bgImageView.mas_bottom);
        make.width.mas_equalTo(35 * scale);
        make.height.mas_equalTo(71 * scale);
    }];
}

- (void)msInitConstrations {
    
    CGFloat scale = KScreenWidth / 375;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(31 * scale);
        make.right.mas_equalTo(-31 * scale);
        make.top.mas_equalTo(149 * scale + kSafeAreaTopHeight);
        make.height.mas_equalTo(scale * 416);
    }];
    
    [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgImageView).offset(55 * scale);
        make.right.mas_equalTo(self.bgImageView).offset(-55 * scale);
        make.top.mas_equalTo(self.bgImageView.mas_top).offset(235 * scale);
        make.height.mas_equalTo(90 * scale);
    }];
    
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImageView);
        make.bottom.mas_equalTo(self.bgImageView.mas_bottom).offset(-34 *scale);
        make.width.mas_equalTo(125 * scale);
        make.height.mas_equalTo(35 * scale);
    }];
    
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImageView);
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(10);
        make.width.mas_equalTo(28 * scale);
        make.height.mas_equalTo(28 * scale);
    }];
}

- (void)ttInitConstrations {
    
    CGFloat scale = KScreenWidth / 375;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(43 * scale);
        make.right.mas_equalTo(-43 * scale);
        make.top.mas_equalTo(152 * scale + kSafeAreaTopHeight);
        make.height.mas_equalTo(scale * 300);
    }];
    
    [self.descriptionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgImageView).offset(27 * scale);
        make.right.mas_equalTo(self.bgImageView).offset(-27 * scale);
        make.top.mas_equalTo(self.bgImageView.mas_top).offset(143 * scale);
        make.height.mas_equalTo(82 * scale);
    }];
    
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImageView);
        make.bottom.mas_equalTo(self.bgImageView.mas_bottom).offset(-14 *scale);
        make.width.mas_equalTo(170 * scale);
        make.height.mas_equalTo(48 * scale);
    }];
    
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImageView);
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(90);
        make.width.mas_equalTo(32 * scale);
        make.height.mas_equalTo(32 * scale);
    }];
}

#pragma mark - Getter & Setter
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.font = [UIFont boldSystemFontOfSize:24];
        _tagLabel.text = @"发现新版本";
    }
    return _tagLabel;
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
        _updateButton = [[UIButton alloc] init];
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

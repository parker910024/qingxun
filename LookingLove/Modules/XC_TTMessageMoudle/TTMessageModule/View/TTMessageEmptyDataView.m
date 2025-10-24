//
//  TTMessageEmptyDataView.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/28.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTMessageEmptyDataView.h"

#import "XCTheme.h"
#import "XCMacros.h"

#import <Masonry/Masonry.h>

@interface TTMessageEmptyDataView()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TTMessageEmptyDataView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.text = @"暂无数据";
        self.textLineSpacing = 12;
        self.textFontSize = 13;
        self.textColor = [XCTheme getTTDeepGrayTextColor];
        self.textToImageBottomOffset = 0;
        self.imageCenterOffsetY = 0;
        
        [self addTarget:self action:@selector(viewDidTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark - even response
- (void)viewDidTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapEmptyDataView:)]) {
        [self.delegate didTapEmptyDataView:self];
    }
}

#pragma mark - private method
- (void)initViews {
    [self addSubview:self.backImageView];
    [self addSubview:self.titleLabel];
}

- (void)initConstraints {
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self).offset(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self).inset(40);
        make.top.mas_equalTo(self.backImageView.mas_bottom).offset(self.textToImageBottomOffset);
    }];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [self.backImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).offset(self.imageCenterOffsetY);
    }];
    
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backImageView.mas_bottom).offset(self.textToImageBottomOffset);
    }];
}

/**
 设置固定行间距文本
 
 @param lineSpacing 行间距
 @param text 文本内容
 @param label 要设置的label
 */
-(void)label:(UILabel *)label setLineSpacing:(CGFloat)lineSpacing text:(NSString *)text {
    if (!text || !label) {
        return;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    label.attributedText = attributedString;
}

#pragma mark - setters and getters
- (void)setText:(NSString *)text {
    _text = text;
    
    [self label:self.titleLabel setLineSpacing:self.textLineSpacing text:self.text];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    
    self.titleLabel.attributedText = attributedText;
}

- (void)setImage:(NSString *)image {
    _image = image;
    
    UIImage *img = [UIImage imageNamed:image];
    NSAssert(img, @"image can not be nil");
    
    self.backImageView.image = img;
}

- (void)setTextFontSize:(CGFloat)textFontSize {
    _textFontSize = textFontSize;
    
    self.titleLabel.font = [UIFont systemFontOfSize:textFontSize];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    
    self.titleLabel.textColor = textColor;
}

- (void)setTextLineSpacing:(CGFloat)textLineSpacing {
    _textLineSpacing = textLineSpacing;
    
    [self label:self.titleLabel setLineSpacing:self.textLineSpacing text:self.text];
}

- (void)setTextToImageBottomOffset:(CGFloat)textToImageBottomOffset {
    _textToImageBottomOffset = textToImageBottomOffset;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setImageCenterOffsetY:(CGFloat)imageCenterOffsetY {
    _imageCenterOffsetY = imageCenterOffsetY;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UIImageView *)backImageView {
    if (_backImageView == nil) {
        _backImageView =[[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:[[XCTheme defaultTheme] default_empty]];
    }
    return _backImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:self.textFontSize];
        _titleLabel.textColor = self.textColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@end

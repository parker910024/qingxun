//
//  TTVoiceContentCardView.m
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/6/4.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTVoiceContentCardView.h"
//XC_tt
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIButton+EnlargeTouchArea.h"
#import "NSArray+Safe.h"
#import "UIImage+Utils.h"
//第三方类
#import <Masonry/Masonry.h>
//view
#import "TTGameVoiceTableViewCell.h"

#define kScale (KScreenWidth / 375)

@interface TTVoiceContentCardView ()<UITextViewDelegate>

/** 标题*/
@property (nonatomic,strong) UILabel *titleLabel;
/**
 *
 */
@property (nonatomic,strong) UITextView *textView;


/** 刷新的背景图*/
@property (nonatomic,strong) UIButton *changeButton;
/**  刷新的那个图片*/
@property (nonatomic,strong) UIButton *reloadButton;
/** 换一个*/
@property (nonatomic,strong) UILabel * changeLabel;
/** 文字过长的时候 显示*/
@property (nonatomic,strong) UIImageView *shadowImageView;
/** 数据源*/
@property (nonatomic,strong) NSArray *datasource;
@end

@implementation TTVoiceContentCardView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}
#pragma mark - public methods
- (void)clearData {
    self.datasource = nil;
    self.titleLabel.text = @"";
    self.textView.attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
}
#pragma mark - delegate
#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

#pragma mark - event response
- (void)reloadData:(UIButton *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadDataChangeNext)]) {
        [self.delegate reloadDataChangeNext];
    }
}
#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.textView];
    [self addSubview:self.shadowImageView];
    [self addSubview:self.changeButton];
    [self.changeButton addSubview:self.changeLabel];
    [self.changeButton addSubview:self.reloadButton];
    [self.changeButton addTarget:self action:@selector(reloadData:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)initConstrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(25 * kScale);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(38 * kScale);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.width.mas_equalTo(244 * kScale);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(15 * kScale);
        make.height.mas_equalTo(126 * kScale);
    }];

    
    [self.shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.bottom.mas_equalTo(self.textView);
        make.height.mas_equalTo(15 * kScale);
    }];
    
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60 * kScale);
        make.bottom.right.mas_equalTo(self);
    }];
    
    [self.reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16 * kScale);
        make.bottom.mas_equalTo(self).offset(-25 * kScale);
        make.right.mas_equalTo(self.changeButton).offset(-19 * kScale);
    }];
    
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reloadButton.mas_bottom).offset(5 * kScale);
        make.centerX.mas_equalTo(self.reloadButton);
    }];
}

- (CGFloat)getConetentHeightWith:(NSString *)content {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 8;
    NSDictionary * dic = @{
                           NSForegroundColorAttributeName : [XCTheme getTTDeepGrayTextColor],
                           NSFontAttributeName:[UIFont systemFontOfSize:15],
                           NSParagraphStyleAttributeName:style
                           
                           };
    return [content boundingRectWithSize:CGSizeMake(244 * kScale, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height + 10;
}

#pragma mark - getters and setters
- (void)setPicModel:(VoiceBottlePiaModel *)picModel {
    _picModel = picModel;
    if (_picModel) {
        self.titleLabel.text = _picModel.title;
         NSString * str = _picModel.playBook;
        if (!str) {
            str = @"";
        }
       CGFloat hegith = [self getConetentHeightWith:str];
        if (hegith <= 0) {
            hegith = 20;
        }
        self.shadowImageView.hidden = YES;
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 8;
        NSDictionary * dic = @{
                               NSForegroundColorAttributeName : [XCTheme getTTDeepGrayTextColor],
                               NSFontAttributeName:[UIFont systemFontOfSize:15],
                               NSParagraphStyleAttributeName:style
                               
                               };
        NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
        self.textView.attributedText = attribut;
    }
}

- (void)setIsShowReload:(BOOL)isShowReload {
    _isShowReload = isShowReload;
    self.changeLabel.hidden = !_isShowReload;
    self.changeButton.hidden = !_isShowReload;
    self.reloadButton.hidden = !_isShowReload;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:26];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
    }
    return _titleLabel;
}

- (UILabel *)changeLabel {
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.font = [UIFont systemFontOfSize:10];
        _changeLabel.textColor = [XCTheme getTTMainTextColor];
        _changeLabel.text = @"换一个";
        _changeLabel.textAlignment = NSTextAlignmentCenter;
        _changeLabel.hidden = YES;
    }
    return _changeLabel;
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadButton setImage:[UIImage imageNamed:@"game_voice_card_reload"] forState:UIControlStateNormal];
        _reloadButton.userInteractionEnabled = NO;
        _reloadButton.hidden = YES;
    }
    return _reloadButton;
}



- (UIButton *)changeButton {
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeButton setBackgroundImage:[UIImage imageNamed:@"game_voice_card_shadow"] forState:UIControlStateNormal];
        [_changeButton setBackgroundImage:[UIImage imageNamed:@"game_voice_card_shadow"] forState:UIControlStateSelected];
         _changeButton.adjustsImageWhenHighlighted = NO;
        _changeButton.hidden = YES;
    }
    return _changeButton;
}


- (UIImageView *)shadowImageView {
    if (!_shadowImageView) {
        _shadowImageView = [[UIImageView alloc] init];
        _shadowImageView.image = [UIImage imageNamed:@"game_voice_card_content"];
        _shadowImageView.hidden = YES;
    }
    return _shadowImageView;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.tintColor= [UIColor clearColor];
        _textView.delegate = self;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.editable = NO;
    }
    return _textView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

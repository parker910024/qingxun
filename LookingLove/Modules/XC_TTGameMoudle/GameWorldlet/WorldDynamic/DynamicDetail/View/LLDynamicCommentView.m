//
//  LLDynamicCommentView.m
//  XC_TTGameMoudle
//
//  Created by Lee on 2019/12/14.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "LLDynamicCommentView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIView+XCToast.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LLDynamicCommentView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation LLDynamicCommentView

#pragma mark -
#pragma mark lifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.nickLabel];
    [self addSubview:self.iconImageView];
    [self addSubview:self.timeLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.lineView];
}

- (void)initConstraints {
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(20);
        make.height.width.mas_equalTo(45);
    }];
    
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(12);
        make.top.mas_equalTo(self.iconImageView);
        make.right.mas_equalTo(-80);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nickLabel);
        make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(10);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.nickLabel);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark -
#pragma mark SystemApi Delegate

#pragma mark -
#pragma mark CustomView Delegate

#pragma mark -
#pragma mark CoreClients

#pragma mark -
#pragma mark Event Response

#pragma mark -
#pragma mark Public Methods

#pragma mark -
#pragma mark Private Methods

#pragma mark -
#pragma mark Getters and Setters

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 45/2;
        _iconImageView.layer.masksToBounds = YES;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img03.liwushuo.com/image/160617/hzkkl1ohn.jpg"]];
    }
    return _iconImageView;
}

- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [[UILabel alloc] init];
        _nickLabel.text = @"阿拉伯的劳伦斯";
        _nickLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    }
    return _nickLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"庆历四年春";
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [XCTheme getTTSubTextColor];
    }
    return _timeLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.text = @"庆历四年春，滕子京谪（封建王朝官吏降职或远调）守巴陵郡。越（及，到）明年，政通人和，百废具（同“俱”全，皆）兴。乃重修岳阳楼，增其旧制，刻唐贤今人诗赋于其上。属（同“嘱”）予作文以记之。\n予观夫巴陵胜状（好风景），在洞庭一湖。衔远山，吞长江，浩浩汤汤（水波浩荡的样子），横（广远）无际（边）涯；朝晖（日光）夕阴，气象万千。此则岳阳楼之大观也。前人之述备矣。然则北通巫峡，南极（尽）潇湘，迁客骚人，多会于此，览物之情，得无异乎？\n若夫霪雨（连绵不断的雨）霏霏，连月不开（放晴），阴风怒号，浊浪排空（冲向天空）；日星隐耀，山岳潜形；商旅不行，樯倾楫摧；薄（迫近）暮冥冥，虎啸猿啼。登斯楼也，则有去国怀乡，忧谗畏讥，满目萧然，感极而悲者矣。\n至若春和景（日光）明，波澜不惊，上下天光，一碧万顷；沙鸥翔集，锦鳞（美丽的鱼）游泳；岸芷汀兰，郁郁青青。而或长烟一空，皓月千里，浮光跃金，静影沉璧，渔歌互答，此乐何极！登斯楼也，则有心旷神怡，宠辱偕忘，把（持）酒临风，其喜洋洋者矣。\n嗟夫！予尝（曾经）求（探求）古仁人之心，或异二者之为，何哉？不以物喜，不以己悲；居庙堂之高则忧其民；处江湖之远则忧其君。是进亦忧，退亦忧。然则何时而乐耶？其必曰“先天下之忧而忧，后天下之乐而乐”乎。噫！微（没有）斯人，吾谁与归（归依？\n时六年九月十五日。";
    }
    return _messageLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xF4F4F4);
    }
    return _lineView;
}
@end

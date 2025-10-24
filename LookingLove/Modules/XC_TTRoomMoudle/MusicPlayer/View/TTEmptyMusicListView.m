//
//  TTEmptyMusicListView.m
//  TuTu
//
//  Created by Macx on 2018/11/22.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTEmptyMusicListView.h"

//3rd part
#import <Masonry/Masonry.h>

//theme
#import "XCTheme.h"
#import "XCMacros.h"

//core
#import "MeetingCore.h"

@interface TTEmptyMusicListView()

/**
 没有音乐的提示标签
 */
@property (strong, nonatomic) UILabel       *noMusicTipsLabel;

/**
 没有音乐的图标
 */
@property (strong, nonatomic) UIImageView   *noMusicTipsIconImageView;

/**
 电脑传输歌曲的按钮
 */
@property (strong, nonatomic) UIButton      *addMusicButton;
/** 添加共享音乐按钮 */
@property (nonatomic, strong) UIButton *addShareMusicButton;
@end

@implementation TTEmptyMusicListView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response

- (void)didClickAddMusicButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(emptyMusicListView:addMusicButtonClick:)]) {
        [self.delegate emptyMusicListView:self addMusicButtonClick:sender];
    }
}

- (void)didClickAddShareMusicButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(emptyMusicListView:addShareMusicButtonClick:)]) {
        [self.delegate emptyMusicListView:self addShareMusicButtonClick:sender];
    }
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.noMusicTipsIconImageView];
    [self addSubview:self.noMusicTipsLabel];
    [self addSubview:self.addMusicButton];
    [self addSubview:self.addShareMusicButton];
}

- (void)initConstrations {
    [self.noMusicTipsIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(320 * KScreenWidth/375);
        make.top.mas_equalTo(self.mas_top).offset(40);
    }];
    [self.noMusicTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.noMusicTipsIconImageView).offset(240 * KScreenWidth/375);
        make.centerX.mas_equalTo(self.noMusicTipsIconImageView.mas_centerX);
    }];
    [self.addShareMusicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(230);
        make.height.mas_equalTo(38);
        make.top.mas_equalTo(self.noMusicTipsLabel.mas_bottom).offset(30);
    }];
    
    [self.addMusicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(230);
        make.height.mas_equalTo(38);
        make.top.mas_equalTo(self.addShareMusicButton.mas_bottom).offset(22);
    }];
}

#pragma mark - getters and setters

- (UILabel *)noMusicTipsLabel {
    if (!_noMusicTipsLabel) {
        _noMusicTipsLabel = [[UILabel alloc]init];
        _noMusicTipsLabel.text = @"你的音乐列表空空如也\n赶紧去添加音乐吧";
        _noMusicTipsLabel.font = [UIFont systemFontOfSize:13];
        _noMusicTipsLabel.textColor = RGBCOLOR(153, 153, 153);
        _noMusicTipsLabel.numberOfLines = 0;
        _noMusicTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noMusicTipsLabel;
}

- (UIImageView *)noMusicTipsIconImageView {
    if (!_noMusicTipsIconImageView) {
        _noMusicTipsIconImageView = [[UIImageView alloc]init];
        _noMusicTipsIconImageView.image = [UIImage imageNamed:@"common_noData_empty"];
    }
    return _noMusicTipsIconImageView;
}

- (UIButton *)addMusicButton {
    if (!_addMusicButton) {
        _addMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addMusicButton.backgroundColor = [XCTheme getTTMainColor];
        _addMusicButton.layer.cornerRadius = 19;
        [_addMusicButton setTitle:@"电脑传输歌曲" forState:UIControlStateNormal];
        [_addMusicButton addTarget:self action:@selector(didClickAddMusicButton:) forControlEvents:UIControlEventTouchUpInside];
        [_addMusicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addMusicButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _addMusicButton;
}

- (UIButton *)addShareMusicButton {
    if (!_addShareMusicButton) {
        _addShareMusicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addShareMusicButton.backgroundColor = [XCTheme getTTMainColor];
        _addShareMusicButton.layer.cornerRadius = 19;
        [_addShareMusicButton setTitle:@"添加共享音乐" forState:UIControlStateNormal];
        [_addShareMusicButton addTarget:self action:@selector(didClickAddShareMusicButton:) forControlEvents:UIControlEventTouchUpInside];
        [_addShareMusicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addShareMusicButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _addShareMusicButton;
}

@end

//
//  TTRoomShareMusicSearchView.m
//  TTPlay
//
//  Created by Macx on 2019/3/22.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRoomShareMusicSearchView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTRoomShareMusicSearchView ()
/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** scrollContentView */
@property (nonatomic, strong) UIView *scrollContentView;
/** contentView */
@property (nonatomic, strong) UIView *contentView;
/** 搜索框 */
@property (nonatomic, strong) UITextField *textField;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancleButton;
/** 搜索icon */
@property (nonatomic, strong) UIImageView *searchIconImageView;
/** placeHolderLabel */
@property (nonatomic, strong) UILabel *placeHolderLabel;


/** isSearch */
@property (nonatomic, assign) BOOL isSearch;
@end

@implementation TTRoomShareMusicSearchView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
        
        self.isSearch = NO;
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)didClickedCancleButton:(UIButton *)button {
    self.isSearch = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(roomShareMusicSearchView:didClickCancleButton:)]) {
        [self.delegate roomShareMusicSearchView:self didClickCancleButton:button];
    }
}

- (void)didTapGesContentView:(UITapGestureRecognizer *)tap {
    
    if (self.isSearch) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(roomShareMusicSearchView:didClickSearchContent:)]) {
        [self.delegate roomShareMusicSearchView:self didClickSearchContent:tap.view];
    }
    self.isSearch = YES;
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContentView];
    
    [self.scrollContentView addSubview:self.contentView];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.searchIconImageView];
    [self.contentView addSubview:self.placeHolderLabel];
    [self.scrollContentView addSubview:self.cancleButton];
    
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGesContentView:)]];
}

- (void)initConstrations {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(self.scrollView);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(7);
        make.bottom.mas_equalTo(-7);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self).offset(20);
    }];
    
    [self.searchIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(14);
        make.right.mas_equalTo(self.placeHolderLabel.mas_left).offset(-5);
    }];
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-13);
    }];
}

#pragma mark - getters and setters

- (void)setIsSearch:(BOOL)isSearch {
    _isSearch = isSearch;
    
    if (isSearch) {
        self.cancleButton.hidden = NO;
        self.textField.hidden = NO;
        
        self.placeHolderLabel.hidden = YES;
        self.searchIconImageView.hidden = YES;
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-68);
        }];
        [self.textField becomeFirstResponder];
    } else {
        self.cancleButton.hidden = YES;
        self.textField.hidden = YES;
        
        self.placeHolderLabel.hidden = NO;
        self.searchIconImageView.hidden = NO;
        
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
        }];
        [self.textField resignFirstResponder];
        self.textField.text = @"";
    }
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.layer.cornerRadius = 15;
        _contentView.layer.masksToBounds = YES;
        _contentView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _contentView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIView *)scrollContentView {
    if (!_scrollContentView) {
        _scrollContentView = [[UIView alloc] init];
        _scrollContentView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollContentView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.tintColor = [XCTheme getTTMainColor];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [XCTheme getTTMainTextColor];
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索共享音乐" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [XCTheme getTTDeepGrayTextColor]}];
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"room_music_icon_search"];
        searchIcon.frame = CGRectMake(12, 8, 14, 14);
        searchIcon.contentMode = UIViewContentModeCenter;
        UIView *searchIconView = [[UIView alloc] init];
        [searchIconView addSubview:searchIcon];
        searchIconView.frame = CGRectMake(0, 0, 30, 30);
        _textField.leftView = searchIconView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.enablesReturnKeyAutomatically = YES;
        
    }
    return _textField;
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [[UIButton alloc] init];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[XCTheme getTTDeepGrayTextColor] forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancleButton addTarget:self action:@selector(didClickedCancleButton:) forControlEvents:UIControlEventTouchUpInside];
        _cancleButton.hidden = YES;
    }
    return _cancleButton;
}

- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.text = @"搜索共享音乐";
        _placeHolderLabel.textColor = [XCTheme getTTDeepGrayTextColor];
        _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    }
    return _placeHolderLabel;
}

- (UIImageView *)searchIconImageView {
    if (!_searchIconImageView) {
        _searchIconImageView = [[UIImageView alloc] init];
        _searchIconImageView.image = [UIImage imageNamed:@"room_music_icon_search"];
    }
    return _searchIconImageView;
}

@end

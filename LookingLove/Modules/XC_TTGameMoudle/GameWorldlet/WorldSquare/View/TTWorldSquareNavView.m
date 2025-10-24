//
//  TTWorldSquareNavView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldSquareNavView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "UIButton+EnlargeTouchArea.h"

@interface TTWorldSquareNavView()<UITextFieldDelegate>
/** 搜索框 */
@property (nonatomic, strong) UITextField *searchTextField;
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation TTWorldSquareNavView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self initView];
        [self initConstrations];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - private method
- (void)initView {
    [self addSubview:self.searchTextField];
    [self addSubview:self.backButton];
}

- (void)initConstrations {
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchTextField);
        make.left.mas_equalTo(16);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(22);
        make.right.mas_equalTo(self.searchTextField.mas_left).offset(-4);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark - Event Response
- (void)didClickbackButton:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickBackActionInNavView:)]) {
        [self.delegate didClickBackActionInNavView:self];
    }
}

- (void)didClickSearchButton:(UITextField *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickSearchActionInNavView:)]) {
        [self.delegate didClickSearchActionInNavView:self];
    }
}

#pragma mark - Getter & Setter
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.delegate = self;
        _searchTextField.layer.cornerRadius = 15;
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.tintColor = [XCTheme getTTMainColor];
        _searchTextField.backgroundColor = UIColorFromRGB(0xf5f5f5);
        _searchTextField.font = [UIFont systemFontOfSize:14];
        
        _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索你感兴趣的小世界" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : UIColorFromRGB(0xb3b3b3)}];
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"search_left_logo"];
        searchIcon.frame = CGRectMake(11, 7, 20, 16);
        searchIcon.contentMode = UIViewContentModeCenter;
        UIView *searchIconView = [[UIView alloc] init];
        [searchIconView addSubview:searchIcon];
        searchIconView.frame = CGRectMake(0, 0, 34, 30);
        
        _searchTextField.leftView = searchIconView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.enablesReturnKeyAutomatically = YES;
        
        [_searchTextField addTarget:self action:@selector(didClickSearchButton:) forControlEvents:UIControlEventTouchDown];
    }
    return _searchTextField;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(didClickbackButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_backButton setEnlargeEdgeWithTop:10 right:4 bottom:10 left:10];
    }
    return _backButton;
}

@end

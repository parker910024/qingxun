//
//  TTWorldSearchNavView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/7/1.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldSearchNavView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"

@interface TTWorldSearchNavView()<UITextFieldDelegate>
/** 搜索框 */
@property (nonatomic, strong) UITextField *searchTextField;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancleButton;
@end

@implementation TTWorldSearchNavView

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
    [self addSubview:self.cancleButton];
}

- (void)initConstrations {
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-62);
        make.bottom.mas_equalTo(self).offset(-8);
    }];
    
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.searchTextField);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(31 + 12);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - Public Method
/**
 初始化设置键盘弹出
 */
- (void)keyboradInitialShow {
    
    if ([self.searchTextField isFirstResponder]) {
        return;
    }
    
    [self.searchTextField becomeFirstResponder];
}

#pragma mark - Event Response
- (void)didTapCancelButton:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCancelActionInNavView:)]) {
        [self.delegate didClickCancelActionInNavView:self];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(navView:search:)]) {
        [self.delegate navView:self search:textField.text];
    }
    
    return YES;
}

#pragma mark - Getter & Setter
- (NSString *)currentSearchText {
    return [self.searchTextField.text copy];
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.delegate = self;
        _searchTextField.layer.cornerRadius = 15;
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.tintColor = [XCTheme getTTMainColor];
        _searchTextField.backgroundColor = RGBCOLOR(242, 242, 242);
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
    }
    return _searchTextField;
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [[UIButton alloc] init];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancleButton addTarget:self action:@selector(didTapCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

@end

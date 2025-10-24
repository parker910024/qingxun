//
//  TTSearchCustomNavView.m
//  TuTu
//
//  Created by Macx on 2018/11/5.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTSearchCustomNavView.h"

#import <Masonry/Masonry.h>
#import "XCTheme.h"

#import "XCKeyWordTool.h"

@interface TTSearchCustomNavView()
/** 搜索框 */
@property (nonatomic, strong) UITextField *searchTextField;
/** 取消按钮 */
@property (nonatomic, strong) UIButton *cancleButton;
@end

@implementation TTSearchCustomNavView

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

#pragma mark - Getter & Setter
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.layer.cornerRadius = 15;
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.tintColor = [XCTheme getTTMainColor];
        _searchTextField.backgroundColor = RGBCOLOR(242, 242, 242);
        _searchTextField.font = [UIFont systemFontOfSize:13];
        
        NSString *placeholder = [NSString stringWithFormat:@"搜索昵称/%@ID/房间名", [XCKeyWordTool sharedInstance].myAppName];

        _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : UIColorFromRGB(0xB3B3B3)}];
        
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
        [_cancleButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _cancleButton;
}

@end

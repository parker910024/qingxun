//
//  TTFamilyEmptyViewController.m
//  TuTu
//
//  Created by gzlx on 2018/11/20.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyEmptyViewController.h"
#import "XCTheme.h"
#import <Masonry/Masonry.h>
#import "XCMacros.h"
#import "TTFamilySquareViewController.h"

@interface TTFamilyEmptyViewController ()
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * squareButton;
@end

@implementation TTFamilyEmptyViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initContrations];
    
}

#pragma mark - response
- (void)gotoFamilySquare:(UIButton *)sender{
    TTFamilySquareViewController * squareVC = [[TTFamilySquareViewController alloc] init];
    [self.navigationController pushViewController:squareVC animated:YES];
}

#pragma mark - private method
- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.squareButton];
}

- (void)initContrations{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.view).offset(-60);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(185);
        make.height.mas_equalTo(145);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(4);
    }];
    
    [self.squareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
}
#pragma mark  - setters and getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  = [XCTheme getTTDeepGrayTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"暂时未加入家族哦";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [UIImage imageNamed:@"common_noData_empty"];
    }
    return _iconImageView;
}

- (UIButton *)squareButton{
    if (!_squareButton) {
        _squareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_squareButton setTitle:@"前往家族广场寻找家族 >>" forState:UIControlStateNormal];
        [_squareButton setTitleColor:[XCTheme getTTMainColor] forState:UIControlStateNormal];
        [_squareButton addTarget:self action:@selector(gotoFamilySquare:) forControlEvents:UIControlEventTouchUpInside];
        _squareButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _squareButton;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

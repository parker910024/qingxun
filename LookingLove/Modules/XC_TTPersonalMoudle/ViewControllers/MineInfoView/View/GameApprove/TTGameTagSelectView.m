//
//  TTGameTagSelectView.m
//  TTPlay
//
//  Created by new on 2019/3/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameTagSelectView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "NSArray+Safe.h"
#import "TTPopup.h"
#import <UIButton+WebCache.h>

#import "TTMineGameTagCore.h"

#import "TTGameTagCustomButton.h" // 自定义button

@interface TTGameTagSelectView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) TTGameTagCustomButton *leftTagButton;
@property (nonatomic, strong) TTGameTagCustomButton *centerTagButton;
@property (nonatomic, strong) TTGameTagCustomButton *rightTagButton;
@property (nonatomic, strong) NSMutableArray<TTGameTagCustomButton *> *btnArray;
@property (nonatomic, strong) TTGameTagCustomButton *currentSelectBtn;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *userButton;
@property (nonatomic, strong) NSMutableArray<CertificationSkillListModel *> *listArray;

@end

@implementation TTGameTagSelectView


- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        [self initView];
        
        [self initConstraint];
        
        self.backgroundColor = UIColorRGBAlpha(0x000000, 0.3);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAndHiddenView)];
        
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)initView{
    [self addSubview:self.backView];
    [self.backView addSubview:self.leftTagButton];
    [self.backView addSubview:self.centerTagButton];
    [self.backView addSubview:self.rightTagButton];
    [self.backView addSubview:self.tipLabel];
    [self.backView addSubview:self.deleteButton];
    [self.backView addSubview:self.userButton];
    
    [self.btnArray addObject:self.leftTagButton];
    [self.btnArray addObject:self.centerTagButton];
    [self.btnArray addObject:self.rightTagButton];
}

- (void)initConstraint{
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(309, 233));
        make.center.mas_equalTo(self.center);
    }];
    
    [self initImageViewConstraint];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftTagButton.mas_bottom).offset(24);
        make.centerX.mas_equalTo(self.backView);
    }];
    
    [self initButtonConstraint];
}

- (void)initButtonConstraint{
    
    self.deleteButton.hidden = NO;
    
    self.userButton.hidden = NO;
    
    [self.deleteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(120, 38));
        make.left.mas_equalTo(26);
    }];
    
    [self.userButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(25);
        make.size.mas_equalTo(CGSizeMake(120, 38));
        make.right.mas_equalTo(-26);
    }];
}

- (void)initImageViewConstraint{
    
    NSInteger btnSpace = (309 - 75 * 3) / 4;
    
    [self.leftTagButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.top.mas_equalTo(self.backView.mas_top).offset(34);
        make.left.mas_equalTo(btnSpace);
    }];
    [self.centerTagButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.top.mas_equalTo(self.backView.mas_top).offset(34);
        make.centerX.mas_equalTo(self.backView);
    }];
    
    [self.rightTagButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(75, 75));
        make.top.mas_equalTo(self.backView.mas_top).offset(34);
        make.right.mas_equalTo(-btnSpace);
    }];
}

- (void)setModel:(CertificationModel *)model{
    
    [self.listArray removeAllObjects];
    
    for (int i = 0; i < self.btnArray.count; i++) {
        TTGameTagCustomButton *button = [self.btnArray safeObjectAtIndex:i];
        button.hidden = YES;
        button.selectImageView.hidden = YES;
    }
    
    _model = model;
    
    NSMutableArray *skillVolistArray = model.liveSkillVoList.mutableCopy;
    for (int i = 0; i < skillVolistArray.count; i++) {
        CertificationSkillListModel *listModel = [skillVolistArray safeObjectAtIndex:i];
        if (listModel.status == 3) {
            [self.listArray addObject:listModel];
        }
    }
    
    NSInteger index = self.listArray.count > 3 ? 3 : self.listArray.count;
    
    switch (index) {
        case 1:{
            CertificationSkillListModel *listModel = [self.listArray safeObjectAtIndex:0];
            self.leftTagButton.hidden = NO;
            if (listModel.hasUse) {
                self.leftTagButton.selectImageView.hidden = NO;
                self.currentSelectBtn = self.leftTagButton;
            }
            [self.leftTagButton sd_setImageWithURL:[NSURL URLWithString:listModel.skillPicture] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_square]];
            [self.leftTagButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(75, 75));
                make.top.mas_equalTo(self.backView.mas_top).offset(34);
                make.centerX.mas_equalTo(self.backView);
            }];
            break;
        }
        case 2:{
            NSInteger btnSpace = (309 - 75 * 2) / 3;
            [self.leftTagButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(75, 75));
                make.top.mas_equalTo(self.backView.mas_top).offset(34);
                make.left.mas_equalTo(btnSpace);
            }];
            
            [self.centerTagButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(75, 75));
                make.top.mas_equalTo(self.backView.mas_top).offset(34);
                make.right.mas_equalTo(-btnSpace);
            }];
            for (int i = 0; i < 2; i++) {
                CertificationSkillListModel *listModel = [self.listArray safeObjectAtIndex:i];
                TTGameTagCustomButton * button = [self.btnArray safeObjectAtIndex:i];
                button.hidden = NO;
                if (listModel.hasUse) {
                    button.selectImageView.hidden = NO;
                    self.currentSelectBtn = button;
                }
                [button sd_setImageWithURL:[NSURL URLWithString:listModel.skillPicture] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_square]];
            }
            
            break;
        }
        case 3:{
            [self initImageViewConstraint];
            for (int i = 0; i < 3; i++) {
                CertificationSkillListModel *listModel = [self.listArray safeObjectAtIndex:i];
                TTGameTagCustomButton *button = [self.btnArray safeObjectAtIndex:i];
                button.hidden = NO;
                if (listModel.hasUse) {
                    button.selectImageView.hidden = NO;
                    self.currentSelectBtn = button;
                }
                [button sd_setImageWithURL:[NSURL URLWithString:listModel.skillPicture] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:[XCTheme defaultTheme].placeholder_image_square]];
            }
            break;
        }
            
        default:
            break;
    }
    
}


#pragma mark -- button Action ---

- (void)deleteTagButtonAction:(UIButton *)sender{
    if (self.currentSelectBtn) {
        NSLog(@"我要删除第%ld个",self.currentSelectBtn.tag - 100);
        
        CertificationSkillListModel *listModel = [self.listArray safeObjectAtIndex:self.currentSelectBtn.tag - 100];
        
        @weakify(self);
        [TTPopup alertWithMessage:@"删除的标签需重新认证" confirmHandler:^{
            @strongify(self);
            [[GetCore(TTMineGameTagCore) personPageGameTagDeleteOrUserWithLiveId:listModel.liveId WithStatus:1] subscribeCompleted:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(deleteGameTagAndUpdateUserInfo)]) {
                    [self.delegate deleteGameTagAndUpdateUserInfo];
                }
            }];
        } cancelHandler:^{
        }];
        
        self.hidden = YES;
    }
}

- (void)userTagButtonAction:(UIButton *)sender{
    if (self.currentSelectBtn) {
        NSLog(@"我要使用第%ld个",self.currentSelectBtn.tag - 100);
        CertificationSkillListModel *listModel = [self.listArray safeObjectAtIndex:self.currentSelectBtn.tag - 100];
        __weak typeof(self) weakSelf = self;
        [[GetCore(TTMineGameTagCore) personPageGameTagDeleteOrUserWithLiveId:listModel.liveId WithStatus:2] subscribeCompleted:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(deleteGameTagAndUpdateUserInfo)]) {
                [weakSelf.delegate deleteGameTagAndUpdateUserInfo];
            }
        }];
        self.hidden = YES;
    }
}


- (void)leftTagBtnClickAction:(TTGameTagCustomButton *)sender{
    
    [self cancelButtonSelected:sender];
}

- (void)centerTagBtnClickAction:(TTGameTagCustomButton *)sender{
    
    [self cancelButtonSelected:sender];
    
}

- (void)rightTagBtnClickAction:(TTGameTagCustomButton *)sender{
    [self cancelButtonSelected:sender];
    
}

- (void)tapAndHiddenView{
    self.hidden = YES;
}

- (void)cancelButtonSelected:(TTGameTagCustomButton *)sender{
    
    for (int i = 0; i < self.btnArray.count; i++) {
        TTGameTagCustomButton *button = [self.btnArray safeObjectAtIndex:i];
        button.selectImageView.hidden = YES;
    }
    
    self.currentSelectBtn = sender;
    sender.selectImageView.hidden = NO;
}


#pragma mark -- setter ---

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (NSMutableArray<CertificationSkillListModel *> *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColorFromRGB(0xffffff);
        _backView.layer.cornerRadius = 14;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (TTGameTagCustomButton *)leftTagButton{
    if (!_leftTagButton) {
        _leftTagButton = [TTGameTagCustomButton buttonWithType:UIButtonTypeCustom];
        _leftTagButton.hidden = YES;
        _leftTagButton.tag = 100;
        [_leftTagButton addTarget:self action:@selector(leftTagBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftTagButton;
}

- (TTGameTagCustomButton *)centerTagButton{
    if (!_centerTagButton) {
        _centerTagButton = [TTGameTagCustomButton buttonWithType:UIButtonTypeCustom];
        _centerTagButton.hidden = YES;
        _centerTagButton.tag = 101;
        [_centerTagButton addTarget:self action:@selector(centerTagBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerTagButton;
}

- (TTGameTagCustomButton *)rightTagButton{
    if (!_rightTagButton) {
        _rightTagButton = [TTGameTagCustomButton buttonWithType:UIButtonTypeCustom];
        _rightTagButton.hidden = YES;
        _rightTagButton.tag = 102;
        [_rightTagButton addTarget:self action:@selector(rightTagBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightTagButton;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [XCTheme getTTMainTextColor];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.text = @"选择使用后，会在资料卡、主麦为显示";
    }
    return _tipLabel;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _deleteButton.backgroundColor = UIColorFromRGB(0xFD6964);
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _deleteButton.layer.cornerRadius = 19;
        [_deleteButton addTarget:self action:@selector(deleteTagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIButton *)userButton{
    if (!_userButton) {
        _userButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userButton setTitle:@"使用" forState:UIControlStateNormal];
        [_userButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _userButton.backgroundColor = UIColorFromRGB(0xFFB606);
        _userButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _userButton.layer.cornerRadius = 19;
        [_userButton addTarget:self action:@selector(userTagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userButton;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

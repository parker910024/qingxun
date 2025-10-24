//
//  TTFamilyMonSectionView.m
//  TuTu
//
//  Created by gzlx on 2018/11/5.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTFamilyMonSectionView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "PLTimeUtil.h"
#import "NSString+Utils.h"
#import "FamilyCore.h"

@interface TTFamilyMonSectionView ()
@property (nonatomic, strong) UIButton * dateButton;
@property (nonatomic, strong) UIImageView * arrowImageView;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation TTFamilyMonSectionView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - public method
- (void)cofigFamilyMonSetionWith:(XCFamilyMoneyModel *)familyMon selectData:(NSDate *)date{
    if (familyMon) {
        NSString * dateTime = [PLTimeUtil getDateWithYYMM:familyMon.month];
        [self.dateButton setTitle:dateTime forState:UIControlStateNormal];
        NSString * moneyName = familyMon.moneyName;
       moneyName = moneyName.length > 0 ? moneyName : @"";
        self.titleLabel.text = [NSString stringWithFormat:@"支出：%@%@   收入：%@%@", [NSString changeAsset:[NSString stringWithFormat:@"%.2f", familyMon.cost]],moneyName,  [NSString changeAsset:[NSString stringWithFormat:@"%.2f", familyMon.income]], moneyName];
    }else{
        if (date == nil) {
            date = [NSDate date];
        }
        NSString * dateTime = [PLTimeUtil getYYMMWithDate:date];
        NSString * moneyName = @"";
        [self.dateButton setTitle:dateTime forState:UIControlStateNormal];
        self.titleLabel.text = [NSString stringWithFormat:@"支出：%@%@   收入：%@%@", @"0.00",moneyName,@"0.00", moneyName];
    }
}

#pragma mark - response
- (void)dateButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseDataWith:)]) {
        [self.delegate chooseDataWith:sender];
    }
}

#pragma mark - life cycle
- (void)initView{
    self.backgroundColor = [XCTheme getTTSimpleGrayColor];
    [self addSubview:self.dateButton];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.titleLabel];
}

- (void)initContrations{
    [self.dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self).offset(4);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(9);
        make.height.mas_equalTo(5);
        make.centerY.mas_equalTo(self.dateButton);
        make.left.mas_equalTo(self.dateButton.mas_right).offset(3);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self.dateButton.mas_bottom).offset(2);
    }];
}

#pragma mark - setters and getters
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  = [XCTheme getTTDeepGrayTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

- (UIButton *)dateButton{
    if (!_dateButton) {
        _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        [_dateButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        _dateButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_dateButton addTarget:self action:@selector(dateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateButton;
}

- (UIImageView *)arrowImageView{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"family_mon_arrow"];
    }
    return _arrowImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

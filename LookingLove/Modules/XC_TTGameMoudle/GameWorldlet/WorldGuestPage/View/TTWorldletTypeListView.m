//
//  TTWorldletTypeListView.m
//  XC_TTGameMoudle
//
//  Created by apple on 2019/7/8.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldletTypeListView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "UIView+NTES.h"
#import <UIButton+WebCache.h>
#import "NSArray+Safe.h"
#import "UIButton+EnlargeTouchArea.h"

@interface TTWorldletTypeListView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TTWorldletTypeListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        
        [self initConstraint];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissView)];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)initView {
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
}

- (void)initConstraint {
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(289);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19);
        make.centerX.mas_equalTo(self);
    }];
}

- (void)typeBtnAction:(UIButton *)sender {
    LittleWorldCategory *model = [self.dataArray safeObjectAtIndex:sender.tag - 100];
    if (self.delegate && [self.delegate respondsToSelector:@selector(worldletTypeClickWithName:)]) {
        [self.delegate worldletTypeClickWithName:model];
    }
}

- (void)dissView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(worldletTypeViewDismiss:)]) {
        [self.delegate worldletTypeViewDismiss:self];
    }
}

- (void)setDataArray:(NSMutableArray<LittleWorldCategory *> *)dataArray {
    _dataArray = dataArray;
    
    if (_dataArray.count % 3 == 0) {
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54 + ((KScreenWidth - 40 - 26) / 3 + 10) * (self.dataArray.count / 3));
        }];
    } else {
        [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(54 + ((KScreenWidth - 40 - 26) / 3 + 10) * (self.dataArray.count / 3 + 1));
        }];
    }
    
    for (int i = 0; i < _dataArray.count; i++) {
        
        LittleWorldCategory *model = [_dataArray safeObjectAtIndex:i];
        
        UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        typeButton.backgroundColor = UIColorFromRGB(0xF8F7FA);
        typeButton.size = CGSizeMake((KScreenWidth - 40 - 26) / 3, (KScreenWidth - 40 - 26) / 3);
        typeButton.left = 20 + (typeButton.width + 13) * (i % 3);
        typeButton.top = 54 + (typeButton.height + 10) * (i / 3);
        typeButton.tag = 100 + i;
        [typeButton sd_setImageWithURL:[NSURL URLWithString:model.pict] forState:UIControlStateNormal];
        [typeButton setTitle:model.typeName forState:UIControlStateNormal];
        [typeButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        typeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        typeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        typeButton.imageFrame = [NSValue valueWithCGRect:CGRectMake((typeButton.width - 28) / 2, (typeButton.width - 58) / 2, 28, 28)];
        typeButton.titleFrame = [NSValue valueWithCGRect:CGRectMake(0, (typeButton.width - 58) / 2 + 28 + 15, typeButton.width, 15)];
        [typeButton addTarget:self action:@selector(typeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        typeButton.layer.cornerRadius = 12;
        typeButton.layer.masksToBounds = YES;
        [self.backView addSubview:typeButton];
    }
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UIColorFromRGB(0xffffff);
        _backView.layer.cornerRadius = 12;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"小世界分类";
        _titleLabel.textColor = UIColorFromRGB(0x000000);
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

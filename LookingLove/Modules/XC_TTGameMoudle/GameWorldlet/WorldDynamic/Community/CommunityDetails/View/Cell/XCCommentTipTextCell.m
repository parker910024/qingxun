//
//  XCCommentTipTextCell.m
//  UKiss
//
//  Created by apple on 2018/12/8.
//  Copyright © 2018 yizhuan. All rights reserved.
//

#import "XCCommentTipTextCell.h"
#import "UIView+NTES.h"
#import "XCTheme.h"
#import "XCMacros.h"

@interface XCCommentTipTextCell ()
///提示文本
@property (nonatomic, strong) UILabel *tipTextLab;
///删除按钮
@property (nonatomic, strong) UIButton *deleteBtn;
///分割线view
@property (nonatomic, strong) UIView *bottomSeparator;

@end

@implementation XCCommentTipTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.tipTextLab];
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.bottomSeparator];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tipTextLab.centerY = 39.f/ 2;
    self.tipTextLab.left = 14;
    self.deleteBtn.right = self.width;
    self.deleteBtn.centerY = self.tipTextLab.centerY;
    self.bottomSeparator.top = 39;
}


- (void)deleteButtonAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteCommentTipTextCellCallBack)]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:isNotFirstShowCommunityDetails];
        [defaults synchronize];
        [self.delegate deleteCommentTipTextCellCallBack];
    }
}


#pragma mark - getters and setters

- (UILabel *)tipTextLab {
    if (!_tipTextLab) {
        _tipTextLab = [[UILabel alloc]init];
        _tipTextLab.textColor = UIColorFromRGB(0x8986AA);
        _tipTextLab.font = [UIFont systemFontOfSize:13];
        _tipTextLab.text = @"长按评论可以复制、举报和删除哦";
        [_tipTextLab sizeToFit];
    }
    return _tipTextLab;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"data_pop_close"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.bounds = CGRectMake(0, 0, 44, 44);
    }
    return _deleteBtn;
}

- (UIView *)bottomSeparator {
    if (!_bottomSeparator) {
        _bottomSeparator = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
        _bottomSeparator.backgroundColor = UIColorRGBAlpha(0x222222, 0.2);
    }
    return _bottomSeparator;
}

@end

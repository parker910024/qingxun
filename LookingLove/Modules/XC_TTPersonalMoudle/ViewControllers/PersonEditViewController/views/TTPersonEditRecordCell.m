//
//  TTPersonEditRecordCell.m
//  TuTu
//
//  Created by Macx on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTPersonEditRecordCell.h"

//cate
#import "UIButton+EnlargeTouchArea.h"
//t
#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface TTPersonEditRecordCell()
@property (nonatomic, strong) UIView  *contianView;//
@property (nonatomic, strong) UIImageView  *arrow;//
@end

@implementation TTPersonEditRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contianView];
    [self.contentView addSubview:self.arrow];
    [self.contianView addSubview:self.recordTimeLabel];
    [self.contianView addSubview:self.recordBtn];

    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-15);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
    }];
    [self.contianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrow.mas_left).offset(-15);
        make.height.mas_equalTo(26);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.contianView);
    }];
    [self.recordTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.recordBtn.mas_right).offset(5);
        make.right.mas_equalTo(self.contianView).offset(-5);
        make.centerY.mas_equalTo(self.contianView);
    }];
}

#pragma mark - Event
- (void)playOrPause:(UIButton *)btn {
    !self.tapRecordBlock?:self.tapRecordBlock();
}


#pragma mark - Getter && Setter

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:20];
        [_recordBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
        [_recordBtn setImage:[UIImage imageNamed:@"person_edit_Play"] forState:UIControlStateNormal];
        [_recordBtn setImage:[UIImage imageNamed:@"person_edit_pasue"] forState:UIControlStateSelected];
    }
    return _recordBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    }
    return _titleLabel;
}

- (UILabel *)recordTimeLabel {
    if (!_recordTimeLabel) {
        _recordTimeLabel = [[UILabel alloc] init];
        _recordTimeLabel.textColor = [XCTheme getTTMainTextColor];
        _recordTimeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _recordTimeLabel;
}

- (UIView *)contianView {
    if (!_contianView) {
        _contianView = [[UIView alloc] init];
        _contianView.backgroundColor = UIColorFromRGB(0xEBEBEB);
//        _contianView.layer.masksToBounds
        _contianView.layer.cornerRadius = 13;
    }
    return _contianView;
}

- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_setting_arrow"]];
    }
    return _arrow;
}

@end

//
//  XCLabelCell.m
//  XChat
//
//  Created by 卫明何 on 2018/1/27.
//  Copyright © 2018年 XC. All rights reserved.
//

#import "TTSessionLabelCell.h"
#import <Masonry.h>
#import "XCTheme.h"

@interface TTSessionLabelCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TTSessionLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initConstraints];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (void)initView {
    [self.contentView addSubview:self.titleLabel];
}


#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _titleLabel;
}



@end

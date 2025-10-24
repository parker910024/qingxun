//
//  TTRedbagConditionListTableViewCell.m
//  AFNetworking
//
//  Created by ShenJun_Mac on 2020/5/15.
//

#import "TTRedbagConditionListTableViewCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"

@interface TTRedbagConditionListTableViewCell()

@end


@implementation TTRedbagConditionListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initContrations];
    }
    return self;
}

#pragma mark - private method
- (void)initView {
    self.backgroundColor = UIColorFromRGB(0xf9f9f9);
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 46)];
    self.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xeeeeee);
    
    [self addSubview:self.titleLabel];
}

- (void)initContrations {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(10.5);
    }];
}

#pragma mark - Setter && Getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = UIColorFromRGB(0x2C2C2E);
        _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}
@end

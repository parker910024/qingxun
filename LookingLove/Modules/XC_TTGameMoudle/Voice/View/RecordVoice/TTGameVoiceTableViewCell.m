//
//  TTGameVoiceTableViewCell.m
//  XC_TTGameMoudle
//
//  Created by fengshuo on 2019/6/18.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameVoiceTableViewCell.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"


@implementation TTGameVoiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor  =  [XCTheme getTTDeepGrayTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    
    }
    return _titleLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  TTPublicMessageTimestampCellTableViewCell.m
//  TuTu
//
//  Created by 卫明 on 2018/10/29.
//  Copyright © 2018 YiZhuan. All rights reserved.
//

#import "TTPublicMessageTimestampCell.h"

//tool
#import "NIMKitUtil.h"
#import <Masonry/Masonry.h>

@implementation TTPublicMessageTimestampCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _timeBackgroud = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_timeBackgroud];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont boldSystemFontOfSize:10.f];
        _timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
        
        [_timeBackgroud setImage:[[UIImage imageNamed:@"icon_session_time_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(8,20,8,20) resizingMode:UIImageResizingModeStretch]];
        [self initConstrations];
    }
    return self;
}

- (void)initConstrations {
    [self.timeBackgroud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.timeLabel.mas_leading).offset(-5);
        make.trailing.mas_equalTo(self.timeLabel.mas_trailing).offset(5);
        make.top.mas_equalTo(self.timeLabel.mas_top).offset(-5);
        make.bottom.mas_equalTo(self.timeLabel.mas_bottom).offset(5);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setModel:(TTTimestampModel *)model {
    _model = model;
    [_timeLabel setText:[NIMKitUtil showTime:model.messageTime showDetail:YES]];
}

@end

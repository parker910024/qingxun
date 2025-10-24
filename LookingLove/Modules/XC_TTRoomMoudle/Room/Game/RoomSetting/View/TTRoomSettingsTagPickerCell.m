//
//  TTRoomSettingsTagPickerCell.m
//  TuTu
//
//  Created by lvjunhang on 2018/11/7.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTRoomSettingsTagPickerCell.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "HomeTag.h"

#import <Masonry/Masonry.h>

@interface TTRoomSettingsTagPickerCell ()
@property (nonatomic, strong) UILabel *tagLabel;
@end

@implementation TTRoomSettingsTagPickerCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.08];
        self.layer.cornerRadius = 13;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.tagLabel];
        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)setHomeTag:(HomeTag *)homeTag {
    _homeTag = homeTag;
    
    self.tagLabel.text = homeTag.name;

}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    
    if (isSelect) {
        self.backgroundColor = [XCTheme getTTMainColor];
    } else {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.08];
    }
}

#pragma mark - Getter & Setter
- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = UIColor.whiteColor;
        _tagLabel.font = [UIFont systemFontOfSize:12];
    }
    return _tagLabel;
}

@end

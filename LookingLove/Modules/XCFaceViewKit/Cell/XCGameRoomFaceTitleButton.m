//
//  XCGameRoomFaceTitleButton.m
//  AFNetworking
//
//  Created by lvjunhang on 2018/11/27.
//

#import "XCGameRoomFaceTitleButton.h"

#import "XCTheme.h"
#import <Masonry/Masonry.h>

@interface XCGameRoomFaceTitleButton ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *underlineView;
@end

@implementation XCGameRoomFaceTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.underlineView];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
        }];
        
        [self.underlineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(2);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(9);
            make.height.mas_equalTo(2);
        }];
    }
    return self;
}

#pragma mark - Override
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.nameLabel.textColor = selected ? self.selectTitleColor : self.normalTitleColor;
    self.underlineView.hidden = !self.isShowUnderline || !selected;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    NSAssert(title, @"title can not be nil");
    self.nameLabel.text = title;
}

#pragma mark - Getter Setter
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = self.normalTitleColor;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIView *)underlineView {
    if (_underlineView == nil) {
        _underlineView = [[UIView alloc] init];
        _underlineView.backgroundColor = self.underlineColor;
        _underlineView.layer.cornerRadius = 2;
    }
    return _underlineView;
}

- (UIColor *)normalTitleColor {
    if (_normalTitleColor == nil) {
        _normalTitleColor = [UIColor colorWithWhite:1 alpha:0.4];
    }
    return _normalTitleColor;
}

- (UIColor *)selectTitleColor {
    if (_selectTitleColor == nil) {
        _selectTitleColor = [UIColor colorWithWhite:1 alpha:1];
    }
    return _selectTitleColor;
}

- (UIColor *)underlineColor {
    if (_underlineColor == nil) {
        _underlineColor = [XCTheme getMainDefaultColor];
    }
    return _underlineColor;
}

@end

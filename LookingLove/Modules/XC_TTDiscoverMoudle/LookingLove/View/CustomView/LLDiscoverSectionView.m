//
//  LLDiscoverSectionView.m
//  XC_TTDiscoverMoudle
//
//  Created by fengshuo on 2019/7/26.
//  Copyright © 2019 fengshuo. All rights reserved.
//

#import "LLDiscoverSectionView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
@interface LLDiscoverSectionView ()

/**家族星推荐 */
@property (nonatomic, strong) UILabel * nameLabel;

@end

@implementation LLDiscoverSectionView
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
        [self initConstrations];
    }
    return self;
}
#pragma mark - public methods

#pragma mark - private method
- (void)initView {
    [self addSubview:self.nameLabel];
}
- (void)initConstrations {

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self).offset(31);
    }];

}
#pragma mark - getters and setters
- (void)setSection:(NSInteger)section{
    _section = section;
    if (_section == LLDiscoverFamilyCellType_Charm) {
        self.nameLabel.text = @"家族星推荐";
    }else{
        self.nameLabel.text = @"我的家族";
    }
}


- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor  =  [XCTheme getTTMainTextColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _nameLabel;
}


@end

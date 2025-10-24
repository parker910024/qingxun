//
//  TTGameTagCustomButton.m
//  TTPlay
//
//  Created by new on 2019/3/26.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameTagCustomButton.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义

@implementation TTGameTagCustomButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initConstraint];
        
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)initView{
    [self addSubview:self.selectImageView];
}

- (void)initConstraint{
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
}


- (UIImageView *)selectImageView{
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"person_101_popup_pitch"];
        _selectImageView.hidden = YES;
    }
    return _selectImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

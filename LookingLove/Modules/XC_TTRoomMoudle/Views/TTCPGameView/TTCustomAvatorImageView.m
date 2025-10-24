//
//  TTCustomAvatorImageView.m
//  TuTu
//
//  Created by new on 2019/1/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCustomAvatorImageView.h"

@implementation TTCustomAvatorImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.maskImageView];
    }
    return self;
}

- (void)layoutSubviews{
    _maskImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

- (UIImageView *)maskImageView{
    if (!_maskImageView) {
        _maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _maskImageView.image = [UIImage imageNamed:@"room_cpGame_mask"];
        _maskImageView.hidden = YES;
    }
    return _maskImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

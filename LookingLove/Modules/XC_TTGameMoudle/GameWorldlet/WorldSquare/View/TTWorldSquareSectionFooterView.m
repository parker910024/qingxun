//
//  TTWorldSquareSectionFooterView.m
//  XC_TTGameMoudle
//
//  Created by lvjunhang on 2019/6/28.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTWorldSquareSectionFooterView.h"

#import "XCTheme.h"

#import <Masonry/Masonry.h>

@implementation TTWorldSquareSectionFooterView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorFromRGB(0xf4f4f4);
        [self addSubview:self.lineView];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self).inset(15);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}

@end

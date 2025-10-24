//
//  TTParentPasswordLabel.m
//  AFNetworking
//
//  Created by User on 2019/5/5.
//

#import "TTParentPasswordLabel.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义

@implementation TTParentPasswordLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = UIColorFromRGB(0xcccccc);
        bottomView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 2);
//        [self addSubview:bottomView];
        self.layer.borderWidth = 2;
        self.layer.borderColor = [XCTheme getTTMainTextColor].CGColor;
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.textColor = [XCTheme getTTMainTextColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

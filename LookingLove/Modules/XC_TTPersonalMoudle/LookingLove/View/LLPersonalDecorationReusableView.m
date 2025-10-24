//
//  LLPersonalDecorationReusableView.m
//  AFNetworking
//
//  Created by lee on 2019/7/25.
//

#import "LLPersonalDecorationReusableView.h"
@interface LLPersonalDecorationReusableView ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation LLPersonalDecorationReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){

        _bgView = [[UIView alloc] initWithFrame:frame];
    
        _bgView.backgroundColor = UIColor.greenColor;
        [self addSubview:_bgView];
    }
    return self;
}

@end

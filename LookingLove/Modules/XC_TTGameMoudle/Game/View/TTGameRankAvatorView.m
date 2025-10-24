//
//  TTGameRankAvatorView.m
//  TTPlay
//
//  Created by new on 2019/3/7.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTGameRankAvatorView.h"
#import "UIView+NTES.h"
#import "XCMacros.h"
#import "UIColor+UIColor_Hex.h" // 颜色设置
#import "UIImageView+QiNiu.h"

#define kScale(x) ((x) / 375.0 * KScreenWidth)

@interface TTGameRankAvatorView ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation TTGameRankAvatorView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.nameLabel];
        [self addSubview:self.centerImageView];
        [self addSubview:self.thirdImageView];
        [self addSubview:self.secondImageView];
        [self addSubview:self.firstImageView];
        
        self.imageArray = [NSMutableArray array];
        [self.imageArray addObject:self.firstImageView];
        [self.imageArray addObject:self.secondImageView];
        [self.imageArray addObject:self.thirdImageView];
        
    }
    return self;
}

- (void)configWithGameName:(NSString *)gameName ImageArray:(NSArray *)avatorArray Success:(void (^)(BOOL success))success{
    
    self.nameLabel.text = gameName;
    
    [self.nameLabel sizeToFit];
    self.nameLabel.centerY = self.height / 2;
    self.centerImageView.left = self.nameLabel.right + 5;
    
    NSMutableArray *tampArray = [NSMutableArray array];
    for (int i = 0; i < avatorArray.count; i++) {
        UIImageView *customImage = self.imageArray[(self.imageArray.count - 1 - i)];
        customImage.hidden = NO;
        [customImage qn_setImageImageWithUrl:avatorArray[avatorArray.count - 1 - i][@"avatar"] placeholderImage:@"game_home_itemBg" type:(ImageType)ImageTypeUserLibaryDetail success:^(UIImage *image) {
            if (i == avatorArray.count - 1) {
                if (success) {
                    success(YES);
                }
            }
        }];
    }
    
}


- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _nameLabel.left = 0;
        _nameLabel.font = [UIFont systemFontOfSize:19];
    }
    return _nameLabel;
}


- (UIImageView *)centerImageView{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] init];
        _centerImageView.image = [UIImage imageNamed:@"home_ranking_img"];
        _centerImageView.size = CGSizeMake(kScale(52), kScale(32));
        _centerImageView.centerY = self.height / 2;
    }
    return _centerImageView;
}

- (UIImageView *)thirdImageView{
    if (!_thirdImageView) {
        _thirdImageView = [[UIImageView alloc] init];
        _thirdImageView.size = CGSizeMake(32, 32);
        _thirdImageView.right = self.width - 15;
        _thirdImageView.centerY = self.height / 2;
        _thirdImageView.layer.cornerRadius = 16;
        _thirdImageView.layer.masksToBounds = YES;
        _thirdImageView.layer.borderWidth = 1.5;
        _thirdImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        _thirdImageView.hidden = YES;
    }
    return _thirdImageView;
}

- (UIImageView *)secondImageView{
    if (!_secondImageView) {
        _secondImageView = [[UIImageView alloc] init];
        _secondImageView.size = CGSizeMake(32, 32);
        _secondImageView.right = _thirdImageView.left + 6;
        _secondImageView.centerY = self.height / 2;
        _secondImageView.layer.cornerRadius = 16;
        _secondImageView.layer.masksToBounds = YES;
        _secondImageView.layer.borderWidth = 1.5;
        _secondImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        _secondImageView.hidden = YES;
    }
    return _secondImageView;
}


- (UIImageView *)firstImageView{
    if (!_firstImageView) {
        _firstImageView = [[UIImageView alloc] init];
        _firstImageView.size = CGSizeMake(32, 32);
        _firstImageView.right = _secondImageView.left + 6;
        _firstImageView.centerY = self.height / 2;
        _firstImageView.layer.cornerRadius = 16;
        _firstImageView.layer.masksToBounds = YES;
        _firstImageView.layer.borderWidth = 1.5;
        _firstImageView.layer.borderColor = UIColor.whiteColor.CGColor;
        _firstImageView.hidden = YES;
    }
    return _firstImageView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

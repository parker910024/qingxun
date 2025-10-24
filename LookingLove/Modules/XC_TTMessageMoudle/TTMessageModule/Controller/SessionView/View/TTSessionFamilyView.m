//
//  XC_MSSessionFamilyView.m
//  XC_MSMessageMoudle
//
//  Created by gzlx on 2018/10/25.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTSessionFamilyView.h"
#import "XCFamily.h"
#import "FamilyCore.h"
#import "UIImageView+QiNiu.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMediator+TTDiscoverModuleBridge.h"

@interface TTSessionFamilyView()
@property (strong, nonatomic) UILabel *familyLabel;
@property (strong, nonatomic) UIImageView *familyAvatar;
@property (strong, nonatomic) XCFamily *family;
@end

@implementation TTSessionFamilyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.family = [GetCore(FamilyCore)getFamilyModel];
        [self initView];
        [self initConstrations];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = UIColorRGBAlpha(0x000000, 0.5);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToFamilyDetail)];
    [self addGestureRecognizer:tapGesture];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 15.f;
    
    self.familyAvatar.layer.masksToBounds = YES;
    self.familyAvatar.layer.cornerRadius = 13.f;
    self.familyAvatar.userInteractionEnabled = NO;
    
    self.familyLabel.userInteractionEnabled = NO;
    
    [self addSubview:self.familyLabel];
    [self addSubview:self.familyAvatar];
    [self.familyAvatar qn_setImageImageWithUrl:self.family.familyIcon placeholderImage:[[XCTheme defaultTheme] default_avatar] type:(ImageType)ImageTypeUserIcon];
}

- (void)initConstrations {
    [self.familyAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).offset(2);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(26);
        make.height.mas_equalTo(26);
    }];
    [self.familyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.familyAvatar.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

#pragma mark  - Private

- (void)pushToFamilyDetail {
    BOOL hadOldPage = NO;
    for (UIViewController *item in self.navigationController.viewControllers) {
        if ([item isKindOfClass:NSClassFromString(@"TTFamilyPersonViewController")]) {
            UIViewController *vc = (UIViewController *)item;
            if ([[NSString stringWithFormat:@"%ld", (NSInteger)[vc valueForKey:@"familyId"]] isEqualToString:self.family.familyId]) {
                [vc setValue:@(YES) forKey:@"isReload"];
                [vc setValue:self.family.familyId forKey:@"familyId"];
            }
            [self.navigationController popToViewController:item animated:YES];
            hadOldPage = YES;
            break;
        }
    }
    if (!hadOldPage) {
        UIViewController * vc =  [[XCMediator sharedInstance] ttDiscoverMoudle_TTFamilyPersonViewController:self.family.familyId.userIDValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - getter

- (UILabel *)familyLabel {
    if (!_familyLabel) {
        _familyLabel = [[UILabel alloc]init];
        _familyLabel.textColor = UIColorFromRGB(0xffffff);
        _familyLabel.font = [UIFont systemFontOfSize:13.f];
        _familyLabel.text = @"我的家族";
    }
    return _familyLabel;
}


- (UIImageView *)familyAvatar {
    if (!_familyAvatar) {
        _familyAvatar = [[UIImageView alloc]init];
    }
    return _familyAvatar;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

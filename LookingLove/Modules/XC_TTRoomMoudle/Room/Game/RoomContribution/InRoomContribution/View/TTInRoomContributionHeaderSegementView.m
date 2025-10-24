//
//  XC_MSHeaderSegementView.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/10/16.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTInRoomContributionHeaderSegementView.h"
#import "XCTheme.h"
#import "UIImage+Utils.h"

@interface TTInRoomContributionHeaderSegementView()

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIButton  *selectedButton;

@end

@implementation TTInRoomContributionHeaderSegementView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items {
    self.items = items;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 0.2);
        [self setupSubviews];
    }
    return self;
}

#pragma mark - event response
- (void)selectedSegmentControl:(UIButton *)button {
    
    if (self.selectedButton == button) return;
    
    self.selectedButton.selected = NO;
    button.selected = YES;
    
    self.selectedButton = button;
    
    if (self.segmentControlSelectedItem) {
        self.segmentControlSelectedItem((RankType)button.tag);
    }
}

#pragma mark - Private
- (void)setupSubviews {
    
    int count = self.items.count;
    CGFloat segmentW = self.frame.size.width;
    CGFloat segmentH = self.frame.size.height;
    CGFloat margin = 2;
    CGFloat itemW = (segmentW - (count+1)*margin)/count;
    CGFloat itemH = segmentH - margin*2;
    
    for (int i = 0; i<count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [button setTitle:self.items[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(selectedSegmentControl:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:UIColorRGBAlpha(0xffffff, 0.5) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x759EF0) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.frame = CGRectMake(margin+(itemW+margin)*i, margin, itemW, itemH);
        button.layer.cornerRadius = itemH/2.0;
        button.layer.masksToBounds = YES;
        
        UIImage *image = [UIImage imageWithColor:UIColor.whiteColor size:CGSizeMake(itemW, itemH)];
        [button setBackgroundImage:image forState:UIControlStateSelected];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        
        if (i == 0) {
            [self selectedSegmentControl:button];
        }
        
        [self addSubview:button];
    }
}

@end

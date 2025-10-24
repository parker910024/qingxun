//
//  TTDiscoverHeaderView.m
//  TuTu
//
//  Created by gzlx on 2018/10/29.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "TTDiscoverHeaderView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "BannerInfo.h"
#import "NSArray+Safe.h"
#import "XCMediator+TTRoomMoudleBridge.h"
#import "TTWKWebViewViewController.h"
#import "AuthCore.h"
#import "XCMediator+TTPersonalMoudleBridge.h"
@implementation TTDiscoverHeaderView
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public method
/** 配置bannders*/
- (void)configTTDiscoverHeaderView:(NSArray *)bannders{
    self.banners = bannders;
    NSMutableArray * array = [NSMutableArray array];
    for (BannerInfo *model in bannders) {
        [array addObject:model.bannerPic];
    }
    self.cycleView.imageURLStringsGroup = array;
    if (array.count > 1) {
        self.cycleView.autoScroll = YES;
    }
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.banners.count <= 0) {
        return;
    }
    BannerInfo * infor =    [self.banners safeObjectAtIndex:index];
    if (infor.skipType == BannerInfoSkipTypeWeb) {
        TTWKWebViewViewController *vc = [[TTWKWebViewViewController alloc]init];
        NSString *url = nil;
        if ([infor.skipUri containsString:@"?"]) {
            url = [NSString stringWithFormat:@"%@&uid=%@",infor.skipUri,[GetCore(AuthCore)getUid]];
        }else{
            url = [NSString stringWithFormat:@"%@?uid=%@",infor.skipUri,[GetCore(AuthCore)getUid]];
        }
        vc.url = [NSURL URLWithString:url];
        [self.currentVC.navigationController pushViewController:vc animated:YES];
    }else if (infor.skipType == BannerInfoSkipTypeRoom) {
        [[XCMediator sharedInstance] ttRoomMoudle_presentRoomViewControllerWithRoomUid:infor.skipUri.userIDValue];
    }else if (infor.skipType == BannerInfoSkipTypePage){
        if ([infor.skipUri isEqualToString:@"1"]) {
    
        }else if ([infor.skipUri isEqualToString:@"2"]){
            UIViewController * controllerVC =  [[XCMediator sharedInstance] ttPersonalModule_DressUpShopViewControllerWithUid:0 index:0];
            [self.currentVC.navigationController pushViewController:controllerVC animated:YES];
        }
    }
}

#pragma mark - private method
- (void)initView {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.cycleView];
}
- (void)initConstrations {
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(120);
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
    }];
}
#pragma mark - getters and setters
- (SDCycleScrollView *)cycleView{
    if (!_cycleView) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:[[XCTheme defaultTheme] placeholder_image_rectangle]]];
        _cycleView.backgroundColor = [XCTheme getDefaultBgColor];
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentLeft;
        _cycleView.currentPageDotColor = [UIColor whiteColor];
        _cycleView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.4];
        _cycleView.currentPageDotImage = [UIImage imageNamed:@"home_banner_select"];
        _cycleView.pageDotImage = [UIImage imageNamed:@"home_banner_normal"];
        _cycleView.layer.cornerRadius = 21;
        _cycleView.layer.masksToBounds = YES;
        
    }
    return _cycleView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

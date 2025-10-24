//
//  XCRoomActivityView.m
//  XCRoomMoudle
//
//  Created by KevinWang on 2018/8/27.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//

#import "XCRoomActivityView.h"
//core
#import "ActivityCore.h"
#import "ActivityCoreClient.h"
#import "VersionCore.h"
//t
#import "UIImageView+QiNiu.h"

@interface XCRoomActivityView()<ActivityCoreClient>

@property (nonatomic, strong) ActivityInfo *activityInfo;

@end

@implementation XCRoomActivityView

#pragma mark - Life Style
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addCore];
        [self setupSubviews];
        [self setupSubviewsConstraints];
    }
    return self;
}


#pragma mark - ActivityCoreClient
- (void)getActivityInfoSuccess {
    self.activityInfo = GetCore(ActivityCore).activityInfo;
    self.userInteractionEnabled = self.activityInfo == nil ? NO : YES;
    if (self.activityInfo) {
        [self qn_setImageImageWithUrl:self.activityInfo.alertWinPic placeholderImage:nil type:ImageTypeHomePageItem];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(activitySkip)];
        [self addGestureRecognizer:tap];
    }
}

#pragma mark - event response
- (void)activitySkip{
    if ([self.delegate respondsToSelector:@selector(roomActivityView:jumbByActivityInfo:)]) {
        [self.delegate roomActivityView:self jumbByActivityInfo:self.activityInfo];
    }
}

#pragma mark - Private
- (void)addCore{
    [GetCore(ActivityCore) getActivity:2];
    AddCoreClient(ActivityCoreClient, self);
}

- (void)setupSubviews{

    self.contentMode = UIViewContentModeScaleAspectFit;
}
- (void)setupSubviewsConstraints{
    
}

#pragma mark - Getter


@end

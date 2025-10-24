//
//  TTRoomActivityCycleView.m
//  TTPlay
//
//  Created by lee on 2019/2/20.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTRoomActivityCycleView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIImageView+QiNiu.h"
// core
#import "ActivityCore.h"
#import "ActivityCoreClient.h"
#import "RoomCoreV2.h"
// model
#import "ActivityInfo.h"
//tool
#import "SDCycleScrollView.h"
#import "TTStatisticsService.h"

#import "TTGameActivityCollectionViewCell.h"

@interface TTRoomActivityCycleView ()<SDCycleScrollViewDelegate, ActivityCoreClient>
{
    dispatch_source_t timer;
}

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) ActivityInfo *activityInfo;
@property (nonatomic, strong) NSMutableArray<ActivityInfo *> *dataArray;
@property (nonatomic, strong) UIButton *hotSpotBtn; // 高能倒计时

@property (nonatomic, strong) NSMutableArray<ActivityInfo *> *topLeftList;
@property (nonatomic, strong) NSMutableArray<ActivityInfo *> *bottmRightList;

@end

@implementation TTRoomActivityCycleView

- (instancetype)initWithType:(ActivityPositionType)type
{
    self = [super init];
    if (self) {
        _type = type;
        
        [self addCore];
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark -
#pragma mark lifeCycle
- (void)dealloc {
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
}

- (void)initViews {
    [self addSubview:self.cycleScrollView];
}

- (void)initConstraints {
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    // 在左上角的时候，才显示高能倒计时
    if (self.type == ActivityPositionTypeTopLeft) {
        [self addSubview:self.hotSpotBtn];
        [self.hotSpotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(10);
            make.height.mas_equalTo(21);
            make.width.mas_equalTo(60);
            make.centerX.mas_equalTo(self);
        }];
    }
}

#pragma mark - ActivityCoreClient
- (void)getActivityInfoListWithGameRoomSuccess:(ActivityContainInfo *)list {
    NSMutableArray *bottomRightArray = [NSMutableArray array];
    NSMutableArray *topLeftArray = [NSMutableArray array];
    [self.dataArray removeAllObjects];
    
    [list.list enumerateObjectsUsingBlock:^(ActivityInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        if (obj.entrancePosition == EntrancePositionTypeTopLeft) {
            // 左上角数据
            [self.topLeftList addObject:obj];
            [topLeftArray addObject:obj.alertWinPic];
            
        } else if (obj.entrancePosition == EntrancePositionTypeBottomRight ||
                   obj.entrancePosition == EntrancePositionTypeUndefined) {
            // 右下角数据
            [self.bottmRightList addObject:obj];
            [bottomRightArray addObject:obj.alertWinPic];
        }
    }];
    
    NSMutableArray *array = _type == ActivityPositionTypeTopLeft ? topLeftArray : bottomRightArray;
    
    self.cycleScrollView.imageURLStringsGroup = array;
    
    if (array.count > 1) {
        [self.cycleScrollView setAutoScroll:YES];
        self.cycleScrollView.autoScrollTimeInterval = list.rotateInterval;
    } else {
        [self.cycleScrollView setAutoScroll:NO];
    }
}

/// 获取暴击倒计时
/// @param runawayTime 暴击倒计时执行时间
/// @param limitTime 持续时间
/// @param code 错误码
/// @param msg 错误消息
- (void)getActivityRunawayTimeSuccess:(NSTimeInterval)runawayTime limitTime:(NSInteger)limitTime code:(NSInteger)code msg:(NSString *)msg {
    
    if (self.type == ActivityPositionTypeBottomRight) {
        return;
    }
    
    if (code && msg) {
        return;
    }
    
    if (limitTime == 0) { // 倒计时为 0 时不需要倒计时
        // 如果0秒就隐藏并停止高能倒计时
        [self stopTimeCountDown];
        return;
    }
    
    [self countDownTimer:limitTime];
}

#pragma mark - event response
- (void)activitySkip{
//    if ([self.delegate respondsToSelector:@selector(roomActivityView:jumbByActivityInfo:)]) {
//        [self.delegate roomActivityView:self jumbByActivityInfo:self.activityInfo];
//    }
}

- (void)requestDataWithActivity {
    if (GetCore(RoomCoreV2).getCurrentRoomInfo) {
        [GetCore(ActivityCore) getActivityForGamePage:2];
        
        if (self.type == ActivityPositionTypeTopLeft) {
            [GetCore(ActivityCore) getActivityRunawayTime:GetCore(RoomCoreV2).getCurrentRoomInfo.uid];
        }
    }
}

#pragma mark - Private
- (void)addCore{
    AddCoreClient(ActivityCoreClient, self);
    [self requestDataWithActivity];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(roomActivityListView:jumbByActivityInfo:)]) {
        
        self.dataArray = _type == ActivityPositionTypeTopLeft ? self.topLeftList : self.bottmRightList;
        
        if (self.dataArray.count > index) {
            
            ActivityInfo *info = self.dataArray[index];
            [self.delegate roomActivityListView:self jumbByActivityInfo:self.dataArray[index]];
            
            NSString *eventStr = _type == ActivityPositionTypeBottomRight ? @"room_activity_entrance_b" : @"room_activity_entrance";
            [TTStatisticsService trackEvent:eventStr eventDescribe:[NSString stringWithFormat:@"点击房间内左上角活动入口的次数--%@", info.actName]];
        }
    }
}

#pragma mark -
#pragma mark clients

#pragma mark -
#pragma mark private methods
- (void)countDownTimer:(NSInteger)seconds {
    
    if (seconds == 0) {
        // 如果0秒就隐藏并停止高能倒计时
        [self stopTimeCountDown];
        return;
    }
    
     //开始倒计时
    __block NSInteger time = seconds; //倒计时时间
    
   //开始倒计时
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(timer, ^{
        
        if (time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(self->timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                self.hotSpotBtn.hidden = YES;
            });
            
        } else {
            
//            int seconds = limitTime % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                self.hotSpotBtn.hidden = NO;
                [self.hotSpotBtn setTitle:[NSString stringWithFormat:@" %ld秒", (long)time] forState:UIControlStateNormal];
            });
            time--;
        }
    });
    
    dispatch_resume(timer);
}

/// 停止时间倒计时
- (void)stopTimeCountDown {
    
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
    
    self.hotSpotBtn.hidden = YES;
}
#pragma mark -
#pragma mark button click events

#pragma mark -
#pragma mark getter & setter

- (NSMutableArray<ActivityInfo *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray<ActivityInfo *> *)topLeftList {
    if (!_topLeftList) {
        _topLeftList = [NSMutableArray array];
    }
    return _topLeftList;
}

- (NSMutableArray<ActivityInfo *> *)bottmRightList {
    if (!_bottmRightList) {
        _bottmRightList = [NSMutableArray array];
    }
    return _bottmRightList;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        _cycleScrollView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.4];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"home_banner_select"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"home_banner_normal"];
        _cycleScrollView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.00];
//        _cycleScrollView.autoScroll = NO;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _cycleScrollView.pageControlBottomOffset = -20;
//        _cycleScrollView.pageControlDotSize = CGSizeMake(30, 4);
    }
    return _cycleScrollView;
}

- (UIButton *)hotSpotBtn {
    if (!_hotSpotBtn) {
        _hotSpotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hotSpotBtn setTitleColor:UIColorFromRGB(0xFFF044) forState:UIControlStateNormal];
        [_hotSpotBtn setImage:[UIImage imageNamed:@"hotSpotBtn_clockIcon"] forState:UIControlStateNormal];
        [_hotSpotBtn setTitle:@" 100秒" forState:UIControlStateNormal];
        [_hotSpotBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        _hotSpotBtn.backgroundColor = UIColorFromRGB(0xFA524D);
        _hotSpotBtn.layer.cornerRadius = 21/2;
        _hotSpotBtn.layer.masksToBounds = YES;
        _hotSpotBtn.hidden = YES;
        _hotSpotBtn.userInteractionEnabled = NO;
    }
    return _hotSpotBtn;
}
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    return [TTGameActivityCollectionViewCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    
    TTGameActivityCollectionViewCell *myCell = (TTGameActivityCollectionViewCell *)cell;
    
    self.dataArray = _type == ActivityPositionTypeTopLeft ? self.topLeftList : self.bottmRightList;
    
    [myCell configWithUrlStr:self.dataArray[index]];
}

@end

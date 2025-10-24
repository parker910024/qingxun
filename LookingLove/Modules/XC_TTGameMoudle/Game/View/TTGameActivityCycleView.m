//
//  TTGameActivityCycleView.m
//  AFNetworking
//
//  Created by User on 2019/5/6.
//

#import "TTGameActivityCycleView.h"
#import <Masonry/Masonry.h>
#import "XCTheme.h"
#import "XCMacros.h"
#import "UIView+ZJFrame.h"
#import "UIImageView+QiNiu.h"
// core
#import "ActivityCore.h"
#import "ActivityCoreClient.h"
#import "AuthCore.h"
// model
#import "ActivityInfo.h"
//tool
#import "SDCycleScrollView.h"

#import "TTGameActivityCollectionViewCell.h"

@interface TTGameActivityCycleView ()<SDCycleScrollViewDelegate, ActivityCoreClient>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) ActivityInfo *activityInfo;
@property (nonatomic, strong) NSArray<ActivityInfo *> *infoList;
@property (nonatomic, strong) NSMutableArray<ActivityInfo *> *dataArray;

@end

@implementation TTGameActivityCycleView

- (instancetype)init
    {
        self = [super init];
        if (self) {
            [self addCore];
            [self initViews];
            [self initConstraints];
        }
        return self;
    }
    
#pragma mark -
#pragma mark lifeCycle
- (void)initViews {
    [self addSubview:self.cycleScrollView];
}
    
- (void)initConstraints {
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (NSMutableArray<ActivityInfo *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
    
#pragma mark - ActivityCoreClient
- (void)getActivityInfoListWithGamePageSuccess:(ActivityContainInfo *)list {
    NSMutableArray *array = [NSMutableArray array];
    [self.dataArray removeAllObjects];
    [list.list enumerateObjectsUsingBlock:^(ActivityInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.alertWinPic];
        [self.dataArray addObject:obj];
    }];
    self.cycleScrollView.imageURLStringsGroup = array;
    if (array.count > 1) {
        [self.cycleScrollView setAutoScroll:YES];
        self.cycleScrollView.autoScrollTimeInterval = list.rotateInterval;
    } else {
        [self.cycleScrollView setAutoScroll:NO];
    }
    self.infoList = list.list;
}
    
#pragma mark - event response
- (void)activitySkip{
    //    if ([self.delegate respondsToSelector:@selector(roomActivityView:jumbByActivityInfo:)]) {
    //        [self.delegate roomActivityView:self jumbByActivityInfo:self.activityInfo];
    //    }
}
    
#pragma mark - Private
- (void)addCore{
    AddCoreClient(ActivityCoreClient, self);
    if (![GetCore(AuthCore) isLogin]) {
        return;
    }
    [GetCore(ActivityCore) getActivityForGamePage:1];
}
    
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(roomActivityListView:jumbByActivityInfo:)]) {
        if (self.infoList.count > index) {
            [self.delegate roomActivityListView:self jumbByActivityInfo:self.infoList[index]];
        }
    }
}
    
#pragma mark -
#pragma mark clients
    
#pragma mark -
#pragma mark private methods
    
#pragma mark -
#pragma mark button click events
    
#pragma mark -
#pragma mark getter & setter
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
    
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
        return [TTGameActivityCollectionViewCell class];
}
    
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    
    TTGameActivityCollectionViewCell *myCell = (TTGameActivityCollectionViewCell *)cell;
    
    [myCell configWithUrlStr:self.dataArray[index]];
}
    
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

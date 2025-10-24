//
//  TTHomeRecommendHeadlineCell.m
//  TuTu
//
//  Created by lvjunhang on 2018/10/30.
//  Copyright © 2018年 YiZhuan. All rights reserved.
//  首页推荐头条

#import "TTHomeRecommendHeadlineCell.h"
#import "TTHomeRecommendHeadlineCollectionCell.h"

//#import "TTHomeRecommendViewProtocol.h"

#import "SDCycleScrollView.h"
#import <Masonry/Masonry.h>

#import "XCMacros.h"
#import "XCTheme.h"
#import "NSArray+Safe.h"
#import "TTHomeRecommendData.h"
#import "TTHomeRecommendDetailData.h"
#import "DiscoveryHeadLineNews.h"

static CGFloat kCycleScrollViewHeight = 70;

@interface TTHomeRecommendHeadlineCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) UIView *topSepView;
@property (nonatomic, strong) UIView *bottomSepView;
@property (nonatomic, strong) UIImageView *headLineImg;
@property (nonatomic, strong) SDCycleScrollView *cycleView;

@property (nonatomic, strong) NSMutableArray *dataSource;//每页的数据源
@property (nonatomic, assign) int page;//总共有几页
@end

@implementation TTHomeRecommendHeadlineCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

#pragma mark - SDCycleScrollViewDelegate
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    if (view != _cycleView) {
        return nil;
    }
    
    return [TTHomeRecommendHeadlineCollectionCell class];
}

/** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    TTHomeRecommendHeadlineCollectionCell *headlineCell = (TTHomeRecommendHeadlineCollectionCell *)cell;
    headlineCell.modelArray = [self.dataSource safeObjectAtIndex:index];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCellDidSelectLineNewsCellAction)]) {
        [self.delegate onCellDidSelectLineNewsCellAction];
    }
}

#pragma mark - privite
- (void)setUpView {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
//    self.selectionStyle = NO;
    [self.contentView addSubview:self.topSepView];
    [self.contentView addSubview:self.headLineImg];
    [self.contentView addSubview:self.cycleView];
    [self.contentView addSubview:self.bottomSepView];
    
    [self.headLineImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.topSepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(0);
    }];
    [self.bottomSepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self);
        make.height.mas_equalTo(0);
    }];
}

- (NSMutableArray *)checkArray:(NSArray<DiscoveryHeadLineNews *> *)array {
    
    NSMutableArray *modelArray = [NSMutableArray array];
    NSMutableArray *tempArray  = [NSMutableArray arrayWithCapacity:2];
    
    for (int i = 0 ; i < array.count; i++) {
        DiscoveryHeadLineNews * model = array[i];
        if (i %2 == 0 && i >0) {
            tempArray = [NSMutableArray array];
        }
        
        [tempArray addObject:model];
        
        if (tempArray.count == 2) {
            [modelArray addObject:tempArray];
        } else {
            //为了计算奇数个的时候
            if ((i %2 == 0) && (i == array.count - 1)) {
                [modelArray addObject:tempArray];
            }
        }
    }
    
    return modelArray;
}

#pragma mark - getter setter
- (void)setDataModel:(TTHomeRecommendData *)dataModel {
    _dataModel = dataModel;
    
    if (dataModel.type != TTHomeRecommendDataTypeHeadline || dataModel.data.count == 0) {
        return;
    }
    
    [self.dataSource removeAllObjects];
    
    self.dataSource = [self checkArray:dataModel.data];
    if (self.dataSource.count > 0) {
        //MARK:使用SDCycle的时候 返回自定的cell的时候 如果不给imageURLStringsGroup赋值的话 SDCycle无法显示  这可能是他们的一个bug
        NSMutableArray *imageArray = [NSMutableArray array];;
        for (int i = 0; i < self.dataSource.count; i++) {
            [imageArray addObject:@"home_headline"];
        }
        self.cycleView.imageURLStringsGroup = imageArray;
    }
}

- (void)setLineNews:(NSArray<DiscoveryHeadLineNews *> *)lineNews {
    self.dataSource = [self checkArray:lineNews];
    if (self.dataSource.count > 0) {
        //MARK:使用SDCycle的时候 返回自定的cell的时候 如果不给imageURLStringsGroup赋值的话 SDCycle无法显示  这可能是他们的一个bug
        NSMutableArray *imageArray = [NSMutableArray array];;
        for (int i = 0; i < self.dataSource.count; i++) {
            [imageArray addObject:@"home_headline"];
        }
        self.cycleView.imageURLStringsGroup = imageArray;
    }
}

- (SDCycleScrollView * )cycleView {
    if (_cycleView == nil) {
        CGFloat width =0;
        if (projectType() == ProjectType_LookingLove || projectType() == ProjectType_Planet) {
            width = 40;
        }
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(63, 0, KScreenWidth - 63- width, kCycleScrollViewHeight) delegate:self placeholderImage:nil];
        _cycleView.showPageControl = NO;
        _cycleView.backgroundColor = [UIColor whiteColor];
        [_cycleView disableScrollGesture];
        _cycleView.autoScrollTimeInterval = 4.5;
        _cycleView.scrollDirection =UICollectionViewScrollDirectionVertical;
    }
    return _cycleView;
}

- (UIImageView *)headLineImg {
    if (_headLineImg == nil) {
        _headLineImg = [[UIImageView alloc] init];
        _headLineImg.image = [UIImage imageNamed:@"home_headline"];
        _headLineImg.userInteractionEnabled = YES;
    }
    return _headLineImg;
}

- (UIView *)topSepView {
    if (_topSepView == nil) {
        _topSepView = [[UIView alloc] init];
        _topSepView.backgroundColor = [UIColor clearColor];
    }
    return _topSepView;
}

- (UIView *)bottomSepView {
    if (_bottomSepView == nil) {
        _bottomSepView = [[UIView alloc] init];
        _bottomSepView.backgroundColor = [UIColor clearColor];
    }
    return _bottomSepView;
}

-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

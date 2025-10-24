//
//  TTMasterAdvertisementView.m
//  TTPlay
//
//  Created by Macx on 2019/1/16.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTMasterAdvertisementView.h"

#import "MasterAdvertisementModel.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import <Masonry/Masonry.h>

@interface TTMasterAdvertisementView ()

@property (assign, nonatomic) int titleIndex;
@property (strong, nonatomic) dispatch_source_t timer;

@property (nonatomic, strong) NSMutableArray *titles;

/** currentButton */
@property (nonatomic, strong) UILabel *currentLabel;
/** leftIconImageView */
@property (nonatomic, strong) UIImageView *leftIconImageView;
@end

@implementation TTMasterAdvertisementView

#pragma mark - life cycle
- (void)dealloc {
    [self stopCountDown];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
        [self initConstrations];
    }
    return self;
}

#pragma mark - public methods

#pragma mark - [系统控件的Protocol]   //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [自定义控件的Protocol] //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - [core相关的Protocol]  //注意要把名字改掉，这个MARK只做功能划分，不是一个真正的MARK，每个不一样的Protocol，需要一个新的MARK”

#pragma mark - event response
- (void)nextAd {
    UILabel *firstBtn = self.currentLabel;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(26, self.bounds.size.height, KScreenWidth - 2 * 30, self.bounds.size.height)];
    
    NSAttributedString *attString = [self.titles safeObjectAtIndex:(self.titleIndex + 1)];
    if (attString.length == 0) {
        self.titleIndex = -1;
        attString = [self.titles safeObjectAtIndex:(self.titleIndex + 1)];
    }
    
    label.attributedText = attString;
    [self addSubview:label];
    
    CGRect firstBtnFrame = firstBtn.frame;
    firstBtnFrame.origin.y = -self.bounds.size.height;
    CGRect modelBtnFrame = label.frame;
    modelBtnFrame.origin.y = 0;
    [UIView animateWithDuration:0.25 animations:^{
        firstBtn.frame = firstBtnFrame;
        label.frame = modelBtnFrame;
    } completion:^(BOOL finished) {
        [firstBtn removeFromSuperview];
    }];
    
    self.currentLabel = label;
    self.titleIndex = self.titleIndex + 1;
}

#pragma mark - private method

- (void)initView {
    [self addSubview:self.leftIconImageView];
}

- (void)initConstrations {
    [self.leftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(22);
    }];
}

- (void)stopCountDown {
    __weak __typeof(self) weakSelf = self;
    if (self.timer != nil) {
        dispatch_source_cancel(weakSelf.timer);
        _timer = nil;
    }
}

- (void)openCountdownWithTime {
    
    __weak __typeof(self) weakSelf = self;
    if (weakSelf.timer != nil) {
        dispatch_source_cancel(weakSelf.timer);
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    weakSelf.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(weakSelf.timer,dispatch_walltime(NULL, 0),2.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(weakSelf.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf nextAd];
        });
    });
    dispatch_resume(weakSelf.timer);
}

#pragma mark - getters and setters
- (void)setModels:(NSArray<MasterAdvertisementModel *> *)models {
    _models = models;
    
    if (models.count == 0) {
        return;
    }
    
    [self.titles removeAllObjects];
    self.titles = [NSMutableArray array];
    
    for (MasterAdvertisementModel *model in models) {
        NSMutableAttributedString *titleAttM = [[NSMutableAttributedString alloc] init];
        
        NSString *masterNick = model.masterNick;
        if (masterNick.length > 7) {
            masterNick = [masterNick substringToIndex:6];
            masterNick = [NSString stringWithFormat:@"%@...", masterNick];
        }
        
        [titleAttM appendAttributedString:[[NSAttributedString alloc] initWithString:masterNick attributes:@{NSForegroundColorAttributeName : [XCTheme getTTMainColor], NSFontAttributeName : [UIFont systemFontOfSize:12]}]];
        [titleAttM appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", model.notice] attributes:@{NSForegroundColorAttributeName : [XCTheme getTTMainTextColor], NSFontAttributeName : [UIFont systemFontOfSize:12]}]];
        
        NSString *apprenticeNick = model.apprenticeNick;
        if (apprenticeNick.length > 7) {
            apprenticeNick = [apprenticeNick substringToIndex:6];
            apprenticeNick = [NSString stringWithFormat:@"%@...", apprenticeNick];
        }
        
        [titleAttM appendAttributedString:[[NSAttributedString alloc] initWithString:apprenticeNick attributes:@{NSForegroundColorAttributeName : [XCTheme getTTMainColor], NSFontAttributeName : [UIFont systemFontOfSize:12]}]];
        
        [self.titles addObject:titleAttM];
    }
    
    if (self.titles == nil || self.titles.count == 0) {
        [self.titles addObject:[NSMutableAttributedString new]]; //加一个空的,防止数组为空奔溃
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(26, 0, KScreenWidth - 2 * 30, 22);
    self.currentLabel = label;
    
    label.attributedText = self.titles[0];
    
    [self addSubview:label];
    self.clipsToBounds = YES;
    
    [self openCountdownWithTime];
}

- (UIImageView *)leftIconImageView {
    if (!_leftIconImageView) {
        _leftIconImageView = [[UIImageView alloc] init];
        _leftIconImageView.image = [UIImage imageNamed:@"discover_master_notice"];
    }
    return _leftIconImageView;
}


@end

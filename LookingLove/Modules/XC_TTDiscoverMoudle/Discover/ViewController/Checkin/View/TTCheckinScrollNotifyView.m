//
//  TTCheckinScrollNotifyView.m
//  TTPlay
//
//  Created by lvjunhang on 2019/3/19.
//  Copyright © 2019 YiZhuan. All rights reserved.
//

#import "TTCheckinScrollNotifyView.h"
#import "CheckinDrawNotice.h"

#import "XCTheme.h"
#import "XCMacros.h"
#import "NSArray+Safe.h"
#import <Masonry/Masonry.h>

@interface TTCheckinScrollNotifyView ()

@property (nonatomic, assign) int titleIndex;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) UILabel *currentLabel;

@property (nonatomic, strong) UIImageView *notifyImageView;

@end

@implementation TTCheckinScrollNotifyView

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

#pragma mark - event response
- (void)nextAd {
    UILabel *firstBtn = self.currentLabel;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, self.bounds.size.height, self.bounds.size.width - 30, self.bounds.size.height)];
    
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
    [self addSubview:self.notifyImageView];
}

- (void)initConstrations {
    [self.notifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(12);
    }];
}

- (void)stopCountDown {
    if (self.timer != nil) {
        dispatch_source_cancel(self.timer);
        _timer = nil;
    }
}

- (void)openCountdownWithTime {
    
    __weak __typeof(self) weakSelf = self;
    if (self.timer != nil) {
        dispatch_source_cancel(self.timer);
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),2.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf nextAd];
        });
    });
    dispatch_resume(self.timer);
}


#pragma mark - getters and setters
- (void)setModels:(NSArray<CheckinDrawNotice *> *)models {
    _models = models;
    
    if (models.count == 0) {
        return;
    }
    
    NSString *prefix = @"瓜分了";
    NSString *suffix = @"；";
    
    self.titles = [NSMutableArray array];
    for (CheckinDrawNotice *model in models) {
        NSString *notice = [NSString stringWithFormat:@"ID%@ %@%@金币%@", model.erbanNo, prefix, model.goldNum, suffix];
        
        NSRange prefixRange = [notice rangeOfString:prefix];
        NSRange suffixRange = [notice rangeOfString:suffix];
        BOOL hasPrefixRange = !NSEqualRanges(prefixRange, NSMakeRange(NSNotFound, 0));
        BOOL hasSuffixRange = !NSEqualRanges(suffixRange, NSMakeRange(NSNotFound, 0));

        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString: notice];
        [attri addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFEFEFE) range:NSMakeRange(0, notice.length)];
        [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, notice.length)];

        if (hasPrefixRange) {
            if (hasSuffixRange) {
                [attri addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFEE33) range:NSMakeRange(prefixRange.location+prefixRange.length, suffixRange.location-prefixRange.location-prefixRange.length)];
            } else {
                [attri addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFEE33) range:NSMakeRange(prefixRange.location+prefixRange.length, notice.length-prefixRange.location-prefixRange.length)];
            }
        }
        [self.titles addObject:attri];
    }
    
    if (self.titles == nil || self.titles.count == 0) {
        [self.titles addObject:[NSMutableAttributedString new]]; //加一个空的,防止数组为空奔溃
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, self.bounds.size.width-30, self.bounds.size.height);
    self.currentLabel = label;
    
    label.attributedText = self.titles[0];
    
    [self addSubview:label];
    self.clipsToBounds = YES;
    
    [self openCountdownWithTime];
}

- (UIImageView *)notifyImageView {
    if (!_notifyImageView) {
        _notifyImageView = [[UIImageView alloc] init];
        _notifyImageView.image = [UIImage imageNamed:@"checkin_ico_notify"];
    }
    return _notifyImageView;
}

@end

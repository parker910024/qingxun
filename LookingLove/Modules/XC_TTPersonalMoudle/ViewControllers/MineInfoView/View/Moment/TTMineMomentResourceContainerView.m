//
//  TTMineMomentResourceContainerView.m
//  XC_TTPersonalMoudle
//
//  Created by lvjunhang on 2019/11/27.
//  Copyright © 2019 WUJIE INTERACTIVE. All rights reserved.
//

#import "TTMineMomentResourceContainerView.h"
#import "TTMineMomentAlbumView.h"

#import <Masonry/Masonry.h>

@interface TTMineMomentResourceContainerView ()
@property (nonatomic, strong) TTMineMomentAlbumView *albumView;//相册
@end

@implementation TTMineMomentResourceContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self initViews];
        [self initConstraints];
    }
    return self;
}

#pragma mark - Public
- (CGFloat)height {
    CGFloat height = CGFLOAT_MIN;
    switch (self.model.type) {
        case UserMomentTypePic:
            height = [TTMineMomentAlbumView getPictureViewHeightWithImageInfoList:self.model.dynamicResList];
            break;
            
        default:
            break;
    }

    return height;
}

#pragma mark - Layout
- (void)initViews {
    [self addSubview:self.albumView];
}

- (void)initConstraints {
    [self.albumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark - Lazy Load
- (void)setModel:(UserMoment *)model {
    _model = model;
    
    switch (model.type) {
        case UserMomentTypePic:
        {
            self.albumView.hidden = NO;
            self.albumView.imageUrls = model.dynamicResList;
        }
            break;
            
        default:
            break;
    }
}

- (TTMineMomentAlbumView *)albumView {
    if (_albumView == nil) {
        _albumView = [[TTMineMomentAlbumView alloc] init];
    }
    return _albumView;
}

@end

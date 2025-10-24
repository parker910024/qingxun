//
//  TTGameActivityCollectionViewCell.m
//  AFNetworking
//
//  Created by User on 2019/5/6.
//

#import "TTGameActivityCollectionViewCell.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "ActivityInfo.h"

// SVG动画
#import "SVGA.h"
#import "SVGAParserManager.h"

@interface TTGameActivityCollectionViewCell ()
    
@property (nonatomic, strong) UIImageView *avatorImageView;
@property (nonatomic, strong) SVGAImageView *svgImageView;
@property (nonatomic, strong) SVGAParserManager *svgManager;
    
@end

@implementation TTGameActivityCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initView];
        
        [self initConstraint];
    }
    
    return self;
}
    
- (void)initView {
    [self.contentView addSubview:self.avatorImageView];
    [self.contentView addSubview:self.svgImageView];
}
    
- (void)initConstraint {
    [self.avatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    [self.svgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}
    
- (void)configWithUrlStr:(ActivityInfo *)info {
    
    if ([info.imageType isEqualToString:@"svga"]) {
        self.svgImageView.hidden = NO;
        self.avatorImageView.hidden = YES;
        NSURL *Url = [NSURL URLWithString:info.alertWinPic];
        @KWeakify(self);
        [self.svgManager loadSvgaWithURL:Url completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
            @KStrongify(self)
            self.svgImageView.loops = INT_MAX;
            self.svgImageView.clearsAfterStop = NO;
            self.svgImageView.videoItem = videoItem;
            [self.svgImageView startAnimation];
        } failureBlock:^(NSError * _Nullable error) {
            NSLog(@"失败了");
        }];
    } else {
        self.svgImageView.hidden = YES;
        self.avatorImageView.hidden = NO;
        [self.avatorImageView qn_setImageImageWithUrl:info.alertWinPic placeholderImage:@"" type:ImageTypeHomePageItem];
    }
}
    
- (UIImageView *)avatorImageView {
    if (!_avatorImageView) {
        _avatorImageView = [[UIImageView alloc] init];
    }
    return _avatorImageView;
}

- (SVGAImageView *)svgImageView {
    if (_svgImageView == nil) {
        _svgImageView = [[SVGAImageView alloc]init];
        _svgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _svgImageView.userInteractionEnabled = NO;
    }
    return _svgImageView;
}
    
- (SVGAParserManager *)svgManager {
    if (!_svgManager) {
        _svgManager = [[SVGAParserManager alloc]init];
    }
    return _svgManager;
}

@end

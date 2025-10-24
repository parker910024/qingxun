//
//  TTGameMatchTableViewCell.m
//  AFNetworking
//
//  Created by new on 2019/4/16.
//

#import "TTGameMatchTableViewCell.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义

// SVG动画
#import "SVGA.h"
#import "SVGAParserManager.h"

@interface TTGameMatchTableViewCell ()

@property (nonatomic, strong) UIView *oppositeSexView;
@property (nonatomic, strong) UIView *hiChatView;

@property (nonatomic, strong) SVGAImageView *oppositeSexImageView;
@property (nonatomic, strong) SVGAParserManager *oppositeSexManager;
@property (nonatomic, strong) UILabel *oppositeSexLabel;

@property (nonatomic, strong) SVGAImageView *hiChatImageView;
@property (nonatomic, strong) SVGAParserManager *hiChatManager;
@property (nonatomic, strong) UILabel *hiChatLabel;

@end

@implementation TTGameMatchTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = UIColorRGBAlpha(0xffffff, 0);
        
        [self initView];
        
        [self initConstraint];
    }
    return self;
}

- (void)initView{
    [self.contentView addSubview:self.oppositeSexView];
    [self.oppositeSexView addSubview:self.oppositeSexImageView];
    [self.oppositeSexView addSubview:self.oppositeSexLabel];
    
    [self.contentView addSubview:self.hiChatView];
    [self.hiChatView addSubview:self.hiChatImageView];
    [self.hiChatView addSubview:self.hiChatLabel];
}

- (void)initConstraint{
    [self.oppositeSexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake((KScreenWidth - 34) / 2, 50));
    }];
    
    [self.oppositeSexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.centerY.mas_equalTo(self.oppositeSexView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self loadSvgaAnimation:@"oppositeSexParty"];
    
    [self loadSvgaAnimationWithHiChat:@"hiChatParty"];
    
    [self.oppositeSexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.oppositeSexImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.oppositeSexView);
    }];
    
    [self.hiChatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake((KScreenWidth - 34) / 2, 50));
    }];
    
    [self.hiChatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(11);
        make.centerY.mas_equalTo(self.hiChatView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.hiChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hiChatImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.hiChatView);
    }];
}


- (void)oppositeSexTapAciton:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(oppositeSexBtnMatchClick)]) {
        [self.delegate oppositeSexBtnMatchClick];
    }
}

- (void)hiChatTapAciton:(UITapGestureRecognizer *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hiChatBtnMatchClick)]) {
        [self.delegate hiChatBtnMatchClick];
    }
}

- (void)loadSvgaAnimation:(NSString *)matchStr {
    
    NSString *matchString = [[NSBundle mainBundle] pathForResource:matchStr ofType:@"svga"];
    
    NSURL *matchUrl = [NSURL fileURLWithPath:matchString];
    
    @KWeakify(self);
    [self.oppositeSexManager loadSvgaWithURL:matchUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @KStrongify(self)
        self.oppositeSexImageView.loops = INT_MAX;
        self.oppositeSexImageView.clearsAfterStop = NO;
        self.oppositeSexImageView.videoItem = videoItem;
        [self.oppositeSexImageView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

- (void)loadSvgaAnimationWithHiChat:(NSString *)matchStr {
    NSString *matchString = [[NSBundle mainBundle] pathForResource:matchStr ofType:@"svga"];
    
    NSURL *matchUrl = [NSURL fileURLWithPath:matchString];
    
    @KWeakify(self);
    [self.hiChatManager loadSvgaWithURL:matchUrl completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
        @KStrongify(self)
        self.hiChatImageView.loops = INT_MAX;
        self.hiChatImageView.clearsAfterStop = NO;
        self.hiChatImageView.videoItem = videoItem;
        [self.hiChatImageView startAnimation];
    } failureBlock:^(NSError * _Nullable error) {
        
    }];
}

- (UIView *)oppositeSexView {
    if (!_oppositeSexView) {
        _oppositeSexView = [[UIView alloc] init];
        _oppositeSexView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _oppositeSexView.layer.cornerRadius = 8;
        UITapGestureRecognizer *oppositeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oppositeSexTapAciton:)];
        [_oppositeSexView addGestureRecognizer:oppositeTap];
    }
    return _oppositeSexView;
}

- (SVGAImageView *)oppositeSexImageView {
    if (_oppositeSexImageView == nil) {
        _oppositeSexImageView = [[SVGAImageView alloc]init];
        _oppositeSexImageView.contentMode = UIViewContentModeScaleAspectFill;
        _oppositeSexImageView.userInteractionEnabled = NO;
    }
    return _oppositeSexImageView;
}

- (SVGAParserManager *)oppositeSexManager {
    if (!_oppositeSexManager) {
        _oppositeSexManager = [[SVGAParserManager alloc]init];
    }
    return _oppositeSexManager;
}

- (UILabel *)oppositeSexLabel {
    if (!_oppositeSexLabel) {
        _oppositeSexLabel = [[UILabel alloc] init];
        _oppositeSexLabel.text = @"心动匹配";
        _oppositeSexLabel.textColor = UIColorFromRGB(0x666666);
        _oppositeSexLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _oppositeSexLabel;
}

- (UIView *)hiChatView {
    if (!_hiChatView) {
        _hiChatView = [[UIView alloc] init];
        _hiChatView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _hiChatView.layer.cornerRadius = 8;
        UITapGestureRecognizer *oppositeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiChatTapAciton:)];
        [_hiChatView addGestureRecognizer:oppositeTap];
    }
    return _hiChatView;
}

- (SVGAImageView *)hiChatImageView {
    if (_hiChatImageView == nil) {
        _hiChatImageView = [[SVGAImageView alloc]init];
        _hiChatImageView.contentMode = UIViewContentModeScaleAspectFill;
        _hiChatImageView.userInteractionEnabled = NO;
    }
    return _hiChatImageView;
}

- (SVGAParserManager *)hiChatManager {
    if (!_hiChatManager) {
        _hiChatManager = [[SVGAParserManager alloc]init];
    }
    return _hiChatManager;
}

- (UILabel *)hiChatLabel {
    if (!_hiChatLabel) {
        _hiChatLabel = [[UILabel alloc] init];
        _hiChatLabel.text = @"嗨聊派对";
        _hiChatLabel.textColor = UIColorFromRGB(0x666666);
        _hiChatLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    return _hiChatLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

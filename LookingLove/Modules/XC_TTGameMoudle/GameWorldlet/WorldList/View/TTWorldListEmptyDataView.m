//
//  TTWorldListEmptyDataView.m
//  AFNetworking
//
//  Created by lvjunhang on 2019/7/5.
//

#import "TTWorldListEmptyDataView.h"

#import "XCTheme.h"

#import <Masonry/Masonry.h>

@interface TTWorldListEmptyDataView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *actionButton;
@end

@implementation TTWorldListEmptyDataView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark - Event Responses
- (void)didClickActionButton {
    !self.actionBlock ?: self.actionBlock();
}

#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"common_noData_empty"];
    [self addSubview:self.imageView];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.text = @"还没加入世界哦  前往世界广场逛逛吧";
    self.descLabel.font = [UIFont systemFontOfSize:13];
    self.descLabel.textColor = [XCTheme getTTDeepGrayTextColor];
    [self addSubview:self.descLabel];
    
    self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.actionButton setBackgroundImage:[UIImage imageNamed:@"littleworld_no_data_btn"] forState:UIControlStateNormal];
    [self.actionButton setTitle:@"发现世界" forState:UIControlStateNormal];
    self.actionButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.actionButton addTarget:self action:@selector(didClickActionButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.actionButton];
}

- (void)initConstraints {
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(110);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(4);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(28);
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark - Getters and Setters


@end

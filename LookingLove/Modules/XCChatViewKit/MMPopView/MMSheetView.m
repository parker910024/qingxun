//
//  MMSheetView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMSheetView.h"
#import "MMPopupItem.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"
#import <Masonry/Masonry.h>

#define kMMSheetViewiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface MMSheetView()

@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIView      *buttonView;
@property (nonatomic, strong) UIButton    *cancelButton;

@property (nonatomic, strong) NSArray     *actionItems;
@property (nonatomic, assign) MMSheetViewStyle sheetViewStyle;
@end

@implementation MMSheetView

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items{
    return [self initWithStyle:MMSheetViewStyleNormal title:title items:items];
}


- (instancetype) initWithStyle:(MMSheetViewStyle)sheetViewStyle
                         title:(NSString*)title
                         items:(NSArray*)items{
    self = [super init];
    _sheetViewStyle = sheetViewStyle;
    if ( self )
    {
        NSAssert(items.count>0, @"Could not find any items.");
        
        MMSheetViewConfig *config = [MMSheetViewConfig globalConfig];
        
        self.type = MMPopupTypeSheet;
        self.actionItems = items;
        
        self.backgroundColor = config.splitColor;
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        //title
        MASViewAttribute *lastAttribute = self.mas_top;
        if ( title.length > 0 )
        {
            self.titleView = [UIView new];
            [self addSubview:self.titleView];
            [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
            }];
            self.titleView.backgroundColor = config.backgroundColor;
            
            self.titleLabel = [UILabel new];
            [self.titleView addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.titleView).insets(UIEdgeInsetsMake(config.innerMargin, config.innerMargin, config.innerMargin, config.innerMargin));
            }];
            self.titleLabel.textColor = config.titleColor;
            self.titleLabel.font = [UIFont systemFontOfSize:config.titleFontSize];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.text = title;
            
            lastAttribute = self.titleView.mas_bottom;
        }
        
        //buttonView
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        
        if(sheetViewStyle == MMSheetViewStyleCornerRadius){
            self.backgroundColor = [UIColor clearColor];
            self.buttonView.layer.cornerRadius = config.cornerRadius;
            self.buttonView.layer.masksToBounds = YES;
            
            [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(config.padding);
                make.right.equalTo(self).offset(-config.padding);
                make.top.equalTo(lastAttribute);
            }];
            
        }else{
            [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(lastAttribute);
            }];
        }
        
        //buttons
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for ( NSInteger i = 0 ; i < items.count; ++i )
        {
            MMPopupItem *item = items[i];
            
            UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
            [self.buttonView addSubview:btn];
            btn.tag = i;
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.right.equalTo(self.buttonView).insets(UIEdgeInsetsMake(0, -MM_SPLIT_WIDTH, 0, -MM_SPLIT_WIDTH));
                make.height.mas_equalTo(config.buttonHeight);
                
                if ( !firstButton )
                {
                    firstButton = btn;
                    make.top.equalTo(self.buttonView.mas_top).offset(-MM_SPLIT_WIDTH);
                }
                else
                {
                    make.top.equalTo(lastButton.mas_bottom).offset(-MM_SPLIT_WIDTH);
                    make.height.equalTo(firstButton);
                }
                
                lastButton = btn;
            }];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateDisabled];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:item.highlight?config.itemHighlightColor:item.disabled?config.itemDisableColor:config.itemNormalColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
            btn.layer.borderWidth = MM_SPLIT_WIDTH;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.enabled = !item.disabled;
        }
        [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.buttonView.mas_bottom).offset(MM_SPLIT_WIDTH);
        }];
        
        
        //cancle
        self.cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(actionCancel)];
        [self addSubview:self.cancelButton];
        
        if(sheetViewStyle == MMSheetViewStyleCornerRadius){
            self.cancelButton.layer.cornerRadius = config.cornerRadius;
            self.cancelButton.layer.masksToBounds = YES;
        }
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.buttonView);
            make.height.mas_equalTo(config.buttonHeight);
            make.top.equalTo(self.buttonView.mas_bottom).offset(15);
        }];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
        [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
        [self.cancelButton setTitle:config.defaultTextCancel forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:config.itemNormalColor forState:UIControlStateNormal];
        
        if(sheetViewStyle == MMSheetViewStyleCornerRadius){
            UIView *paddingView = [[UIView alloc] init];
            paddingView.backgroundColor = [UIColor clearColor];
            [self addSubview:paddingView];
            int paddingViewHeight = MM_IS_IPHONE_X ? MM_SafeAreaBottomHeight : 10;
            [paddingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.buttonView);
                make.height.equalTo(@(paddingViewHeight));
                make.top.equalTo(self.cancelButton.mas_bottom);
            }];
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(paddingView.mas_bottom);
            }];
        }else{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.cancelButton.mas_bottom).offset(MM_SafeAreaBottomHeight);
            }];
        }
        
    }
    
    return self;
}

- (void)actionButton:(UIButton*)btn
{
    MMPopupItem *item = self.actionItems[btn.tag];
    if ([item.title isEqualToString:@"仅密码进入"]) {
        
    }else{
        [self hide];
    }
    
    if ( item.handler )
    {
        item.handler(btn.tag);
    }
}

- (void)actionCancel
{
    [self hide];
}

@end


@interface MMSheetViewConfig()

@end

@implementation MMSheetViewConfig

+ (MMSheetViewConfig *)globalConfig
{
    static MMSheetViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [MMSheetViewConfig new];
        
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.innerMargin    = 19.0f;
//        self.buttonHeight   = 50.0f;
//        self.padding        = 10.0f; //add by KevinWang
//        self.cornerRadius   = 5.0f; //add by KevinWang
        // 如果与其他App 设计统一的时候，再进行单独项目匹配。以上注释，一个版本后删除
        self.padding = 15.f;    // 统一改为 15  by Lee
        self.cornerRadius = 14.f;  // UI 要求统一为 14。 by Lee
        self.buttonHeight   = 51.0f;  // 按钮统一为 51. by lee

        self.titleFontSize  = 14.0f;
        self.buttonFontSize = 17.0f;
        
        self.backgroundColor    = MMHexColor(0xFFFFFFFF);
        self.titleColor         = MMHexColor(0x666666FF);
        self.splitColor         = MMHexColor(0xF0F0F0FF);
        
        self.itemNormalColor    = MMHexColor(0x333333FF);
        self.itemDisableColor   = MMHexColor(0xCCCCCCFF);
        self.itemHighlightColor = MMHexColor(0xE76153FF);
        self.itemPressedColor   = MMHexColor(0xEFEDE7FF);
        
        self.defaultTextCancel  = @"取消";
    }
    
    return self;
}

@end

//
//  TTGoddessTableHeaderView.m
//  AFNetworking
//
//  Created by lvjunhang on 2019/6/3.
//

#import "TTGoddessTableHeaderView.h"

#import "TTGoddessChatContentCell.h"

#import "TTGoddessViewProtocol.h"

#import "XCMacros.h"
#import "XCTheme.h"
#import "SDCycleScrollView.h"
#import "NSArray+Safe.h"

#import "DiscoveryHeadLineNews.h"
#import "Attachment.h"

#import <Masonry/Masonry.h>
#import "NIMMessageModel.h"

@interface TTGoddessTableHeaderView ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray<NSArray<DiscoveryHeadLineNews *> *> *dataSource;//每页的数据源

@property (nonatomic, strong) SDCycleScrollView *cycleView;

@property (nonatomic, strong) UILabel *mainTitleLabel;//大厅热聊
@property (nonatomic, strong) UILabel *subTitleLabel;//打个招呼马上聊

@property (nonatomic, strong) UIImageView *arrowImageView;//箭头

@property (nonatomic, strong) UIView *bottomLineView;//底部分隔线

@end

@implementation TTGoddessTableHeaderView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    
    //setting default frame
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, KScreenWidth, 65);
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self initConstraints];
        
        //添加手势
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public Methods
#pragma mark - System Protocols
#pragma mark - Custom Protocols
#pragma mark SDCycleScrollViewDelegate
- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view {
    if (view != _cycleView) {
        return nil;
    }
    
    return [TTGoddessChatContentCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view {
    TTGoddessChatContentCell *chatCell = (TTGoddessChatContentCell *)cell;
    chatCell.modelArray = [self.dataSource safeObjectAtIndex:index];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(onCellDidSelectLineNewsCellAction)]) {
//        [self.delegate onCellDidSelectLineNewsCellAction];
//    }
}

#pragma mark - Event Responses
- (void)viewTapAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickTableHeaderView:)]) {
        [self.delegate didClickTableHeaderView:self];
    }
}

#pragma mark - Private Methods
#pragma mark layout
- (void)initViews {
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.mainTitleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.cycleView];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.bottomLineView];
}

- (void)initConstraints {
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(18);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mainTitleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.mainTitleLabel);
        make.bottom.mas_equalTo(-14);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.top.mas_equalTo(self.mainTitleLabel.mas_top).offset(12);
        make.size.mas_equalTo(CGSizeMake(8, 13));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(2);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(28);
        make.height.mas_equalTo(0.5);
    }];
}

- (NSMutableArray *)chatContentModelArray:(NSArray<NIMMessageModel *> *)array {
    
    NSMutableArray *modelArray = [NSMutableArray array];
    NSMutableArray *tempArray  = [NSMutableArray arrayWithCapacity:2];
    
    for (int i = 0 ; i < array.count; i++) {
        id model = array[i];
        if (i % 2 == 0 && i > 0) {
            tempArray = [NSMutableArray array];
        }
        
        [tempArray addObject:model];
        
        if (tempArray.count == 2) {
            [modelArray addObject:tempArray];
        } else {
            //为了计算奇数个的时候
            if ((i % 2 == 0) && (i == array.count - 1)) {
                [modelArray addObject:tempArray];
            }
        }
    }
    
    return modelArray.copy;
}

#pragma mark - getter setter
- (void)setDataModelArray:(NSMutableArray<NIMMessageModel *> *)dataModelArray {
    
    NSMutableArray *textModelArray = [NSMutableArray array];
    for (NIMMessageModel *model in dataModelArray.reverseObjectEnumerator) {
        
        id<NIMMessageObject> obj = model.message.messageObject;
        
        //此对象为空说明不是自定义对象，即该消息为普通文本消息
        if (obj == nil) {
            
            [textModelArray insertObject:model atIndex:0];
            
        } else {
            
            Attachment *att = (Attachment *)[(NIMCustomObject *)obj attachment];
            
            //以下三句过滤特定类型消息
            if (![att isKindOfClass:[Attachment class]]) {
                continue;
            }
            
            if (att.first == Custom_Noti_Header_CPGAME_PrivateChat_SystemNotification) {
                continue;
            }
            
            if (att.first == Custom_Noti_Header_CPGAME_PublicChat_Respond) {
                continue;
            }
            
            //自定义消息加入列表
            [textModelArray insertObject:model atIndex:0];
        }
        
        //只取最后两个
        if ([textModelArray count] == 2) {
            break;
        }
    }
    
    if (textModelArray.count == 0) {
        return;
    }
    
    //如果新数据只有一个，将旧数据最后一条取出填充
    if (textModelArray.count == 1) {
        id last = _dataModelArray.lastObject;
        if (last) {
            [textModelArray insertObject:last atIndex:0];
        }
    }
    
    //大于一个，且是单数
    if ([textModelArray count] > 1 && [textModelArray count] % 2 == 1) {
        [textModelArray removeObjectAtIndex:0];
    }
    
    _dataModelArray = [textModelArray mutableCopy];

    self.dataSource = [self chatContentModelArray:textModelArray.copy];
    
    if (self.dataSource.count > 0) {
        //MARK:SDCycle 返回自定cell时，如果imageURLStringsGroup不赋值会出现SDCycle无法显示bug
        NSMutableArray *imageArray = [NSMutableArray array];;
        for (int i = 0; i < self.dataSource.count; i++) {
            [imageArray addObject:@"home_headline"];
        }
        self.cycleView.imageURLStringsGroup = imageArray;
    }
}

#pragma mark - Getters and Setters
- (SDCycleScrollView * )cycleView {
    if (_cycleView == nil) {
        
        CGFloat height = TTGoddessChatContentCellAvatarSize * 2 + TTGoddessChatContentCellInterval;
        CGFloat width = TTGoddessChatContentCellAvatarSize + TTGoddessChatContentCellInterval + TTGoddessChatContentCellLabelMaxWidth;
        CGFloat rightMargin = 38.0f;
        CGFloat y = 6;
        CGFloat x = KScreenWidth - rightMargin - width;

        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(x, y, width, height) delegate:self placeholderImage:nil];
        _cycleView.userInteractionEnabled = NO;
        _cycleView.showPageControl = NO;
        _cycleView.backgroundColor = [UIColor clearColor];
        [_cycleView disableScrollGesture];
        _cycleView.autoScrollTimeInterval = 4.5;
        _cycleView.infiniteLoop = NO;
        _cycleView.scrollDirection =UICollectionViewScrollDirectionVertical;
    }
    return _cycleView;
}

- (UILabel *)mainTitleLabel {
    if (_mainTitleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"大厅热聊";
        label.textColor = [XCTheme getTTMainTextColor];
        label.font = [UIFont systemFontOfSize:19];
        
        _mainTitleLabel = label;
    }
    return _mainTitleLabel;
}

- (UILabel *)subTitleLabel {
    if (_subTitleLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"打个招呼马上聊";
        label.textColor = [XCTheme getTTDeepGrayTextColor];
        label.font = [UIFont systemFontOfSize:12];
        
        _subTitleLabel = label;
    }
    return _subTitleLabel;
}

- (UIImageView *)arrowImageView {
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"game_home_lobby_more"];
    }
    return _arrowImageView;
}

- (UIView *)bottomLineView {
    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [XCTheme getTTSimpleGrayColor];
    }
    return _bottomLineView;
}

@end

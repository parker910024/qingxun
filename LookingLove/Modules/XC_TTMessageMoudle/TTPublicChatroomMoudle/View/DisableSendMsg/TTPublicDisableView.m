//
//  TTPublicDisableView.m
//  AFNetworking
//
//  Created by User on 2019/5/7.
//

#import "TTPublicDisableView.h"
#import <Masonry/Masonry.h> // 约束
#import "XCMacros.h" // 约束的宏定义
#import "UIImageView+QiNiu.h"  // 加载图片
#import "XCTheme.h" // 颜色设置的宏定义
#import "NSArray+Safe.h"
#import "XCHUDTool.h"
#import "TTPopup.h"

#import <YYText.h>
#import "XCPlaceholderTextView.h"
#import "UserCore.h"

#import "UIView+NTES.h"
#import <NIMSDK/NIMSDK.h>
#import "ImRoomCoreV2.h"
#import "PublicChatroomCore.h"
#import "PublicChatroomCoreClient.h"
#import "LittleWorldCore.h"

static int kRoomDisableMaxWordsLength = 10;

@interface TTPublicDisableView ()

@property (nonatomic, strong) UIView *disableSendView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *reasonLabel;
@property (nonatomic, strong) XCPlaceholderTextView *reasonTextView;
@property (nonatomic, strong) UILabel *wordCountLabel;

@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIButton *durationButton;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) NSArray *timeArray;
@property (nonatomic, strong) UIView *timeSelectView;
@property (nonatomic, strong) NSArray *timeSecondArray;

@property (nonatomic, assign) UserID targetUid;

@end



@implementation TTPublicDisableView

- (instancetype)initWithFrame:(CGRect)frame withUserID:(UserID )uid {
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, 300, 270 + 39);
    }
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.targetUid = uid;
        
        [self initView];
        
        [self initConstraint];
        
        [self addNotification];
        
        AddCoreClient(PublicChatroomCoreClient, self);
    }
    
    return self;
}

- (void)dealloc {
    RemoveCoreClientAll(self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:KTTInputViewBecomeFirstResponder object:self.reasonTextView];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    GetCore(LittleWorldCore).isLittleWorldInput = YES;
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    
    CGFloat top = KScreenHeight / 2 + rect.size.height / 2;
    
    CGFloat height = CGRectGetMinY(keyboardRect) - top;
    
    if (height < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.frame = CGRectMake(rect.origin.x, KScreenHeight / 2 - rect.size.height / 2 + (height - 15), rect.size.width, rect.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    CGRect rect = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.superview.frame = CGRectMake(rect.origin.x, KScreenHeight / 2 - rect.size.height / 2, rect.size.width, rect.size.height);
    }];
}

- (void)initView {
    [self addSubview:self.disableSendView];
    
    [self.disableSendView addSubview:self.titleLabel];
    
    [self.disableSendView addSubview:self.reasonLabel];
    [self.disableSendView addSubview:self.reasonTextView];
    [self.disableSendView addSubview:self.wordCountLabel];
    
    [self.disableSendView addSubview:self.durationLabel];
    [self.disableSendView addSubview:self.durationButton];
    [self.disableSendView addSubview:self.timeLabel];
    
    [self.disableSendView addSubview:self.cancelButton];
    [self.disableSendView addSubview:self.sureButton];
    
    [self addSubview:self.timeSelectView];
}

- (void)initConstraint {
    
    [self.disableSendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 270));
        make.top.left.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.centerX.mas_equalTo(self.disableSendView);
        make.left.mas_equalTo(62);
        make.right.mas_equalTo(-62);
    }];
    
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(35);
        make.left.mas_equalTo(19);
    }];
    
    [self.reasonTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.reasonLabel.mas_right).offset(10);
        make.width.mas_equalTo(190);
        make.height.mas_equalTo(39);
        make.centerY.mas_equalTo(self.reasonLabel.mas_centerY);
    }];
    
    [self.wordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.reasonTextView).offset(-4);
        make.bottom.equalTo(self.reasonTextView).offset(-4);
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.reasonLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(19);
    }];
    
    [self.durationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.durationLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(130, 39));
        make.centerY.mas_equalTo(self.durationLabel.mas_centerY);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.durationLabel.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 39));
        make.centerY.mas_equalTo(self.durationLabel.mas_centerY);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.bottom.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(120, 38));
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-22);
        make.bottom.mas_equalTo(-25);
        make.size.mas_equalTo(CGSizeMake(120, 38));
    }];
    
    [self.timeSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.durationLabel.mas_right).offset(10);
        make.top.mas_equalTo(self.durationButton.mas_top);
        make.size.mas_equalTo(CGSizeMake(100, 4 * 39));
    }];
    
    [self.timeSelectView layoutIfNeeded];
    
    
    NSArray *timeArray = @[@" 1    小时",@" 3    小时",@"24  小时",@"1      月"];
    self.timeArray = timeArray;
    
    self.timeSecondArray = @[@(3600),@(3600 * 3),@(3600 * 24),@(3600 * 24 * 30)];
    
    for (int i = 0; i < timeArray.count; i++) {
        UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [timeButton setTitle:timeArray[i] forState:UIControlStateNormal];
        timeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [timeButton setTitleColor:[XCTheme getTTMainTextColor] forState:UIControlStateNormal];
        timeButton.size = CGSizeMake(100, 39);
        timeButton.left = 0;
        timeButton.top = timeButton.height * i;
        timeButton.tag = 100 + i;
        [timeButton addTarget:self action:@selector(timeBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
        [self.timeSelectView addSubview:timeButton];
    }
    
    
    @weakify(self);
    [[GetCore(UserCore) getUserInfoByRac:self.targetUid refresh:NO] subscribeNext:^(id x) {
        @strongify(self);
        UserInfo *info = (UserInfo *)x;
        self.titleLabel.text = [NSString stringWithFormat:@"禁言 %@ ",info.nick];
    }];
}


- (void)timeBtnAciton:(UIButton *)sender {
    _timeLabel.text = self.timeArray[(sender.tag - 100)];
    _timeSelectView.hidden = YES;
    _timeLabel.hidden = NO;
}

- (void)durationBtnAciton:(UIButton *)sender {
    if (_timeLabel.isHidden) {
        _timeLabel.hidden = NO;
        _timeSelectView.hidden = YES;
    } else {
        _timeLabel.hidden = YES;
        _timeSelectView.hidden = NO;
    }
}

- (void)cancenBtnAction:(UIButton *)sender {
    [TTPopup dismiss];
}

- (void)sureBtnAction:(UIButton *)sender {
    
    NSInteger index = [self.timeArray indexOfObject:_timeLabel.text];
    
    NSString *remark = self.reasonTextView.text;
    
    if (remark.length <= 0) {
        [XCHUDTool showErrorWithMessage:@"封禁原因不能为空"];
        return;
    }
    
    [GetCore(PublicChatroomCore) publicChatRoomNotMessage:self.targetUid duration:[[self.timeSecondArray safeObjectAtIndex:index] intValue] remark:remark];
}

- (void)onPublicChatRoomNotMessageSuccess {
    [XCHUDTool showSuccessWithMessage:@"禁言成功"];
    [TTPopup dismiss];
}

- (UIView *)disableSendView {
    if (!_disableSendView) {
        _disableSendView = [[UIView alloc] init];
        _disableSendView.backgroundColor = UIColorFromRGB(0xffffff);
        _disableSendView.layer.cornerRadius = 14;
    }
    return _disableSendView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [XCTheme getTTMainTextColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)reasonLabel {
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.textColor = [XCTheme getTTSubTextColor];
        _reasonLabel.font = [UIFont systemFontOfSize:13];
        _reasonLabel.numberOfLines = 0;
        NSString *reasonStr = @"禁言理由\n(必填)";
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:reasonStr];
        NSRange range = [reasonStr rangeOfString:@"(必填)"];
        [attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFB606) range:range];
        attStr.yy_lineSpacing = 4;
        _reasonLabel.attributedText = attStr;
        _reasonLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _reasonLabel;
}

- (XCPlaceholderTextView *)reasonTextView {
    if (!_reasonTextView) {
        _reasonTextView = [[XCPlaceholderTextView alloc] init];
        _reasonTextView.backgroundColor = [UIColor clearColor];
        _reasonTextView.textAlignment = NSTextAlignmentLeft;
        _reasonTextView.textColor = UIColorFromRGB(0x333333);
        _reasonTextView.font = [UIFont systemFontOfSize:14.0];
        _reasonTextView.layer.borderWidth = 1.0;
        _reasonTextView.layer.borderColor = UIColorRGBAlpha(0x666666, 0.18).CGColor;
        _reasonTextView.layer.cornerRadius = 5.0;
        _reasonTextView.layer.masksToBounds = YES;
        _reasonTextView.placeholder = @"请填写禁言原因";
        [_reasonTextView setPlaceholderColor:UIColorFromRGB(0x999999)];
        [_reasonTextView setPlaceholderFont:[UIFont systemFontOfSize:14.0]];
        
        @KWeakify(self);
        [_reasonTextView addMaxTextLengthWithMaxLength:kRoomDisableMaxWordsLength andEvent:^(XCPlaceholderTextView *textView) {
            @KStrongify(self);
        }];
        
        [_reasonTextView addTextViewUpdateEvent:^(XCPlaceholderTextView * _Nonnull text) {
            @KStrongify(self);
            self.wordCountLabel.text = [NSString stringWithFormat:@"%d/%d",text.text.length,kRoomDisableMaxWordsLength];
        }];
        
        __block XCPlaceholderTextView *textView = _reasonTextView;
        [_reasonTextView addTextViewBeginEvent:^(XCPlaceholderTextView * _Nonnull text) {
            [textView becomeFirstResponder];
        }];
    }
    return _reasonTextView;
}

- (UILabel *)wordCountLabel {
    if (!_wordCountLabel) {
        _wordCountLabel = [[UILabel alloc] init];
        _wordCountLabel.font = [UIFont systemFontOfSize:10.0];
        _wordCountLabel.textColor = UIColorFromRGB(0x333333);
        _wordCountLabel.text = @"10/10";
        _wordCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _wordCountLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.textColor = [XCTheme getTTSubTextColor];
        _durationLabel.font = [UIFont systemFontOfSize:13];
        _durationLabel.numberOfLines = 0;
        NSString *reasonStr = @"禁言时长\n(必填)";
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:reasonStr];
        NSRange range = [reasonStr rangeOfString:@"(必填)"];
        [attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xFFB606) range:range];
        attStr.yy_lineSpacing = 4;
        _durationLabel.attributedText = attStr;
        _durationLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _durationLabel;
}

- (UIButton *)durationButton {
    if (!_durationButton) {
        _durationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_durationButton setImage:[UIImage imageNamed:@"room_popup_down"] forState:UIControlStateNormal];
        _durationButton.adjustsImageWhenHighlighted = NO;
        [_durationButton addTarget:self action:@selector(durationBtnAciton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _durationButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = UIColorFromRGB(0xFEF5ED);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorFromRGB(0xFFB606) forState:UIControlStateNormal];
        _cancelButton.layer.cornerRadius = 19;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton addTarget:self action:@selector(cancenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = UIColorFromRGB(0xFFB606);
        [_sureButton setTitle:@"提交" forState:UIControlStateNormal];
        [_sureButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _sureButton.layer.cornerRadius = 19;
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIView *)timeSelectView {
    if (!_timeSelectView) {
        _timeSelectView = [[UIView alloc] init];
        _timeSelectView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        _timeSelectView.layer.cornerRadius = 8;
        _timeSelectView.hidden = YES;
    }
    return _timeSelectView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.textColor = [XCTheme getTTMainTextColor];
        _timeLabel.text = @" 1    小时";
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.userInteractionEnabled = NO;
    }
    return _timeLabel;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

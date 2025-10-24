//
//  TTParentPasswordInputView.m
//  AFNetworking
//
//  Created by User on 2019/5/5.
//

#import "TTParentPasswordInputView.h"
#import "TTParentPasswordLabel.h"

@interface TTParentPasswordInputView ()
@property (nonatomic, strong) UITextField *bgTf;
@end

@implementation TTParentPasswordInputView

-(instancetype)initWithFrame:(CGRect)frame withNum:(NSInteger)num
{
    self=[super initWithFrame:frame];
    if (self) {
        self.lbArray = [NSMutableArray array];
        
        self.bgTf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0,1 , 1)];
        _bgTf.textColor = [UIColor clearColor];
        _bgTf.tintColor = [UIColor clearColor];
        [_bgTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _bgTf.keyboardType = UIKeyboardTypeNumberPad;
        [_bgTf becomeFirstResponder];
        [self addSubview:_bgTf];
        
        CGFloat tfWidth = frame.size.height;
        CGFloat tfSpace = (frame.size.width-tfWidth*num) / (num+1);
        for (int i = 0; i < num; i++) {
            TTParentPasswordLabel *codeLab = [[TTParentPasswordLabel alloc] initWithFrame:CGRectMake(tfSpace * i + tfWidth * i, 0, tfWidth, tfWidth)];
            codeLab.tag = 100 + i;
            [self addSubview:codeLab];
            [self.lbArray addObject:codeLab];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [self.bgTf becomeFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (textField.text.length > self.lbArray.count) {
        
        textField.text = [textField.text substringToIndex:self.lbArray.count];
        
    }
    
    if (_returnBlock != nil) {
        _returnBlock(textField.text);
    }
    for (UILabel *pwLab in self.lbArray) {
        if (pwLab.tag < (100 + textField.text.length)) {
            pwLab.text=@"●";
        }else{
            pwLab.text=@"";
        }
    }
}
    
- (void)clearPassword {
    
    self.bgTf.text = @"";
    
    for (UILabel *pwLab in self.lbArray) {
        if (pwLab.tag < (100 + self.bgTf.text.length)) {
            pwLab.text=@"●";
        }else{
            pwLab.text=@"";
        }
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

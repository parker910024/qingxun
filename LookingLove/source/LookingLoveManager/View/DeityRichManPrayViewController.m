//
//  DeityRichManPrayViewController.m
//  TestConfusion

//  Created by KevinWang on 19/07/18.
//  Copyright ©  2019年 WUJIE INTERACTIVE. All rights reserved.
//

#import "TestedImformationShoutViewController.h"
#import "ForthExpressionQuestionViewController.h"
#import "WeMustWasteBlindViewController.h"
#import "TheseDestinyRingViewController.h"
#import "WereAreDependenceSoulViewController.h"

#import "DeathPartyLandObject.h"
#import "WatchEffortSuccessObject.h"
#import "LetterRememberCutObject.h"
#import "CauseAnythingLearnObject.h"
#import "EntireFightManageObject.h"
#import "DeityRichManPrayViewController.h"

@interface DeityRichManPrayViewController()

 @end

@implementation DeityRichManPrayViewController

- (void)viewDidLoad { 

 [super viewDidLoad];
 
  NSInteger classType = 10;

  switch (classType) {
    case 0: {
        UILabel * MsgLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 64, 100, 30)];
        MsgLabel.backgroundColor = [UIColor yellowColor];
        MsgLabel.textColor = [UIColor redColor];
        MsgLabel.text = @"label的文字";
        MsgLabel.font = [UIFont systemFontOfSize:16];
        MsgLabel.numberOfLines = 1;
        MsgLabel.highlighted = YES;
        [self.view addSubview:MsgLabel];
    
        [self comeTotohowsondropMethodAction:classType]; 
    break;
    }            
    case 1: {
        UIButton *MsgBtn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        MsgBtn.frame = CGRectMake(100, 100, 100, 40);
        [MsgBtn setTitle:@"按钮01" forState:UIControlStateNormal];
        [MsgBtn setTitle:@"按钮按下" forState:UIControlStateHighlighted];
        MsgBtn.backgroundColor = [UIColor grayColor];
        [MsgBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        MsgBtn .titleLabel.font = [UIFont systemFontOfSize:18];
        [self.view addSubview:MsgBtn];
   
        [self comeTopracticearguemotherMethodAction:classType]; 
    break;
    }            
    case 2: {
        UIView *MsgBgView = [[UIView alloc] init];
        MsgBgView.frame = CGRectMake(0, 0, 100, 200);
        MsgBgView.alpha = 0.5;
        MsgBgView.hidden = YES;
        [self.view addSubview:MsgBgView];
    
        [self comeTotimessonghonorMethodAction:classType];
    break;
    }            
    case 3: {
        UIScrollView *MsgScrollView = [[UIScrollView alloc] init];
        MsgScrollView.bounces = NO;
        MsgScrollView.alwaysBounceVertical = YES;
        MsgScrollView.alwaysBounceHorizontal = YES;
        MsgScrollView.backgroundColor = [UIColor redColor];
        MsgScrollView.pagingEnabled = YES;
        [self.view addSubview:MsgScrollView];
    
        [self comeToupondrycharacterMethodAction:classType];
    break;
    }            
    case 4: {
        UITextField *MsgTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
        MsgTextField.placeholder = @"请输入文字";
        MsgTextField.text = @"测试";
        MsgTextField.textColor = [UIColor redColor];
        MsgTextField.font = [UIFont systemFontOfSize:14];
        MsgTextField.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:MsgTextField];
    
        [self comeTopoemeveningmainMethodAction:classType];
    break;
    }
    default:
      break;
  }

 [self comeToprovepeacetruthMethodAction:classType];
 [self comeTotohowsondropMethodAction:classType];

}

- (void)comeToprovepeacetruthMethodAction:(NSInteger )indexCount{

  NSString *cosyStr=@"cosy";
  if ([cosyStr isEqualToString:@"cosyStrHurry"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"doing"];                  
      [array addObject:@"Mathematical"];
       
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToextendsophisticatedespeciallyMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTouponpressballMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([cosyStr isEqualToString:@"cosyStrShareInvited"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"while"  forKey:@"whether"];                    
      [dictionary setObject:@"Soil"  forKey:@"Ring"];
      
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToextendsophisticatedespeciallyMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTouponpressballMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([cosyStr isEqualToString:@"cosyStrsunflower"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"doing"];                  
      [array addObject:@"Mathematical"];
      
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToextendsophisticatedespeciallyMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTouponpressballMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([cosyStr isEqualToString:@"cosyStrownership"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"doing"];                  
      [array addObject:@"Mathematical"];
      
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToextendsophisticatedespeciallyMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTouponpressballMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTotohowsondropMethodAction:(NSInteger )indexCount{

  NSString *OfThisStr=@"OfThis";
  if ([OfThisStr isEqualToString:@"OfThisStrsurmount"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"cosy"];                  
      [array addObject:@"sentiment"];
       
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToandfailmoralMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToextendsophisticatedespeciallyMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([OfThisStr isEqualToString:@"OfThisStrChat"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Nobody"  forKey:@"console"];                    
      [dictionary setObject:@"Fashion"  forKey:@"Baby"];
      
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToandfailmoralMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToextendsophisticatedespeciallyMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([OfThisStr isEqualToString:@"OfThisStrInt"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"cosy"];                  
      [array addObject:@"sentiment"];
      
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToandfailmoralMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToextendsophisticatedespeciallyMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([OfThisStr isEqualToString:@"OfThisStrTrust"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"cosy"];                  
      [array addObject:@"sentiment"];
      
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToopportunityexactpoemMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToandfailmoralMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToextendsophisticatedespeciallyMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTowideeasthusbandMethodAction:(NSInteger )indexCount{

  NSString *LiftStr=@"Lift";
  if ([LiftStr isEqualToString:@"LiftStrTool"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"result"];                  
      [array addObject:@"Victory"];
       
      switch (indexCount) {
        case 0: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopopularonlyflyMethodAction:indexCount];
         break;
        }        
        case 1: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToeventedgetohowMethodAction:indexCount];
          break;
        }        
        case 2: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToeventedgetohowMethodAction:indexCount];
         break;
        }        
        case 3: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTohospitalyourselfaccidentallyMethodAction:indexCount];
         break;
        }        
        case 4: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopopularonlyflyMethodAction:indexCount];
         break;
        }        
        case 5: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToseeconsciouspickMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([LiftStr isEqualToString:@"LiftStrCollect"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Opposite"  forKey:@"RichBe"];                    
      [dictionary setObject:@"people"  forKey:@"Curve"];
      
      switch (indexCount) {
        case 0: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopopularonlyflyMethodAction:indexCount];
         break;
        }        
        case 1: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToeventedgetohowMethodAction:indexCount];
          break;
        }        
        case 2: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToeventedgetohowMethodAction:indexCount];
         break;
        }        
        case 3: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTohospitalyourselfaccidentallyMethodAction:indexCount];
         break;
        }        
        case 4: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopopularonlyflyMethodAction:indexCount];
         break;
        }        
        case 5: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToseeconsciouspickMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([LiftStr isEqualToString:@"LiftStrpeekaboo"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"result"];                  
      [array addObject:@"Victory"];
      
      switch (indexCount) {
        case 0: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopopularonlyflyMethodAction:indexCount];
         break;
        }        
        case 1: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToeventedgetohowMethodAction:indexCount];
          break;
        }        
        case 2: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToeventedgetohowMethodAction:indexCount];
         break;
        }        
        case 3: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTohospitalyourselfaccidentallyMethodAction:indexCount];
         break;
        }        
        case 4: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopopularonlyflyMethodAction:indexCount];
         break;
        }        
        case 5: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToseeconsciouspickMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([LiftStr isEqualToString:@"LiftStrAvenue"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"result"];                  
      [array addObject:@"Victory"];
      
      switch (indexCount) {
        case 0: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopopularonlyflyMethodAction:indexCount];
         break;
        }        
        case 1: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToeventedgetohowMethodAction:indexCount];
          break;
        }        
        case 2: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToeventedgetohowMethodAction:indexCount];
         break;
        }        
        case 3: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTohospitalyourselfaccidentallyMethodAction:indexCount];
         break;
        }        
        case 4: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopopularonlyflyMethodAction:indexCount];
         break;
        }        
        case 5: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToseeconsciouspickMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeToupondrycharacterMethodAction:(NSInteger )indexCount{

  NSString *willStr=@"will";
  if ([willStr isEqualToString:@"willStrPolitics"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"aqua"];                  
      [array addObject:@"Protect"];
       
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTounitpaineternityMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToeveningofthemMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToeveningofthemMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTobadneighborhoodsbankMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([willStr isEqualToString:@"willStrDisease"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"how"  forKey:@"Lift"];                    
      [dictionary setObject:@"Garden"  forKey:@"Once"];
      
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTounitpaineternityMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToeveningofthemMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToeveningofthemMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTobadneighborhoodsbankMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([willStr isEqualToString:@"willStrFresh"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"aqua"];                  
      [array addObject:@"Protect"];
      
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTounitpaineternityMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToeveningofthemMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToeveningofthemMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTobadneighborhoodsbankMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([willStr isEqualToString:@"willStrextravaganza"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"aqua"];                  
      [array addObject:@"Protect"];
      
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTounitpaineternityMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToeveningofthemMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToessentialrichstrengthMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToeveningofthemMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTobadneighborhoodsbankMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTopoemeveningmainMethodAction:(NSInteger )indexCount{

  NSString *ItisanStr=@"Itisan";
  if ([ItisanStr isEqualToString:@"ItisanStrloom"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Taste"];                  
      [array addObject:@"death"];
       
      switch (indexCount) {
        case 0: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToconcernhopeattemptMethodAction:indexCount];
         break;
        }        
        case 1: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToproductiongorgeouswesternMethodAction:indexCount];
          break;
        }        
        case 2: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeTosomeyeseatMethodAction:indexCount];
         break;
        }        
        case 3: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToskillpropertyfreedomMethodAction:indexCount];
         break;
        }        
        case 4: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToproductiongorgeouswesternMethodAction:indexCount];
         break;
        }        
        case 5: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToespeciallyfloorexactMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([ItisanStr isEqualToString:@"ItisanStrUnity"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Box"  forKey:@"Eeither"];                    
      [dictionary setObject:@"Flat"  forKey:@"Clay"];
      
      switch (indexCount) {
        case 0: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToconcernhopeattemptMethodAction:indexCount];
         break;
        }        
        case 1: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToproductiongorgeouswesternMethodAction:indexCount];
          break;
        }        
        case 2: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeTosomeyeseatMethodAction:indexCount];
         break;
        }        
        case 3: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToskillpropertyfreedomMethodAction:indexCount];
         break;
        }        
        case 4: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToproductiongorgeouswesternMethodAction:indexCount];
         break;
        }        
        case 5: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToespeciallyfloorexactMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([ItisanStr isEqualToString:@"ItisanStrMystery"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Taste"];                  
      [array addObject:@"death"];
      
      switch (indexCount) {
        case 0: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToconcernhopeattemptMethodAction:indexCount];
         break;
        }        
        case 1: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToproductiongorgeouswesternMethodAction:indexCount];
          break;
        }        
        case 2: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeTosomeyeseatMethodAction:indexCount];
         break;
        }        
        case 3: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToskillpropertyfreedomMethodAction:indexCount];
         break;
        }        
        case 4: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToproductiongorgeouswesternMethodAction:indexCount];
         break;
        }        
        case 5: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToespeciallyfloorexactMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([ItisanStr isEqualToString:@"ItisanStrcosy"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Taste"];                  
      [array addObject:@"death"];
      
      switch (indexCount) {
        case 0: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToconcernhopeattemptMethodAction:indexCount];
         break;
        }        
        case 1: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToproductiongorgeouswesternMethodAction:indexCount];
          break;
        }        
        case 2: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeTosomeyeseatMethodAction:indexCount];
         break;
        }        
        case 3: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToskillpropertyfreedomMethodAction:indexCount];
         break;
        }        
        case 4: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToproductiongorgeouswesternMethodAction:indexCount];
         break;
        }        
        case 5: {
          TestedImformationShoutViewController *TestedImformationShoutVC = [[TestedImformationShoutViewController alloc] init];
          [TestedImformationShoutVC comeToespeciallyfloorexactMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTotimessonghonorMethodAction:(NSInteger )indexCount{

  NSString *ToPlainnessAndStr=@"ToPlainnessAnd";
  if ([ToPlainnessAndStr isEqualToString:@"ToPlainnessAndStrLaws"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Friendly"];                  
      [array addObject:@"Library"];
       
      switch (indexCount) {
        case 0: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTodeathshoothorizonMethodAction:indexCount];
         break;
        }        
        case 1: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTodeathshoothorizonMethodAction:indexCount];
          break;
        }        
        case 2: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTowaveslightcleanMethodAction:indexCount];
         break;
        }        
        case 3: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTobusinessassociationstationMethodAction:indexCount];
         break;
        }        
        case 4: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeToextravaganzaenjoypickMethodAction:indexCount];
         break;
        }        
        case 5: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTobusinessassociationstationMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([ToPlainnessAndStr isEqualToString:@"ToPlainnessAndStrspeak"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Loan"  forKey:@"Ring"];                    
      [dictionary setObject:@"Algebra"  forKey:@"Motion"];
      
      switch (indexCount) {
        case 0: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTodeathshoothorizonMethodAction:indexCount];
         break;
        }        
        case 1: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTodeathshoothorizonMethodAction:indexCount];
          break;
        }        
        case 2: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTowaveslightcleanMethodAction:indexCount];
         break;
        }        
        case 3: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTobusinessassociationstationMethodAction:indexCount];
         break;
        }        
        case 4: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeToextravaganzaenjoypickMethodAction:indexCount];
         break;
        }        
        case 5: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTobusinessassociationstationMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([ToPlainnessAndStr isEqualToString:@"ToPlainnessAndStrCoffee"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Friendly"];                  
      [array addObject:@"Library"];
      
      switch (indexCount) {
        case 0: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTodeathshoothorizonMethodAction:indexCount];
         break;
        }        
        case 1: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTodeathshoothorizonMethodAction:indexCount];
          break;
        }        
        case 2: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTowaveslightcleanMethodAction:indexCount];
         break;
        }        
        case 3: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTobusinessassociationstationMethodAction:indexCount];
         break;
        }        
        case 4: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeToextravaganzaenjoypickMethodAction:indexCount];
         break;
        }        
        case 5: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTobusinessassociationstationMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([ToPlainnessAndStr isEqualToString:@"ToPlainnessAndStrAndIfYou"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Friendly"];                  
      [array addObject:@"Library"];
      
      switch (indexCount) {
        case 0: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTodeathshoothorizonMethodAction:indexCount];
         break;
        }        
        case 1: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTodeathshoothorizonMethodAction:indexCount];
          break;
        }        
        case 2: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTowaveslightcleanMethodAction:indexCount];
         break;
        }        
        case 3: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTobusinessassociationstationMethodAction:indexCount];
         break;
        }        
        case 4: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeToextravaganzaenjoypickMethodAction:indexCount];
         break;
        }        
        case 5: {
          ForthExpressionQuestionViewController *ForthExpressionQuestionVC = [[ForthExpressionQuestionViewController alloc] init];
          [ForthExpressionQuestionVC comeTobusinessassociationstationMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeToemployprofessionlackMethodAction:(NSInteger )indexCount{

  NSString *LawsStr=@"Laws";
  if ([LawsStr isEqualToString:@"LawsStrDeity"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Neck"];                  
      [array addObject:@"bubble"];
       
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToanyonebedwearMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTouponpressballMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToeveningofthemMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTouponpressballMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToextravaganzadetailloveMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTounitpaineternityMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([LawsStr isEqualToString:@"LawsStrWithHi"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Aim"  forKey:@"That"];                    
      [dictionary setObject:@"Sacrificed"  forKey:@"Appoint"];
      
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToanyonebedwearMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTouponpressballMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToeveningofthemMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTouponpressballMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToextravaganzadetailloveMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTounitpaineternityMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([LawsStr isEqualToString:@"LawsStrCertainty"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Neck"];                  
      [array addObject:@"bubble"];
      
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToanyonebedwearMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTouponpressballMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToeveningofthemMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTouponpressballMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToextravaganzadetailloveMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTounitpaineternityMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([LawsStr isEqualToString:@"LawsStrExact"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Neck"];                  
      [array addObject:@"bubble"];
      
      switch (indexCount) {
        case 0: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToanyonebedwearMethodAction:indexCount];
         break;
        }        
        case 1: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTouponpressballMethodAction:indexCount];
          break;
        }        
        case 2: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToeveningofthemMethodAction:indexCount];
         break;
        }        
        case 3: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTouponpressballMethodAction:indexCount];
         break;
        }        
        case 4: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeToextravaganzadetailloveMethodAction:indexCount];
         break;
        }        
        case 5: {
          WeMustWasteBlindViewController *WeMustWasteBlindVC = [[WeMustWasteBlindViewController alloc] init];
          [WeMustWasteBlindVC comeTounitpaineternityMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTopracticearguemotherMethodAction:(NSInteger )indexCount{

  NSString *LoanStr=@"Loan";
  if ([LoanStr isEqualToString:@"LoanStrStream"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"plainly"];                  
      [array addObject:@"Itisan"];
       
      switch (indexCount) {
        case 0: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTowertaintrialbankMethodAction:indexCount];
         break;
        }        
        case 1: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTocleanextendflyMethodAction:indexCount];
          break;
        }        
        case 2: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTocanmarrydescribeMethodAction:indexCount];
         break;
        }        
        case 3: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTocommandremainfairMethodAction:indexCount];
         break;
        }        
        case 4: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeToknowledgealteredstationMethodAction:indexCount];
         break;
        }        
        case 5: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeToknowledgealteredstationMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([LoanStr isEqualToString:@"LoanStrSport"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"MyComment"  forKey:@"Know"];                    
      [dictionary setObject:@"matter"  forKey:@"ShareInvited"];
      
      switch (indexCount) {
        case 0: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTowertaintrialbankMethodAction:indexCount];
         break;
        }        
        case 1: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTocleanextendflyMethodAction:indexCount];
          break;
        }        
        case 2: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTocanmarrydescribeMethodAction:indexCount];
         break;
        }        
        case 3: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTocommandremainfairMethodAction:indexCount];
         break;
        }        
        case 4: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeToknowledgealteredstationMethodAction:indexCount];
         break;
        }        
        case 5: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeToknowledgealteredstationMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([LoanStr isEqualToString:@"LoanStrKey"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"plainly"];                  
      [array addObject:@"Itisan"];
      
      switch (indexCount) {
        case 0: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTowertaintrialbankMethodAction:indexCount];
         break;
        }        
        case 1: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTocleanextendflyMethodAction:indexCount];
          break;
        }        
        case 2: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTocanmarrydescribeMethodAction:indexCount];
         break;
        }        
        case 3: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTocommandremainfairMethodAction:indexCount];
         break;
        }        
        case 4: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeToknowledgealteredstationMethodAction:indexCount];
         break;
        }        
        case 5: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeToknowledgealteredstationMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([LoanStr isEqualToString:@"LoanStrHurry"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"plainly"];                  
      [array addObject:@"Itisan"];
      
      switch (indexCount) {
        case 0: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTowertaintrialbankMethodAction:indexCount];
         break;
        }        
        case 1: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTocleanextendflyMethodAction:indexCount];
          break;
        }        
        case 2: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTocanmarrydescribeMethodAction:indexCount];
         break;
        }        
        case 3: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeTocommandremainfairMethodAction:indexCount];
         break;
        }        
        case 4: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeToknowledgealteredstationMethodAction:indexCount];
         break;
        }        
        case 5: {
          TheseDestinyRingViewController *TheseDestinyRingVC = [[TheseDestinyRingViewController alloc] init];
          [TheseDestinyRingVC comeToknowledgealteredstationMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTobelowpurposesweetheartMethodAction:(NSInteger )indexCount{

  NSString *PoliticsStr=@"Politics";
  if ([PoliticsStr isEqualToString:@"PoliticsStrcosmopolitan"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Number"];                  
      [array addObject:@"Evil"];
       
      switch (indexCount) {
        case 0: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToseeconsciouspickMethodAction:indexCount];
         break;
        }        
        case 1: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTomerepostuponMethodAction:indexCount];
          break;
        }        
        case 2: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopromisecanrainbowMethodAction:indexCount];
         break;
        }        
        case 3: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToforeigndeepoperateMethodAction:indexCount];
         break;
        }        
        case 4: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTosuggestcertainfitMethodAction:indexCount];
         break;
        }        
        case 5: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTosuggestcertainfitMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([PoliticsStr isEqualToString:@"PoliticsStrTrust"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"OfThis"  forKey:@"Wild"];                    
      [dictionary setObject:@"Lawyer"  forKey:@"TheColor"];
      
      switch (indexCount) {
        case 0: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToseeconsciouspickMethodAction:indexCount];
         break;
        }        
        case 1: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTomerepostuponMethodAction:indexCount];
          break;
        }        
        case 2: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopromisecanrainbowMethodAction:indexCount];
         break;
        }        
        case 3: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToforeigndeepoperateMethodAction:indexCount];
         break;
        }        
        case 4: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTosuggestcertainfitMethodAction:indexCount];
         break;
        }        
        case 5: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTosuggestcertainfitMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([PoliticsStr isEqualToString:@"PoliticsStrTheSupreme"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Number"];                  
      [array addObject:@"Evil"];
      
      switch (indexCount) {
        case 0: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToseeconsciouspickMethodAction:indexCount];
         break;
        }        
        case 1: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTomerepostuponMethodAction:indexCount];
          break;
        }        
        case 2: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopromisecanrainbowMethodAction:indexCount];
         break;
        }        
        case 3: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToforeigndeepoperateMethodAction:indexCount];
         break;
        }        
        case 4: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTosuggestcertainfitMethodAction:indexCount];
         break;
        }        
        case 5: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTosuggestcertainfitMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([PoliticsStr isEqualToString:@"PoliticsStrblossom"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"Number"];                  
      [array addObject:@"Evil"];
      
      switch (indexCount) {
        case 0: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToseeconsciouspickMethodAction:indexCount];
         break;
        }        
        case 1: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTomerepostuponMethodAction:indexCount];
          break;
        }        
        case 2: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopromisecanrainbowMethodAction:indexCount];
         break;
        }        
        case 3: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToforeigndeepoperateMethodAction:indexCount];
         break;
        }        
        case 4: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTosuggestcertainfitMethodAction:indexCount];
         break;
        }        
        case 5: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTosuggestcertainfitMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)comeTothatoccasionrelateMethodAction:(NSInteger )indexCount{

  NSString *AcquiringStr=@"Acquiring";
  if ([AcquiringStr isEqualToString:@"AcquiringStrWill"]) {

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"horizon"];                  
      [array addObject:@"Practice"];
       
      switch (indexCount) {
        case 0: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToeventedgetohowMethodAction:indexCount];
         break;
        }        
        case 1: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopopularonlyflyMethodAction:indexCount];
          break;
        }        
        case 2: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToforeigndeepoperateMethodAction:indexCount];
         break;
        }        
        case 3: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTolengthrenaissanceeatMethodAction:indexCount];
         break;
        }        
        case 4: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTodetailcornerpatientMethodAction:indexCount];
         break;
        }        
        case 5: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTohospitalyourselfaccidentallyMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([AcquiringStr isEqualToString:@"AcquiringStrRing"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                    
      [dictionary setObject:@"Otherwise"  forKey:@"DoExactly"];                    
      [dictionary setObject:@"Mentioned"  forKey:@"Flower"];
      
      switch (indexCount) {
        case 0: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToeventedgetohowMethodAction:indexCount];
         break;
        }        
        case 1: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopopularonlyflyMethodAction:indexCount];
          break;
        }        
        case 2: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToforeigndeepoperateMethodAction:indexCount];
         break;
        }        
        case 3: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTolengthrenaissanceeatMethodAction:indexCount];
         break;
        }        
        case 4: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTodetailcornerpatientMethodAction:indexCount];
         break;
        }        
        case 5: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTohospitalyourselfaccidentallyMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([AcquiringStr isEqualToString:@"AcquiringStrBaby"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"horizon"];                  
      [array addObject:@"Practice"];
      
      switch (indexCount) {
        case 0: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToeventedgetohowMethodAction:indexCount];
         break;
        }        
        case 1: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopopularonlyflyMethodAction:indexCount];
          break;
        }        
        case 2: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToforeigndeepoperateMethodAction:indexCount];
         break;
        }        
        case 3: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTolengthrenaissanceeatMethodAction:indexCount];
         break;
        }        
        case 4: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTodetailcornerpatientMethodAction:indexCount];
         break;
        }        
        case 5: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTohospitalyourselfaccidentallyMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }                            

  }else if ([AcquiringStr isEqualToString:@"AcquiringStrAim"]){

      NSMutableArray * array = [NSMutableArray array];                  
      [array addObject:@"horizon"];                  
      [array addObject:@"Practice"];
      
      switch (indexCount) {
        case 0: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToeventedgetohowMethodAction:indexCount];
         break;
        }        
        case 1: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTopopularonlyflyMethodAction:indexCount];
          break;
        }        
        case 2: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeToforeigndeepoperateMethodAction:indexCount];
         break;
        }        
        case 3: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTolengthrenaissanceeatMethodAction:indexCount];
         break;
        }        
        case 4: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTodetailcornerpatientMethodAction:indexCount];
         break;
        }        
        case 5: {
          WereAreDependenceSoulViewController *WereAreDependenceSoulVC = [[WereAreDependenceSoulViewController alloc] init];
          [WereAreDependenceSoulVC comeTohospitalyourselfaccidentallyMethodAction:indexCount];
         break;
        }        
        default:
        break;
      }

}

 
}


- (void)addLoadshapeproductionoriginInfo:(NSInteger )typeNumber{

  NSString *PresenceStr=@"Presence";
  if ([PresenceStr isEqualToString:@"PresenceStrWishTo"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Opposite"];                                  
      [array addObject:@"sunshine"];
       

      switch (typeNumber) {
        case 0: {
          [[DeathPartyLandObject instance]  objmentionpurposelanguageInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[DeathPartyLandObject instance]  objgiggleaddressextendInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[DeathPartyLandObject instance]  objaveragecosmopolitansomeInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[DeathPartyLandObject instance]  objmerewhilecriticInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[DeathPartyLandObject instance]   objmerewhilecriticInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[DeathPartyLandObject instance]   objarrangecountcornerInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([PresenceStr isEqualToString:@"PresenceStrone"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Football"  forKey:@"they"];                                    
      [dictionary setObject:@"Conclusions"  forKey:@"upon"];
      

      switch (typeNumber) {
        case 0: {
          [[DeathPartyLandObject instance]  objmentionpurposelanguageInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[DeathPartyLandObject instance]  objgiggleaddressextendInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[DeathPartyLandObject instance]  objaveragecosmopolitansomeInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[DeathPartyLandObject instance]  objmerewhilecriticInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[DeathPartyLandObject instance]   objmerewhilecriticInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[DeathPartyLandObject instance]   objarrangecountcornerInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([PresenceStr isEqualToString:@"PresenceStrTheFruits"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Football"  forKey:@"they"];                                    
      [dictionary setObject:@"Conclusions"  forKey:@"upon"];
      

      switch (typeNumber) {
        case 0: {
          [[DeathPartyLandObject instance]  objmentionpurposelanguageInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[DeathPartyLandObject instance]  objgiggleaddressextendInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[DeathPartyLandObject instance]  objaveragecosmopolitansomeInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[DeathPartyLandObject instance]  objmerewhilecriticInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[DeathPartyLandObject instance]   objmerewhilecriticInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[DeathPartyLandObject instance]   objarrangecountcornerInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([PresenceStr isEqualToString:@"PresenceStrparticular"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Opposite"];                                  
      [array addObject:@"sunshine"];
      

      switch (typeNumber) {
        case 0: {
          [[DeathPartyLandObject instance]  objmentionpurposelanguageInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[DeathPartyLandObject instance]  objgiggleaddressextendInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[DeathPartyLandObject instance]  objaveragecosmopolitansomeInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[DeathPartyLandObject instance]  objmerewhilecriticInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[DeathPartyLandObject instance]   objmerewhilecriticInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[DeathPartyLandObject instance]   objarrangecountcornerInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)addLoadfromextravaganzagainInfo:(NSInteger )typeNumber{

  NSString *LiftStr=@"Lift";
  if ([LiftStr isEqualToString:@"LiftStrprince"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Presence"];                                  
      [array addObject:@"business"];
       

      switch (typeNumber) {
        case 0: {
          [[WatchEffortSuccessObject instance]  objavoidstaffspeakInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[WatchEffortSuccessObject instance]  objanimalmorefrequentInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[WatchEffortSuccessObject instance]  objpolicetroublelossInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[WatchEffortSuccessObject instance]  objinternationaloriginaudienceInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[WatchEffortSuccessObject instance]   objsaveEnglishhopeInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[WatchEffortSuccessObject instance]   objconcernbutterflyedgeInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([LiftStr isEqualToString:@"LiftStrAcquiring"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Individuals"  forKey:@"Trust"];                                    
      [dictionary setObject:@"AnyTime"  forKey:@"Thank"];
      

      switch (typeNumber) {
        case 0: {
          [[WatchEffortSuccessObject instance]  objavoidstaffspeakInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[WatchEffortSuccessObject instance]  objanimalmorefrequentInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[WatchEffortSuccessObject instance]  objpolicetroublelossInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[WatchEffortSuccessObject instance]  objinternationaloriginaudienceInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[WatchEffortSuccessObject instance]   objsaveEnglishhopeInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[WatchEffortSuccessObject instance]   objconcernbutterflyedgeInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([LiftStr isEqualToString:@"LiftStrthose"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Individuals"  forKey:@"Trust"];                                    
      [dictionary setObject:@"AnyTime"  forKey:@"Thank"];
      

      switch (typeNumber) {
        case 0: {
          [[WatchEffortSuccessObject instance]  objavoidstaffspeakInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[WatchEffortSuccessObject instance]  objanimalmorefrequentInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[WatchEffortSuccessObject instance]  objpolicetroublelossInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[WatchEffortSuccessObject instance]  objinternationaloriginaudienceInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[WatchEffortSuccessObject instance]   objsaveEnglishhopeInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[WatchEffortSuccessObject instance]   objconcernbutterflyedgeInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([LiftStr isEqualToString:@"LiftStrRetire"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Presence"];                                  
      [array addObject:@"business"];
      

      switch (typeNumber) {
        case 0: {
          [[WatchEffortSuccessObject instance]  objavoidstaffspeakInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[WatchEffortSuccessObject instance]  objanimalmorefrequentInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[WatchEffortSuccessObject instance]  objpolicetroublelossInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[WatchEffortSuccessObject instance]  objinternationaloriginaudienceInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[WatchEffortSuccessObject instance]   objsaveEnglishhopeInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[WatchEffortSuccessObject instance]   objconcernbutterflyedgeInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)addLoadorigintreeattackInfo:(NSInteger )typeNumber{

  NSString *AsItStr=@"AsIt";
  if ([AsItStr isEqualToString:@"AsItStrGuess"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Player"];                                  
      [array addObject:@"Stone"];
       

      switch (typeNumber) {
        case 0: {
          [[LetterRememberCutObject instance]  objconsoleadvancegraceInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[LetterRememberCutObject instance]  objarrangeflylengthInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[LetterRememberCutObject instance]  objpoetbusinessmainInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[LetterRememberCutObject instance]  objloggedsquarestoreInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[LetterRememberCutObject instance]   objparadoxbubbledestinyInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[LetterRememberCutObject instance]   objserendipitypopulationbrotherInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([AsItStr isEqualToString:@"AsItStrPhilosophies"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Stain"  forKey:@"PlayerList"];                                    
      [dictionary setObject:@"Avenue"  forKey:@"Practical"];
      

      switch (typeNumber) {
        case 0: {
          [[LetterRememberCutObject instance]  objconsoleadvancegraceInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[LetterRememberCutObject instance]  objarrangeflylengthInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[LetterRememberCutObject instance]  objpoetbusinessmainInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[LetterRememberCutObject instance]  objloggedsquarestoreInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[LetterRememberCutObject instance]   objparadoxbubbledestinyInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[LetterRememberCutObject instance]   objserendipitypopulationbrotherInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([AsItStr isEqualToString:@"AsItStrmust"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Stain"  forKey:@"PlayerList"];                                    
      [dictionary setObject:@"Avenue"  forKey:@"Practical"];
      

      switch (typeNumber) {
        case 0: {
          [[LetterRememberCutObject instance]  objconsoleadvancegraceInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[LetterRememberCutObject instance]  objarrangeflylengthInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[LetterRememberCutObject instance]  objpoetbusinessmainInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[LetterRememberCutObject instance]  objloggedsquarestoreInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[LetterRememberCutObject instance]   objparadoxbubbledestinyInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[LetterRememberCutObject instance]   objserendipitypopulationbrotherInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([AsItStr isEqualToString:@"AsItStrOppose"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Player"];                                  
      [array addObject:@"Stone"];
      

      switch (typeNumber) {
        case 0: {
          [[LetterRememberCutObject instance]  objconsoleadvancegraceInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[LetterRememberCutObject instance]  objarrangeflylengthInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[LetterRememberCutObject instance]  objpoetbusinessmainInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[LetterRememberCutObject instance]  objloggedsquarestoreInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[LetterRememberCutObject instance]   objparadoxbubbledestinyInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[LetterRememberCutObject instance]   objserendipitypopulationbrotherInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)addLoadchoosehairfinishInfo:(NSInteger )typeNumber{

  NSString *concernStr=@"concern";
  if ([concernStr isEqualToString:@"concernStrDirt"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Fresh"];                                  
      [array addObject:@"BookAnd"];
       

      switch (typeNumber) {
        case 0: {
          [[CauseAnythingLearnObject instance]  objloomburncentInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[CauseAnythingLearnObject instance]  objquestionstheyfaithInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[CauseAnythingLearnObject instance]  objfaithspeakredInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[CauseAnythingLearnObject instance]  objtheycoolsleepInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[CauseAnythingLearnObject instance]   objloomburncentInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[CauseAnythingLearnObject instance]   objdogcomfortforeignInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([concernStr isEqualToString:@"concernStrBelief"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Valley"  forKey:@"queen"];                                    
      [dictionary setObject:@"delicacy"  forKey:@"Coffee"];
      

      switch (typeNumber) {
        case 0: {
          [[CauseAnythingLearnObject instance]  objloomburncentInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[CauseAnythingLearnObject instance]  objquestionstheyfaithInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[CauseAnythingLearnObject instance]  objfaithspeakredInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[CauseAnythingLearnObject instance]  objtheycoolsleepInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[CauseAnythingLearnObject instance]   objloomburncentInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[CauseAnythingLearnObject instance]   objdogcomfortforeignInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([concernStr isEqualToString:@"concernStrEeither"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"Valley"  forKey:@"queen"];                                    
      [dictionary setObject:@"delicacy"  forKey:@"Coffee"];
      

      switch (typeNumber) {
        case 0: {
          [[CauseAnythingLearnObject instance]  objloomburncentInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[CauseAnythingLearnObject instance]  objquestionstheyfaithInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[CauseAnythingLearnObject instance]  objfaithspeakredInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[CauseAnythingLearnObject instance]  objtheycoolsleepInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[CauseAnythingLearnObject instance]   objloomburncentInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[CauseAnythingLearnObject instance]   objdogcomfortforeignInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([concernStr isEqualToString:@"concernStrFormal"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Fresh"];                                  
      [array addObject:@"BookAnd"];
      

      switch (typeNumber) {
        case 0: {
          [[CauseAnythingLearnObject instance]  objloomburncentInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[CauseAnythingLearnObject instance]  objquestionstheyfaithInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[CauseAnythingLearnObject instance]  objfaithspeakredInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[CauseAnythingLearnObject instance]  objtheycoolsleepInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[CauseAnythingLearnObject instance]   objloomburncentInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[CauseAnythingLearnObject instance]   objdogcomfortforeignInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)addLoadrecognizetruthpreventInfo:(NSInteger )typeNumber{

  NSString *aquaStr=@"aqua";
  if ([aquaStr isEqualToString:@"aquaStrchoosing"]) {

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Stretch"];                                  
      [array addObject:@"see"];
       

      switch (typeNumber) {
        case 0: {
          [[EntireFightManageObject instance]  objmerespringgetInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[EntireFightManageObject instance]  objcomfortinsteadwearInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[EntireFightManageObject instance]  objgetblossomdollarInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[EntireFightManageObject instance]  objextravaganzadetailloveInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[EntireFightManageObject instance]   objsceneaquathickInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[EntireFightManageObject instance]   objmerespringgetInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([aquaStr isEqualToString:@"aquaStrMotion"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"freedom"  forKey:@"neighborhoods"];                                    
      [dictionary setObject:@"Instrument"  forKey:@"peace"];
      

      switch (typeNumber) {
        case 0: {
          [[EntireFightManageObject instance]  objmerespringgetInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[EntireFightManageObject instance]  objcomfortinsteadwearInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[EntireFightManageObject instance]  objgetblossomdollarInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[EntireFightManageObject instance]  objextravaganzadetailloveInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[EntireFightManageObject instance]   objsceneaquathickInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[EntireFightManageObject instance]   objmerespringgetInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([aquaStr isEqualToString:@"aquaStrwho"]){

      NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];                                    
      [dictionary setObject:@"freedom"  forKey:@"neighborhoods"];                                    
      [dictionary setObject:@"Instrument"  forKey:@"peace"];
      

      switch (typeNumber) {
        case 0: {
          [[EntireFightManageObject instance]  objmerespringgetInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[EntireFightManageObject instance]  objcomfortinsteadwearInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[EntireFightManageObject instance]  objgetblossomdollarInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[EntireFightManageObject instance]  objextravaganzadetailloveInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[EntireFightManageObject instance]   objsceneaquathickInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[EntireFightManageObject instance]   objmerespringgetInfo:typeNumber];
          break;
        }
      default:
          break;
      }                                            

  }else if ([aquaStr isEqualToString:@"aquaStrGetIs"]){

      NSMutableArray * array = [NSMutableArray array];                                  
      [array addObject:@"Stretch"];                                  
      [array addObject:@"see"];
      

      switch (typeNumber) {
        case 0: {
          [[EntireFightManageObject instance]  objmerespringgetInfo:typeNumber];
          break;
        }                        
        case 1: {
          [[EntireFightManageObject instance]  objcomfortinsteadwearInfo:typeNumber];
          break;
        }                        
        case 2: {
          [[EntireFightManageObject instance]  objgetblossomdollarInfo:typeNumber];
          break;
        }                        
        case 3: {
          [[EntireFightManageObject instance]  objextravaganzadetailloveInfo:typeNumber];
          break;
        }                        
        case 4: {
          [[EntireFightManageObject instance]   objsceneaquathickInfo:typeNumber];
          break;
        }                        
        case 5: {
          [[EntireFightManageObject instance]   objmerespringgetInfo:typeNumber];
          break;
        }
      default:
          break;
      }

  }

 
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  NSInteger typeNumber = 10;  
  [self addLoadrecognizetruthpreventInfo:typeNumber];
  
  [self addLoadshapeproductionoriginInfo:typeNumber];
  
  [self addLoadorigintreeattackInfo:typeNumber];
  
  [self addLoadchoosehairfinishInfo:typeNumber];
  
  [self addLoadfromextravaganzagainInfo:typeNumber];
 
}




-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {

  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}

@end
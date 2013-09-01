//
//  WUEmoticonsKeyboardToolsView.h
//  WeicoUI
//
//  Created by YuAo on 1/25/13.
//  Copyright (c) 2013 微酷奥(北京)科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUEmoticonsKeyboardKeyItemGroup.h"

@interface WUEmoticonsKeyboardToolsView : UIView

@property (nonatomic,strong) NSArray *keyItemGroups;

@property (nonatomic,copy)   void    (^keyboardSwitchButtonTappedBlock)(void);
@property (nonatomic,copy)   void    (^backspaceButtonTappedBlock)(void);
@property (nonatomic,copy)   void    (^keyItemGroupSelectedBlock)(WUEmoticonsKeyboardKeyItemGroup *keyItemGroup);

@property (nonatomic,weak,readonly) UIButton *keyboardSwitchButton;
@property (nonatomic,weak,readonly) UIButton *backspaceButton;

@end

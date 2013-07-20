//
//  UIResponder+writeableInputView.h
//  WeicoUI
//
//  Created by YuAo on 1/24/13.
//  Copyright (c) 2013 微酷奥(北京)科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (WriteableInputView)
@property (readwrite, retain) UIView *inputView;
@end

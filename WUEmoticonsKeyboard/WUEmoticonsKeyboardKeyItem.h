//
//  WUEmoticonsKeyboardKeyItem.h
//  WeicoUI
//
//  Created by YuAo on 1/24/13.
//  Copyright (c) 2013 微酷奥(北京)科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WUEmoticonsKeyboardKeyItem : NSObject
@property (nonatomic,copy)    NSString *title;
@property (nonatomic,strong)  UIImage  *image;
@property (nonatomic,copy)    NSString *textToInput;
@end

//
//  WUEmoticonsKeyboardKeyCell.h
//  WeicoUI
//
//  Created by YuAo on 1/24/13.
//  Copyright (c) 2013 微酷奥(北京)科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUEmoticonsKeyboardKeyItem.h"

@interface WUEmoticonsKeyboardKeyCell : UICollectionViewCell
@property (nonatomic,weak,readonly) UIButton *keyButton;
@property (nonatomic,strong) WUEmoticonsKeyboardKeyItem *keyItem;
@end

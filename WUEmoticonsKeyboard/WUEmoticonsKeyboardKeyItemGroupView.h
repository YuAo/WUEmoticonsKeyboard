//
//  WUEmoticonsKeyboardKeyItemGroupView.h
//  WeicoUI
//
//  Created by YuAo on 1/25/13.
//  Copyright (c) 2013 微酷奥(北京)科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUEmoticonsKeyboardKeyItemGroup.h"
#import "WUEmoticonsKeyboardKeyItem.h"
#import "WUEmoticonsKeyboardKeyCell.h"

@interface WUEmoticonsKeyboardKeyItemGroupView : UIView
@property (nonatomic,strong)        WUEmoticonsKeyboardKeyItemGroup *keyItemGroup;
@property (nonatomic,copy)          void                            (^keyItemTappedBlock)(WUEmoticonsKeyboardKeyItem *keyItem);
@property (nonatomic,copy)          void                            (^pressedKeyItemCellChangedBlock)(WUEmoticonsKeyboardKeyCell *fromKeyCell, WUEmoticonsKeyboardKeyCell *toKeyCell);
@property (nonatomic,weak,readonly) UIImageView                     *backgroundImageView;
@end

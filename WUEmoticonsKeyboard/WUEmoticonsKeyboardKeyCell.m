//
//  WUEmoticonsKeyboardKeyCell.m
//  WeicoUI
//
//  Created by YuAo on 1/24/13.
//  Copyright (c) 2013 微酷奥(北京)科技有限公司. All rights reserved.
//

#import "WUEmoticonsKeyboardKeyCell.h"

@interface WUEmoticonsKeyboardKeyCell ()
@property (nonatomic,weak,readwrite) UIButton *keyButton;
@end

@implementation WUEmoticonsKeyboardKeyCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = NO;
        button.frame = self.contentView.bounds;
        [self.contentView addSubview:button];
        self.keyButton = button;
    }
    return self;
}

- (void)setKeyItem:(WUEmoticonsKeyboardKeyItem *)keyItem {
    _keyItem = keyItem;
    if (self.keyItem.image) {
        [self.keyButton setTitle:nil forState:UIControlStateNormal];
        [self.keyButton setImage:self.keyItem.image forState:UIControlStateNormal];
    }else{
        [self.keyButton setImage:nil forState:UIControlStateNormal];
        [self.keyButton setTitle:self.keyItem.title forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj respondsToSelector:@selector(setSelected:)]) {
            [obj setSelected:selected];
        }
    }];
}

@end

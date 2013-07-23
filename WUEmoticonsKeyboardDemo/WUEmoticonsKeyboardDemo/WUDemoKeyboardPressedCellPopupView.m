//
//  WPKeyboardPressedCellPopupView.m
//  WeicoPlusUniversal
//
//  Created by YuAo on 2/1/13.
//  Copyright (c) 2013 北京微酷奥网络技术有限公司. All rights reserved.
//

#import "WUDemoKeyboardPressedCellPopupView.h"

@interface WUDemoKeyboardPressedCellPopupView ()
@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UILabel  *textLabel;
@end

@implementation WUDemoKeyboardPressedCellPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *popupBackground = [UIImage imageNamed:@"keyboard_popup"];
        UIImageView *popupBackgroundView = [[UIImageView alloc] initWithImage:popupBackground];
        [self addSubview:popupBackgroundView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        self.imageView = imageView;

        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:11];
        textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(25, 9, 32, 32);
    self.textLabel.frame = CGRectMake(10, 41, 63, 18);
}

- (void)setKeyItem:(WUEmoticonsKeyboardKeyItem *)keyItem {
    _keyItem = keyItem;
    self.textLabel.text = keyItem.textToInput;
    self.imageView.image = keyItem.image;
}

@end

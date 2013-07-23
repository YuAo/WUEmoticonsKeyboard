//
//  WPEmoticonsKeyboardTextKeyCell.m
//  WeicoPlusUniversal
//
//  Created by YuAo on 2/1/13.
//  Copyright (c) 2013 北京微酷奥网络技术有限公司. All rights reserved.
//

#import "WUDemoKeyboardTextKeyCell.h"

@implementation WUDemoKeyboardTextKeyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.keyButton.bounds = self.bounds;
        self.keyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.keyButton setTitleColor:[UIColor colorWithWhite:41/255.0 alpha:1] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.backgroundColor = nil;
    }
}

@end

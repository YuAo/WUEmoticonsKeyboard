//
//  WUEmoticonsKeyboardToolsView.m
//  WeicoUI
//
//  Created by YuAo on 1/25/13.
//  Copyright (c) 2013 微酷奥(北京)科技有限公司. All rights reserved.
//

#import "WUEmoticonsKeyboardToolsView.h"

CGFloat const WUEmoticonsKeyboardToolsViewHeight            = 45;
CGSize  const WUEmoticonsKeyboardToolsViewActionButtonSize  = (CGSize){45,WUEmoticonsKeyboardToolsViewHeight};

@interface WUEmoticonsKeyboardToolsView ()
@property (nonatomic,weak,readwrite) UIButton           *keyboardSwitchButton;
@property (nonatomic,weak,readwrite) UIButton           *backspaceButton;
@property (nonatomic,weak)           UISegmentedControl *segmentedControl;
@end

@implementation WUEmoticonsKeyboardToolsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = (CGRect){frame.origin,{CGRectGetWidth(frame),WUEmoticonsKeyboardToolsViewHeight}};
        
        UIButton *keyboardSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        keyboardSwitchButton.frame = (CGRect){CGPointZero,WUEmoticonsKeyboardToolsViewActionButtonSize};
        keyboardSwitchButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        [keyboardSwitchButton addTarget:self action:@selector(keyboardSwitchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:keyboardSwitchButton];
        self.keyboardSwitchButton = keyboardSwitchButton;
        
        UIButton *backspaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backspaceButton.frame = (CGRect){ {CGRectGetWidth(self.bounds) - WUEmoticonsKeyboardToolsViewActionButtonSize.width, 0} ,WUEmoticonsKeyboardToolsViewActionButtonSize};
        backspaceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [backspaceButton addTarget:self action:@selector(backspaceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backspaceButton];
        self.backspaceButton = backspaceButton;
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(WUEmoticonsKeyboardToolsViewActionButtonSize.width, 0, CGRectGetWidth(self.bounds) - WUEmoticonsKeyboardToolsViewActionButtonSize.width * 2, CGRectGetHeight(frame))];
        segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:segmentedControl];
        self.segmentedControl = segmentedControl;
    }
    return self;
}

- (void)setKeyItemGroups:(NSArray *)keyItemGroups {
    _keyItemGroups = keyItemGroups;
    [self.segmentedControl removeAllSegments];
    [self.keyItemGroups enumerateObjectsUsingBlock:^(WUEmoticonsKeyboardKeyItemGroup *obj, NSUInteger idx, BOOL *stop) {
        if (obj.image) {
            [self.segmentedControl insertSegmentWithImage:obj.image atIndex:self.segmentedControl.numberOfSegments animated:NO];
        }else{
            [self.segmentedControl insertSegmentWithTitle:obj.title atIndex:self.segmentedControl.numberOfSegments animated:NO];
        }
    }];
    if (self.segmentedControl.numberOfSegments) {
        self.segmentedControl.selectedSegmentIndex = 0;
        [self segmentedControlValueChanged:self.segmentedControl];
    }
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
    [self.keyItemGroups enumerateObjectsUsingBlock:^(WUEmoticonsKeyboardKeyItemGroup *obj, NSUInteger idx, BOOL *stop) {
        if (obj.image) {
            if (obj.selectedImage && idx == self.segmentedControl.selectedSegmentIndex) {
                [self.segmentedControl setImage:obj.selectedImage forSegmentAtIndex:idx];
            } else {
                [self.segmentedControl setImage:obj.image forSegmentAtIndex:idx];                
            }
        } else {
            [self.segmentedControl setTitle:obj.title forSegmentAtIndex:idx];
        }
    }];
    if (self.keyItemGroupSelectedBlock) {
        WUEmoticonsKeyboardKeyItemGroup *selectedKeyItemGroup = [self.keyItemGroups objectAtIndex:self.segmentedControl.selectedSegmentIndex];
        self.keyItemGroupSelectedBlock(selectedKeyItemGroup);
    }
}

- (void)keyboardSwitchButtonTapped:(UIButton *)sender {
    if (self.keyboardSwitchButtonTappedBlock) {
        self.keyboardSwitchButtonTappedBlock();
    }
}

- (void)backspaceButtonTapped:(UIButton *)sender {
    if (self.backspaceButtonTappedBlock) {
        self.backspaceButtonTappedBlock();
    }
}

@end

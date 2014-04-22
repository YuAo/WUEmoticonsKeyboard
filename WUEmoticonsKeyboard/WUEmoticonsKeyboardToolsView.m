//
//  WUEmoticonsKeyboardToolsView.m
//  WeicoUI
//
//  Created by YuAo on 1/25/13.
//  Copyright (c) 2013 微酷奥(北京)科技有限公司. All rights reserved.
//

#import "WUEmoticonsKeyboardToolsView.h"

@interface WUEmoticonsKeyboardToolsView ()
@property (nonatomic,weak,readwrite) UIButton           *keyboardSwitchButton;
@property (nonatomic,weak,readwrite) UIButton           *backspaceButton;
@property (nonatomic,weak,readwrite) UIButton           *spaceButton;
@property (nonatomic,weak)           UISegmentedControl *segmentedControl;
@end

@implementation WUEmoticonsKeyboardToolsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *keyboardSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        keyboardSwitchButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
        [keyboardSwitchButton addTarget:self action:@selector(keyboardSwitchButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:keyboardSwitchButton];
        self.keyboardSwitchButton = keyboardSwitchButton;
        
        UIButton *backspaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backspaceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [backspaceButton addTarget:self action:@selector(backspaceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backspaceButton];
        self.backspaceButton = backspaceButton;
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
        segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:segmentedControl];
        self.segmentedControl = segmentedControl;
        
        UIButton *spaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        spaceButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [spaceButton addTarget:self action:@selector(spaceButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:spaceButton];
        self.spaceButton = spaceButton;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize keyboardSwitchButtonSize = [self.keyboardSwitchButton sizeThatFits:self.bounds.size];
    CGSize backspaceButtonSize = [self.backspaceButton sizeThatFits:self.bounds.size];
    
    self.keyboardSwitchButton.frame = (CGRect){CGPointZero,keyboardSwitchButtonSize};
    self.backspaceButton.frame = (CGRect){ {CGRectGetWidth(self.bounds) - backspaceButtonSize.width, 0} ,backspaceButtonSize};
    self.spaceButton.frame = self.segmentedControl.frame = CGRectMake(keyboardSwitchButtonSize.width, 0, CGRectGetWidth(self.bounds) - keyboardSwitchButtonSize.width - backspaceButtonSize.width, CGRectGetHeight(self.bounds));
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
    
    if (keyItemGroups.count > 1) {
        self.segmentedControl.hidden = NO;
        self.spaceButton.hidden = YES;
    } else {
        self.segmentedControl.hidden = YES;
        self.spaceButton.hidden = NO;
    }
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
    [self.keyItemGroups enumerateObjectsUsingBlock:^(WUEmoticonsKeyboardKeyItemGroup *obj, NSUInteger idx, BOOL *stop) {
        if (obj.image) {
            if (obj.selectedImage && (NSInteger)idx == self.segmentedControl.selectedSegmentIndex) {
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

- (void)spaceButtonTapped:(UIButton *)sender {
    if (self.spaceButtonTappedBlock) {
        self.spaceButtonTappedBlock();
    }
}

@end

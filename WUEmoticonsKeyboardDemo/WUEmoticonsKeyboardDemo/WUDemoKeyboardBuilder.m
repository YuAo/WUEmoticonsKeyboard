//
//  WUDemoKeyboardBuilder.m
//  WUEmoticonsKeyboardDemo
//
//  Created by YuAo on 7/20/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import "WUDemoKeyboardBuilder.h"
#import "WUDemoKeyboardTextKeyCell.h"
#import "WUDemoKeyboardPressedCellPopupView.h"

@implementation WUDemoKeyboardBuilder

+ (WUEmoticonsKeyboard *)sharedEmoticonsKeyboard {
    static WUEmoticonsKeyboard *_sharedEmoticonsKeyboard;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //create a keyboard of default size
        WUEmoticonsKeyboard *keyboard = [WUEmoticonsKeyboard keyboard];
        
        //Icon keys
        WUEmoticonsKeyboardKeyItem *loveKey = [[WUEmoticonsKeyboardKeyItem alloc] init];
        loveKey.image = [UIImage imageNamed:@"love"];
        loveKey.textToInput = @"[love]";
        
        WUEmoticonsKeyboardKeyItem *applaudKey = [[WUEmoticonsKeyboardKeyItem alloc] init];
        applaudKey.image = [UIImage imageNamed:@"applaud"];
        applaudKey.textToInput = @"[applaud]";
        
        WUEmoticonsKeyboardKeyItem *weicoKey = [[WUEmoticonsKeyboardKeyItem alloc] init];
        weicoKey.image = [UIImage imageNamed:@"weico"];
        weicoKey.textToInput = @"[weico]";
        
        //Icon key group
        WUEmoticonsKeyboardKeyItemGroup *imageIconsGroup = [[WUEmoticonsKeyboardKeyItemGroup alloc] init];
        imageIconsGroup.keyItems = @[loveKey,applaudKey,weicoKey];
        imageIconsGroup.image = [UIImage imageNamed:@"keyboard_emotion"];
        imageIconsGroup.selectedImage = [UIImage imageNamed:@"keyboard_emotion_selected"];
        
        //Text keys
        NSArray *textKeys = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EmotionTextKeys" ofType:@"plist"]];
        
        NSMutableArray *textKeyItems = [NSMutableArray array];
        for (NSString *text in textKeys) {
            WUEmoticonsKeyboardKeyItem *keyItem = [[WUEmoticonsKeyboardKeyItem alloc] init];
            keyItem.title = text;
            keyItem.textToInput = text;
            [textKeyItems addObject:keyItem];
        }
        
        //Text key group
        WUEmoticonsKeyboardKeysPageFlowLayout *textIconsLayout = [[WUEmoticonsKeyboardKeysPageFlowLayout alloc] init];
        textIconsLayout.itemSize = CGSizeMake(80, 142/3.0);
        textIconsLayout.itemSpacing = 0;
        textIconsLayout.lineSpacing = 0;
        textIconsLayout.pageContentInsets = UIEdgeInsetsMake(0,0,0,0);
        
        WUEmoticonsKeyboardKeyItemGroup *textIconsGroup = [[WUEmoticonsKeyboardKeyItemGroup alloc] init];
        textIconsGroup.keyItems = textKeyItems;
        textIconsGroup.keyItemsLayout = textIconsLayout;
        textIconsGroup.keyItemCellClass = WUDemoKeyboardTextKeyCell.class;
        textIconsGroup.image = [UIImage imageNamed:@"keyboard_text"];
        textIconsGroup.selectedImage = [UIImage imageNamed:@"keyboard_text_selected"];
        
        //Set keyItemGroups
        keyboard.keyItemGroups = @[imageIconsGroup,textIconsGroup];
        
        //Setup cell popup view
        [keyboard setKeyItemGroupPressedKeyCellChangedBlock:^(WUEmoticonsKeyboardKeyItemGroup *keyItemGroup, WUEmoticonsKeyboardKeyCell *fromCell, WUEmoticonsKeyboardKeyCell *toCell) {
            [WUDemoKeyboardBuilder sharedEmotionsKeyboardKeyItemGroup:keyItemGroup pressedKeyCellChangedFromCell:fromCell toCell:toCell];
        }];

        //Keyboard appearance
        
        //Custom text icons scroll background
        UIView *textGridBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [textIconsLayout collectionViewContentSize].width, [textIconsLayout collectionViewContentSize].height)];
        textGridBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        textGridBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"keyboard_grid_bg"]];
        [textIconsLayout.collectionView addSubview:textGridBackgroundView];
        
        //Custom utility keys
        [keyboard setImage:[UIImage imageNamed:@"keyboard_switch"] forButton:WUEmoticonsKeyboardButtonKeyboardSwitch state:UIControlStateNormal];
        [keyboard setImage:[UIImage imageNamed:@"keyboard_del"] forButton:WUEmoticonsKeyboardButtonBackspace state:UIControlStateNormal];
        [keyboard setImage:[UIImage imageNamed:@"keyboard_switch_pressed"] forButton:WUEmoticonsKeyboardButtonKeyboardSwitch state:UIControlStateHighlighted];
        [keyboard setImage:[UIImage imageNamed:@"keyboard_del_pressed"] forButton:WUEmoticonsKeyboardButtonBackspace state:UIControlStateHighlighted];
        
        //Keyboard background
        [keyboard setBackgroundImage:[[UIImage imageNamed:@"keyboard_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)]];
        
        //SegmentedControl
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setBackgroundImage:[[UIImage imageNamed:@"keyboard_segment_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setBackgroundImage:[[UIImage imageNamed:@"keyboard_segment_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setDividerImage:[UIImage imageNamed:@"keyboard_segment_normal_selected"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        [[UISegmentedControl appearanceWhenContainedIn:[WUEmoticonsKeyboard class], nil] setDividerImage:[UIImage imageNamed:@"keyboard_segment_selected_normal"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
                
        _sharedEmoticonsKeyboard = keyboard;
    });
    return _sharedEmoticonsKeyboard;
}

+ (void)sharedEmotionsKeyboardKeyItemGroup:(WUEmoticonsKeyboardKeyItemGroup *)keyItemGroup
             pressedKeyCellChangedFromCell:(WUEmoticonsKeyboardKeyCell *)fromCell
                                    toCell:(WUEmoticonsKeyboardKeyCell *)toCell
{
    static WUDemoKeyboardPressedCellPopupView *pressedKeyCellPopupView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pressedKeyCellPopupView = [[WUDemoKeyboardPressedCellPopupView alloc] initWithFrame:CGRectMake(0, 0, 83, 110)];
        pressedKeyCellPopupView.hidden = YES;
        [[self sharedEmoticonsKeyboard] addSubview:pressedKeyCellPopupView];
    });
    
    if ([[self sharedEmoticonsKeyboard].keyItemGroups indexOfObject:keyItemGroup] == 0) {
        [[self sharedEmoticonsKeyboard] bringSubviewToFront:pressedKeyCellPopupView];
        if (toCell) {
            pressedKeyCellPopupView.keyItem = toCell.keyItem;
            pressedKeyCellPopupView.hidden = NO;
            CGRect frame = [[self sharedEmoticonsKeyboard] convertRect:toCell.bounds fromView:toCell];
            pressedKeyCellPopupView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame)-CGRectGetHeight(pressedKeyCellPopupView.frame)/2);
        }else{
            pressedKeyCellPopupView.hidden = YES;
        }
    }
}

@end

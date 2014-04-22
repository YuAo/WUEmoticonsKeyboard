//
//  WUEmoticonsKeyboard.h
//  WeicoUI
//
//  Created by YuAo on 1/24/13.
//  Copyright (c) 2013 微酷奥(北京)科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUEmoticonsKeyboardKeyItemGroup.h"
#import "WUEmoticonsKeyboardKeyItem.h"
#import "WUEmoticonsKeyboardKeysPageFlowLayout.h"
#import "WUEmoticonsKeyboardKeyCell.h"

extern NSString * const WUEmoticonsKeyboardDidSwitchToDefaultKeyboardNotification;

extern CGSize const WUEmoticonsKeyboardDefaultSize;

typedef NS_ENUM(NSUInteger, WUEmoticonsKeyboardButton) {
    WUEmoticonsKeyboardButtonKeyboardSwitch,
    WUEmoticonsKeyboardButtonBackspace,
    WUEmoticonsKeyboardButtonSpace
};

@interface WUEmoticonsKeyboard : UIView <UIAppearance,UIAppearanceContainer>

@property (nonatomic)      BOOL    enableStandardSystemKeyboardClickSound;

/*
 an array of WUEmoticonsKeyboardKeyItemGroup.
 */
@property (nonatomic,copy) NSArray *keyItemGroups;

@property (nonatomic,copy) void    (^keyItemGroupPressedKeyCellChangedBlock)(WUEmoticonsKeyboardKeyItemGroup *keyItemGroup, WUEmoticonsKeyboardKeyCell *fromKeyCell, WUEmoticonsKeyboardKeyCell *toKeyCell);
/*
 Note:
 Use the `UIResponder (WUEmoticonsKeyboard)` -switchToEmoticonsKeyboard: method to make a textInput switch to a WUEmoticonsKeyboard.
 The textInput object will retain the WUEmoticonsKeyboard which attached to it.
 
 You may get the WUEmoticonsKeyboard object though the textInput's inputView or emoticonsKeyboard property.
*/
@property (nonatomic,weak,readonly) UIResponder<UITextInput> *textInput;

+ (instancetype)keyboard;

#pragma mark - Apperance

- (void)setBackgroundImage:(UIImage *)image UI_APPEARANCE_SELECTOR;
- (void)setBackgroundImage:(UIImage *)image forKeyItemGroup:(WUEmoticonsKeyboardKeyItemGroup *)keyItemGroup UI_APPEARANCE_SELECTOR;
- (void)setBackgroundColor:(UIColor *)backgroundColor forKeyItemGroup:(WUEmoticonsKeyboardKeyItemGroup *)keyItemGroup UI_APPEARANCE_SELECTOR;

- (void)setImage:(UIImage *)image forButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (UIImage *)imageForButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state;

- (void)setBackgroundImage:(UIImage *)image forButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (UIImage *)backgroundImageForButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state;

- (void)setAttributedTitle:(NSAttributedString *)title forButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (NSAttributedString *)attributedTitleForButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state;

@property (nonatomic) CGFloat toolsViewHeight UI_APPEARANCE_SELECTOR; //Default 45.0f

@end

@interface UIResponder (WUEmoticonsKeyboard)
@property (readonly, strong) WUEmoticonsKeyboard *emoticonsKeyboard;
- (void)switchToDefaultKeyboard;
- (void)switchToEmoticonsKeyboard:(WUEmoticonsKeyboard *)keyboard;
@end
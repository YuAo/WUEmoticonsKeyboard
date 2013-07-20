//
//  WUEmoticonsKeyboard.m
//  WeicoUI
//
//  Created by YuAo on 1/24/13.
//  Copyright (c) 2013 微酷奥(北京)科技有限公司. All rights reserved.
//

#import "WUEmoticonsKeyboard.h"
#import "UIResponder+WriteableInputView.h"
#import "WUEmoticonsKeyboardToolsView.h"
#import "WUEmoticonsKeyboardKeyItemGroupView.h"

NSString * const WUEmoticonsKeyboardDidSwitchToDefaultKeyboardNotification = @"WUEmoticonsKeyboardDidSwitchToDefaultKeyboardNotification";

@interface WUEmoticonsKeyboard () <UIInputViewAudioFeedback>
@property (nonatomic,weak,readwrite) UIResponder<UITextInput>     *textInput;
@property (nonatomic,weak)           WUEmoticonsKeyboardToolsView *toolsView;
@property (nonatomic,weak)           UIImageView                  *backgroundImageView;
@property (nonatomic,strong)         NSArray                      *keyItemGroupViews;
@property (nonatomic,readonly)       CGRect                        keyItemGroupViewFrame;
@end

@implementation WUEmoticonsKeyboard

#pragma mark - TextInput

- (void)setInputViewToView:(UIView *)view {
    if (self.textInput.isFirstResponder) {
        [self.textInput resignFirstResponder];
        self.textInput.inputView = view;
        [self.textInput becomeFirstResponder];
    }else{
        self.textInput.inputView = view;
    }
}

- (void)attachToTextInput:(UIResponder<UITextInput> *)textInput {
    self.textInput = textInput;
    [self setInputViewToView:self];
}

- (void)switchToDefaultKeyboard {
    [self setInputViewToView:nil];
    self.textInput = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:WUEmoticonsKeyboardDidSwitchToDefaultKeyboardNotification object:self];
}

#pragma mark - Text Input

- (BOOL)shouldReplaceTextInRange:(UITextRange *)range replacementText:(NSString *)text {
    
    BOOL shouldChange = YES;
    
    if ([self.textInput isKindOfClass:UITextView.class]) {
        UITextView *textView = (UITextView *)self.textInput;
        if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]){
            NSInteger startOffset = [textView offsetFromPosition:self.textInput.beginningOfDocument toPosition:range.start];
            NSInteger endOffset = [textView offsetFromPosition:self.textInput.beginningOfDocument toPosition:range.end];
            NSRange textRange = NSMakeRange(startOffset, endOffset - startOffset);
            shouldChange = [textView.delegate textView:textView shouldChangeTextInRange:textRange replacementText:text];
        }
    }
    
    if ([self.textInput isKindOfClass:UITextField.class]) {
        /////..... May need fix.
    }
    
    return shouldChange;
}

- (void)replaceTextInRange:(UITextRange *)range withText:(NSString *)text {
    if (range && [self shouldReplaceTextInRange:range replacementText:text]) {
        [self.textInput replaceRange:range withText:text];
    }
}

- (void)inputText:(NSString *)text {
    [self replaceTextInRange:self.textInput.selectedTextRange withText:text];
}

- (void)backspace {
    if (self.textInput.selectedTextRange.empty) {
        //Find the last thing we may input and delete it. And RETURN
        NSString *text = [self.textInput textInRange:[self.textInput textRangeFromPosition:self.textInput.beginningOfDocument toPosition:self.textInput.selectedTextRange.start]];
        for (WUEmoticonsKeyboardKeyItemGroup *group in self.keyItemGroups) {
            for (WUEmoticonsKeyboardKeyItem *item in group.keyItems) {
                if ([text hasSuffix:item.textToInput]) {
                    __block NSUInteger composedCharacterLength = 0;
                    [item.textToInput enumerateSubstringsInRange:NSMakeRange(0, item.textToInput.length)
                                                         options:NSStringEnumerationByComposedCharacterSequences
                                                      usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                                          composedCharacterLength++;
                                                      }];
                    UITextRange *rangeToDelete = [self.textInput textRangeFromPosition:[self.textInput positionFromPosition:self.textInput.selectedTextRange.start offset:-composedCharacterLength] toPosition:self.textInput.selectedTextRange.start];
                    if (rangeToDelete) {
                        [self replaceTextInRange:rangeToDelete withText:@""];
                        return;
                    }
                }
            }
        }
        
        //If we cannot find the text. Do a delete backward.
        UITextRange *rangeToDelete = [self.textInput textRangeFromPosition:self.textInput.selectedTextRange.start toPosition:[self.textInput positionFromPosition:self.textInput.selectedTextRange.start offset:-1]];
        [self replaceTextInRange:rangeToDelete withText:@""];
    } else {
        [self replaceTextInRange:self.textInput.selectedTextRange withText:@""];
    }
}

#pragma mark - create & init

- (CGSize)keyboardSize {
    return CGSizeMake(320, 216);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, self.keyboardSize.width, self.keyboardSize.height);
        self.backgroundColor = [UIColor blackColor];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:backgroundImageView];
        self.backgroundImageView = backgroundImageView;
        
        WUEmoticonsKeyboard *__weak weakSelf = self;
        
        WUEmoticonsKeyboardToolsView *toolsView = [[WUEmoticonsKeyboardToolsView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - WUEmoticonsKeyboardToolsViewHeight, CGRectGetWidth(self.bounds), WUEmoticonsKeyboardToolsViewHeight)];
        toolsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [toolsView setKeyboardSwitchButtonTappedBlock:^{
            [weakSelf switchToDefaultKeyboard];
        }];
        [toolsView setBackspaceButtonTappedBlock:^{
            [weakSelf backspace];
        }];
        [toolsView setKeyItemGroupSelectedBlock:^(WUEmoticonsKeyboardKeyItemGroup *keyItemGroup) {
            [weakSelf switchToKeyItemGroup:keyItemGroup];
        }];
        [self addSubview:toolsView];
        self.toolsView = toolsView;
    }
    return self;
}

+ (instancetype)keyboard {
    WUEmoticonsKeyboard *keyboard = [[WUEmoticonsKeyboard alloc] initWithFrame:CGRectZero];
    return keyboard;
}

#pragma mark - KeyItems

- (CGRect)keyItemGroupViewFrame {
    return CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetMinY(self.toolsView.frame));
}

- (void)setKeyItemGroups:(NSArray *)keyItemGroups {
    _keyItemGroups = [keyItemGroups copy];
    [self reloadKeyItemGroupViews];
    self.toolsView.keyItemGroups = keyItemGroups;
}

- (void)reloadKeyItemGroupViews {
    [self.keyItemGroupViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    __weak __typeof(&*self)weakSelf = self;
    self.keyItemGroupViews = nil;
    NSMutableArray *keyItemGroupViews = [NSMutableArray array];
    [self.keyItemGroups enumerateObjectsUsingBlock:^(WUEmoticonsKeyboardKeyItemGroup *obj, NSUInteger idx, BOOL *stop) {
        WUEmoticonsKeyboardKeyItemGroupView *keyItemGroupView = [[WUEmoticonsKeyboardKeyItemGroupView alloc] initWithFrame:weakSelf.keyItemGroupViewFrame];
        keyItemGroupView.keyItemGroup = obj;
        [keyItemGroupView setKeyItemTappedBlock:^(WUEmoticonsKeyboardKeyItem *keyItem) {
            [weakSelf keyItemTapped:keyItem];
        }];
        [keyItemGroupView setPressedKeyItemCellChangedBlock:^(WUEmoticonsKeyboardKeyCell *fromCell, WUEmoticonsKeyboardKeyCell *toCell) {
            if (weakSelf.keyItemGroupPressedKeyCellChangedBlock) {
                weakSelf.keyItemGroupPressedKeyCellChangedBlock(obj,fromCell,toCell);
            }
        }];
        [keyItemGroupViews addObject:keyItemGroupView];
    }];
    self.keyItemGroupViews = [keyItemGroupViews copy];
}

- (void)switchToKeyItemGroup:(WUEmoticonsKeyboardKeyItemGroup *)keyItemGroup {
    [self.keyItemGroupViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    [self.keyItemGroupViews enumerateObjectsUsingBlock:^(WUEmoticonsKeyboardKeyItemGroupView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.keyItemGroup isEqual:keyItemGroup]) {
            obj.frame = self.keyItemGroupViewFrame;
            obj.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self addSubview:obj];
            *stop = YES;
        }
    }];
}

- (void)keyItemTapped:(WUEmoticonsKeyboardKeyItem *)keyItem {
    [self inputText:keyItem.textToInput];
    [UIDevice.currentDevice playInputClick];
}

#pragma mark - UIInputViewAudioFeedback

- (BOOL) enableInputClicksWhenVisible {
    return self.enableStandardSystemKeyboardClickSound;
}

#pragma mark - Apperance

- (UIButton *)emoticonsKeyboardButtonOfType:(WUEmoticonsKeyboardButton)type {
    switch (type) {
        case WUEmoticonsKeyboardButtonKeyboardSwitch:
            return self.toolsView.keyboardSwitchButton;
            break;
        case WUEmoticonsKeyboardButtonBackspace:
            return self.toolsView.backspaceButton;
            break;
        default:
            return nil;
            break;
    }
}

- (void)setImage:(UIImage *)image forButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state {
    [[self emoticonsKeyboardButtonOfType:button] setImage:image forState:state];
}

- (UIImage *)imageForButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state {
    return [[self emoticonsKeyboardButtonOfType:button] imageForState:state];
}

- (void)setBackgroundImage:(UIImage *)image forButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state {
    [[self emoticonsKeyboardButtonOfType:button] setBackgroundImage:image forState:state];
}

- (UIImage *)backgroundImageForButton:(WUEmoticonsKeyboardButton)button state:(UIControlState)state {
    return [[self emoticonsKeyboardButtonOfType:button] backgroundImageForState:state];
}

- (void)setBackgroundImage:(UIImage *)image {
    [self.backgroundImageView setImage:image];
}

- (void)setBackgroundImage:(UIImage *)image forKeyItemGroup:(WUEmoticonsKeyboardKeyItemGroup *)keyItemGroup {
    [self.keyItemGroupViews enumerateObjectsUsingBlock:^(WUEmoticonsKeyboardKeyItemGroupView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.keyItemGroup isEqual:keyItemGroup]) {
            obj.backgroundImageView.image = image;
        }
    }];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forKeyItemGroup:(WUEmoticonsKeyboardKeyItemGroup *)keyItemGroup {
    [self.keyItemGroupViews enumerateObjectsUsingBlock:^(WUEmoticonsKeyboardKeyItemGroupView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.keyItemGroup isEqual:keyItemGroup]) {
            obj.backgroundImageView.backgroundColor = backgroundColor;
        }
    }];
}

@end

@implementation UIResponder (WUEmoticonsKeyboard)

- (WUEmoticonsKeyboard *)emoticonsKeyboard {
    if ([self.inputView isKindOfClass:[WUEmoticonsKeyboard class]]) {
        return (WUEmoticonsKeyboard *)self.inputView;
    }
    return nil;
}

- (void)switchToDefaultKeyboard {
    [self.emoticonsKeyboard switchToDefaultKeyboard];
}

- (void)switchToEmoticonsKeyboard:(WUEmoticonsKeyboard *)keyboard {
    if ([self conformsToProtocol:@protocol(UITextInput)] && [self respondsToSelector:@selector(setInputView:)]) {
        [keyboard attachToTextInput:(UIResponder<UITextInput> *)self];
    }
}

@end

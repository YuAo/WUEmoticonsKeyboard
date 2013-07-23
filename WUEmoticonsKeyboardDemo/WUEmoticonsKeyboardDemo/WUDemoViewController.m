//
//  WUDemoViewController.m
//  WUEmoticonsKeyboardDemo
//
//  Created by YuAo on 7/20/13.
//  Copyright (c) 2013 YuAo. All rights reserved.
//

#import "WUDemoViewController.h"
#import "WUDemoKeyboardBuilder.h"

@interface WUDemoViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation WUDemoViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (IBAction)switchKeyboard:(UIButton *)sender {
    if (self.textView.isFirstResponder) {
        if (self.textView.emoticonsKeyboard) [self.textView switchToDefaultKeyboard];
        else [self.textView switchToEmoticonsKeyboard:[WUDemoKeyboardBuilder sharedEmoticonsKeyboard]];
    }else{
        [self.textView switchToEmoticonsKeyboard:[WUDemoKeyboardBuilder sharedEmoticonsKeyboard]];
        [self.textView becomeFirstResponder];
    }
}

@end

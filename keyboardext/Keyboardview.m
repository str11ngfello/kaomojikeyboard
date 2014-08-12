//
//  InputView.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 8/10/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "KeyboardView.h"

@implementation KeyboardView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (IBAction)clear:(id)sender {
    [self.keyboardViewController clear];
    }

- (IBAction)nextKeyboard:(id)sender {
    [self.keyboardViewController advanceToNextInputMode];
}
@end

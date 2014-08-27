//
//  InputView.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 8/10/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "KeyboardView.h"
#import "BButton.h"

@interface KeyboardView()
@property (weak, nonatomic) IBOutlet BButton *spaceButton;
@property (nonatomic, strong)NSTimer* repeatTimer;
@end

@implementation KeyboardView

- (void)awakeFromNib
{
    [super awakeFromNib];
    //[self.spaceButton setStyle:BButtonStyleBootstrapV3];
    //[self.spaceButton setType:BButtonTypeDefault];
   // [self.spaceButton setNeedsLayout];
   // [self.spaceButton addAwesomeIcon:FATwitter beforeTitle:YES];
   
 
}

- (IBAction)clear:(id)sender {
    [self.keyboardViewController clear];
    }

- (IBAction)nextKeyboard:(id)sender {
    [self.keyboardViewController advanceToNextInputMode];
}
- (IBAction)holdDownDelete:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.repeatTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(deleteChar) userInfo:nil repeats:YES];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.repeatTimer invalidate];
    }
    
    
}
- (IBAction)link:(id)sender {
    [self.keyboardViewController.textDocumentProxy insertText:@"Get Kaomoji Keyboard in the App Store! http://bit.ly/1v6jcKL"];
}

- (void)deleteChar {
    [self.keyboardViewController.textDocumentProxy deleteBackward];

}
@end

//
//  InputView.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 8/10/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "KeyboardView.h"

@interface KeyboardView()
@property (nonatomic, strong)NSTimer* repeatTimer;
@property (nonatomic, strong)UIColor* lightGray;
@end

@implementation KeyboardView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _lightGray = [UIColor colorWithRed:.92 green:.92 blue:.92 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageSelected:) name:@"PageSelected" object:nil];

    UILongPressGestureRecognizer *btn_LongPress_gesture = [[UILongPressGestureRecognizer alloc]
                                                           initWithTarget:self action:@selector(holdDownDelete:)];
    [_deleteButton addGestureRecognizer:btn_LongPress_gesture];
}

- (void)pageSelected:(NSNotification *)notification {
    int pageSelected = [notification.userInfo[@"pageIndex"] intValue];
    switch (pageSelected) {
        case 0: [self selectButton:_favoriteButton]; break;
        case 1: [self selectButton:_historyButton]; break;
        case 2: [self selectButton:_emotionButton]; break;
        case 3: [self selectButton:_actionButton]; break;
        case 4: [self selectButton:_characterButton]; break;
        case 5: [self selectButton:_customizedButton]; break;
  
        default:
            break;
    }
}


- (IBAction)clear:(id)sender {
    [self.keyboardViewController clear];
    }

- (IBAction)nextKeyboard:(id)sender {
    [self.keyboardViewController advanceToNextInputMode];
}

- (IBAction)favoriteButton:(id)sender {
    [self.keyboardViewController setPageIndex:0];
}

- (IBAction)historyButton:(id)sender {
    [self.keyboardViewController setPageIndex:1];
}
- (IBAction)emotionButton:(id)sender {
    [self.keyboardViewController setPageIndex:2];
}
- (IBAction)actionButton:(id)sender {
    [self.keyboardViewController setPageIndex:3];
}
- (IBAction)characterButton:(id)sender {
    [self.keyboardViewController setPageIndex:4];
}
- (IBAction)customizedButton:(id)sender {
    [self.keyboardViewController setPageIndex:5];
}

-(void)selectButton:(UIButton*)b
{
  
    [_favoriteButton setTintColor:[UIColor blackColor]];
    [_favoriteButton setBackgroundColor:_lightGray];
    [_historyButton setTintColor:[UIColor blackColor]];
    [_historyButton setBackgroundColor:_lightGray];
    [_actionButton setTintColor:[UIColor blackColor]];
    [_actionButton setBackgroundColor:_lightGray];
    [_emotionButton setTintColor:[UIColor blackColor]];
    [_emotionButton setBackgroundColor:_lightGray];
    [_characterButton setTintColor:[UIColor blackColor]];
    [_characterButton setBackgroundColor:_lightGray];
    [_customizedButton setTintColor:[UIColor blackColor]];
    [_customizedButton setBackgroundColor:_lightGray];
    
    [b setBackgroundColor:[UIColor darkGrayColor]];
    [b setTintColor:[UIColor whiteColor]];
    
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
    [self.keyboardViewController.textDocumentProxy insertText:@"Get Kaomoji Keyboard in the App Store! http://bit.ly/1nMMGbR"];
}
- (IBAction)deleteButton:(id)sender {
    [self.keyboardViewController.textDocumentProxy deleteBackward];
}

- (void)deleteChar
{
    [self deleteButton:nil];
}




@end

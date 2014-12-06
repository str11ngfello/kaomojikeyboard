//
//  InputView.h
//  kaomojikeyboard
//
//  Created by Lowell Duke on 8/10/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardViewController.h"
#import "ADLivelyCollectionView.h"
#import "LDCollectionViewCell.h"

@interface KeyboardView : UIView
@property (weak, nonatomic) IBOutlet UIButton *spaceButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIButton *colorCycleButton;


@property (weak, nonatomic) IBOutlet UIView *buttonTray;
@property (weak, nonatomic) IBOutlet UIButton *globeButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;
@property (weak, nonatomic) IBOutlet UIButton *emotionButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *characterButton;
@property (weak, nonatomic) IBOutlet UIButton *customizedButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;



@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (nonatomic, weak) IBOutlet UIButton* nextKeyboardButton;
@property (nonatomic, weak) IBOutlet UIButton* clearButton;
@property (nonatomic, strong) KeyboardViewController* keyboardViewController;
@end

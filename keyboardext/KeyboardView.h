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
@property (nonatomic, weak) IBOutlet UIButton* nextKeyboardButton;
@property (nonatomic, weak) IBOutlet UIButton* clearButton;
@property (nonatomic, strong) KeyboardViewController* keyboardViewController;
@end
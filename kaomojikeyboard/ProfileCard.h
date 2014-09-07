//
//  ProfileCard.h
//  Plutonic
//
//  Created by Lowell Duke on 8/13/14.
//  Copyright (c) 2014 Binocular All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCSwipeToChoose.h"

@class Person;

@interface ProfileCard : MDCSwipeToChooseView
@property (nonatomic, strong)Person* person;
@property (nonatomic, strong)UIImage* bakedView;
- (id)initWithFrame:(CGRect)frame person:(Person*)person options:(MDCSwipeToChooseViewOptions *)options;
@end

//
//  BrowserViewController.h
//  kaomojikeyboard
//
//  Created by Lowell Duke on 9/6/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "MDCSwipeToChoose.h"

@interface BrowserViewController : UIViewController <MDCSwipeToChooseDelegate>

@property (nonatomic, assign) bool fetchInProgress;
@property (nonatomic, strong) Person *currentPerson;
@property (nonatomic, strong) NSMutableArray* cardViews;


@end

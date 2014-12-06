//
//  KeyboardViewController.h
//  keyboardext
//
//  Created by Lowell Duke on 8/10/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickyFlowLayout : UICollectionViewFlowLayout

@end


@interface KeyboardViewController : UIInputViewController <UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
-(void)clear;
- (void)setPageIndex:(int)index;
@end

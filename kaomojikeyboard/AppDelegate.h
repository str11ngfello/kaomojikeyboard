//
//  AppDelegate.h
//  kaomojikeyboard
//
//  Created by Lowell Duke on 8/10/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageViewTinted : UIImageView

@end

@interface UIButtonTinted : UIButton

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray* iapProducts;

@end


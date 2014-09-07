//
//  MovieContorller.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 9/7/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "MovieController.h"



@implementation MovieController 

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"VideoStarted"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.player = [[AVPlayer alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"iphoneKeyboard" withExtension:@"mov"]];
    [self.player play];
}

@end

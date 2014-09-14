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
    self.player = [[AVPlayer alloc] initWithURL:[[NSBundle mainBundle] URLForResource:@"iphoneKeyboard" withExtension:@"mp4"]];
    [self.player play];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.player currentItem]];
    

}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self dismissViewControllerAnimated:true completion:nil];
    
    
    
    [[[UIAlertView alloc] initWithTitle:@"Open Settings?"
                                message:@"Open settings to add the Kaomoji Keyboard? This process is required in order to use the keyboard."
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"No" action:^{
        
    }]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"Yes" action:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                    UIApplicationOpenSettingsURLString]];
    }], nil] show];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:nil];
}
@end

//
//  ViewController.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 8/10/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
@property (nonatomic, strong) NSUserDefaults* defaults;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *instructions;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.seventhnight.kaomojikeyboard"];
    //[self.defaults synchronize];
    //NSLog(@"containing app - %@",[self.defaults objectForKey:@"CustomArray"]);

    self.tabBarController.tabBar.hidden = true;
    _instructionsLabel.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2.0,[[UIScreen mainScreen] bounds].size.height+300);
    _instructionsLabel.text = @"Let's turn on your Kaomoji Keyboard";
    _instructionsLabel.alpha = 0;
    _playButton.hidden = true;
    _playButton.transform = CGAffineTransformMakeScale(.5, .5);
   
    
    
   /* AVPlayer *player = [AVPlayer playerWithURL:[[NSBundle mainBundle] URLForResource:@"iphoneKeyboard" withExtension:@"mp4"]];
    
    AVPlayerLayer *layer = [AVPlayerLayer layer];
    
    [layer setPlayer:player];
    [layer setFrame:CGRectMake(10, 10, 300, 480)];
    [layer setBackgroundColor:[UIColor redColor].CGColor];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    CAShapeLayer * shapeLayer = [[CAShapeLayer alloc]init];
    shapeLayer.frame = CGRectMake(10, 10, 30, 30);
    shapeLayer.fillColor = [[UIColor blackColor] CGColor];
    
    //layer.mask = shapeLayer;
    
    [self.view.layer addSublayer:layer];
    
    [player play];*/
  
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.tintColor = [UIColor purpleColor];
    
    //First launch?
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"VideoStarted"])
    {
        [UIView animateWithDuration: 1.2
                              delay: .2
             usingSpringWithDamping: .6
              initialSpringVelocity: 1
                            options: 0
                         animations: ^{
                             _instructionsLabel.center = self.view.center;
                             _instructionsLabel.alpha = 1;
                                     }
                         completion: ^(BOOL finished){
                             
                             [UIView animateWithDuration: 1
                                                   delay: 2.5
                                  usingSpringWithDamping: .9
                                   initialSpringVelocity: .8
                                                 options: 0
                                              animations: ^{
                                                  _instructionsLabel.center = CGPointMake(_instructionsLabel.center.x,(_instructionsLabel.frame.size.height/2));
                                                  _instructionsLabel.alpha = 0;
                                              }
                                              completion: ^(BOOL finished){
                                                  [UIView animateWithDuration: .7
                                                                        delay: 0
                                                       usingSpringWithDamping: .4
                                                        initialSpringVelocity: .8
                                                                      options: 0
                                                                   animations: ^{
                                                                       _instructionsLabel.text = @"Tap the arrow to continue";
                                                                       _playButton.hidden = false;
                                                                       _playButton.transform = CGAffineTransformMakeScale(1, 1);
                                                                       
                                                                   }
                                                                   completion: ^(BOOL finished){
                                                                       
                                                                       
                                                                   }];
                                                  
                                              }];
                             
                         }
         ];
    }
    
    //After video started at least once?
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"VideoStarted"])
    {
        _instructionsLabel.hidden = true;
        self.tabBarController.tabBar.hidden = false;
        _playButton.hidden = false;
        _playButton.transform = CGAffineTransformMakeScale(1, 1);

        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

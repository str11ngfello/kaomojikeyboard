//
//  ViewController.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 8/10/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSUserDefaults* defaults;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.seventhnight.kaomojikeyboard"];
    [self.defaults synchronize];
    NSLog(@"containing app - %@",[self.defaults objectForKey:@"CustomArray"]);
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

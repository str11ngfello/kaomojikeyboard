//
//  AppDelegate.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 8/10/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "AppDelegate.h"

@implementation UIImageViewTinted


-(void)awakeFromNib
{
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

}

@end


@implementation UIButtonTinted


-(void)awakeFromNib
{
    UIImage* i = [self imageForState:UIControlStateNormal];
    [self setImage:[i imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

    
}

@end




@interface AppDelegate ()

@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Flurry  startSession:@"4THXD96N7YGTW77QGX4M"];
   
    //AdColony
    [AdColony configureWithAppID:@"app4749a88a8690483fa4" zoneIDs:@[@"vzbe2e9221a80046a8a5"] delegate:self logging:YES];
    
    // Initialize the Chartboost library
    [Chartboost startWithAppId:@"54a6fe0043150f16ce1d6d43"
                  appSignature:@"c5c7bf912944c2dbd644bebca8299696c07e87d5"
                      delegate:self];
    [Chartboost cacheInterstitial:CBLocationHomeScreen];
    
    
    //Vungle
    NSString* appID = @"910005651";
    VungleSDK* sdk = [VungleSDK sharedSDK];
    [sdk startWithAppId:appID];    
    
    return YES;
}


/*
* This is called when an interstitial has failed to load. The error enum specifies
* the reason of the failure
*/

- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load Interstitial, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load Interstitial, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load Interstitial, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load Interstitial, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load Interstitial, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load Interstitial, first session !");
        } break;
        case CBLoadErrorNoAdFound : {
            NSLog(@"Failed to load Interstitial, no ad found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            NSLog(@"Failed to load Interstitial, session not started !");
        } break;
        case CBLoadErrorNoLocationFound : {
            NSLog(@"Failed to load Interstitial, missing location parameter !");
        } break;
        default: {
            NSLog(@"Failed to load Interstitial, unknown error !");
        }
    }
    
    
}

- (void)didDismissInterstitial:(NSString *)location {
    NSLog(@"chartboost dismissed interstitial at location %@", location);
    
    NSDictionary *shareParams = [NSDictionary dictionaryWithObjectsAndKeys:@"Chartboost", @"Network",nil];
    [Flurry logEvent:@"VideoAdShown" withParameters:shareParams];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
    
   /* NSSet *products = [NSSet setWithArray:@[@"seventhnight.kaomojikeyboard.removeads"]];
    [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        
        self.iapProducts = [products mutableCopy];
    
        if ([bindings objectForKey:@"removeads"] == nil)
        {
        
            SKProduct* p = (SKProduct*)[self.iapProducts objectAtIndex:0];
            [[RMStore defaultStore] addPayment:p.productIdentifier success:^(SKPaymentTransaction *transaction) {
                
               
                [bindings setObject:@"1" forKey:@"removeads"];
                
                NSLog(@"Product purchased");
            } failure:^(SKPaymentTransaction *transaction, NSError *error) {
                
          
                NSLog(@"Something went wrong with purchase");
            }];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Couldn't load store products");
    }];
*/

  /*  [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions){
        NSLog(@"Purchases restored");
    } failure:^(NSError *error) {
        NSLog(@"Something went wrong while restoring purchases");
    }];*/
    
    NSLog(@"removeads = %@",[bindings objectForKey:@"removeads"]);

    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end

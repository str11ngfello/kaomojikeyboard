//
//  ExtrasViewController.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 1/4/15.
//  Copyright (c) 2015 Seventh Night Studios. All rights reserved.
//

#import "ExtrasViewController.h"
#import "ExtraCell.h"
#import "AppDelegate.h"

@interface ExtrasViewController()
@property (nonatomic, strong) NSUserDefaults* defaults;

@end
@implementation ExtrasViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.seventhnight.kaomojikeyboard"];
    
    [FlurryAds setAdDelegate:self];
    [[VungleSDK sharedSDK] setDelegate:self];
    [FlurryAds fetchAdForSpace:@"MainSpace" frame:self.view.frame size:FULLSCREEN];

    [[RMStore  defaultStore] addStoreObserver:self];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:.5 green:.5 blue:0 alpha:1];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"emojis" ofType:@"txt"];
    NSError *errorReading;
    self.kaomojis = [[[NSString stringWithContentsOfFile:filePath
                                                      encoding:NSUTF8StringEncoding
                                                         error:&errorReading]
                            componentsSeparatedByString:@"\n"] mutableCopy];
    
    for (int i = 0;i < self.kaomojis.count;++i)
    {
        if ([self.kaomojis[i] length] > 5)
        {
            self.kaomojis[i] = [self.kaomojis[i] substringWithRange:NSMakeRange(3, [self.kaomojis[i] length]-3)];
            self.kaomojis[i] = [self.kaomojis[i] substringWithRange:NSMakeRange(0, [self.kaomojis[i] length]-2)];
        }
    }
    //NSLog(@"%@",linesOfText);

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.kaomojis.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.25];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ExtraCell";
    ExtraCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.kaomoji.text = self.kaomojis[indexPath.row];
    cell.toggle.tag = indexPath.row;
    
    [cell.toggle removeTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    [cell.toggle addTarget:self action:@selector(setState:) forControlEvents:UIControlEventValueChanged];
    
    NSMutableArray* customs = [self.defaults objectForKey:@"CustomArray"];
    bool found = false;
    for (NSString* s in customs)
    {
        if ([s isEqualToString:cell.kaomoji.text])
        {
            found = true;
            break;
        }
    }
    cell.toggle.on = found;

    
    return cell;
}

- (void)setState:(id)sender
{
    UISwitch* toggle = (UISwitch*)sender;
    
    NSMutableArray* customs = [[self.defaults objectForKey:@"CustomArray"] mutableCopy];
   
    if (toggle.isOn)
    {
        //Must be connected to the internet to add emoji
        AppDelegate* ad = [[UIApplication sharedApplication] delegate];
        
        if (![ad isNetworkAvailable]) {
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"No Internet Connection"
                                                             message:@"Please make sure you have a valid internet connection and try again!"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
            return;
        }

        
        bool found = false;
        for (NSString* s in customs)
        {
            if ([s isEqualToString:self.kaomojis[toggle.tag]])
            {
                found = true;
                break;
            }
        }
        if (!found)
        {
            
            [customs insertObject:self.kaomojis[toggle.tag] atIndex:0];
            [self.defaults setObject:customs forKey:@"CustomArray"];
            [self.defaults synchronize];
            [Flurry logEvent:@"ExtraKaomojiAdded" withParameters:nil];
            [SVProgressHUD showSuccessWithStatus:@"Kaomoji Added!"];
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"SavedExtraToKeyboardInformed"])
            {
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"SavedExtraToKeyboardInformed"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Kaomoji Added"
                                                                 message:@"You can find extra Kaomojis in the keyboard on the last page titled \"Customized / Extras\""
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                [alert show];
                
            }
            
            
            
            PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];

            long actionCount = [[bindings objectForKey:@"nagActionCount"] integerValue];
            long nagActionCount = [[ad.configFile objectForKey:@"nagActionCount"] integerValue];
            actionCount++;
            [bindings setObject:[NSString stringWithFormat:@"%ld",actionCount] forKey:@"nagActionCount"];
            
            

            if ([bindings objectForKey:@"removeads"] == nil && actionCount >= nagActionCount)
            {
                [bindings setObject:@"0" forKey:@"nagActionCount"];
                
                if ([Chartboost hasInterstitial:CBLocationHomeScreen])
                {
                    [Chartboost showInterstitial:CBLocationHomeScreen];
                }
                else
                {
                    NSLog(@"Chartboost not ready!");
                    [Chartboost cacheInterstitial:CBLocationHomeScreen];
                    
                    [AdColony playVideoAdForZone:@"vzbe2e9221a80046a8a5" withDelegate:self];
                }
            }
            
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"Kamoji Already Added"];
            
        }
    }
    else
    {
        NSMutableArray* customs = [[self.defaults objectForKey:@"CustomArray"] mutableCopy];
        [customs removeObject:self.kaomojis[toggle.tag]];
        [self.defaults setObject:customs forKey:@"CustomArray"];
        [self.defaults synchronize];

        [SVProgressHUD showSuccessWithStatus:@"Kaomoji Removed!"];
        
    }
}


- (void) onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneID
{
    if (!shown)
    {
        NSLog(@"AdColony not ready!");
        
        if ([[VungleSDK sharedSDK]  isCachedAdAvailable])
        {
            [[VungleSDK sharedSDK] playAd:self error:nil];
        }
        else
        {
            NSLog(@"Vungle was not ready!");
            
            if ([FlurryAds adReadyForSpace:@"MainSpace"])
            {
                [FlurryAds displayAdForSpace:@"MainSpace" onView:self.view viewControllerForPresentation:self];
                [FlurryAds fetchAdForSpace:@"MainSpace" frame:self.view.frame size:FULLSCREEN];
                
                NSDictionary *shareParams = [NSDictionary dictionaryWithObjectsAndKeys:@"Flurry", @"Network",nil];
                [Flurry logEvent:@"VideoAdShown" withParameters:shareParams];
                
            }
            else
            {
                NSLog(@"Flurry was not ready!");
                [FlurryAds fetchAdForSpace:@"MainSpace" frame:self.view.frame size:FULLSCREEN];
                
                //No ad was available
                NSDictionary *shareParams = [NSDictionary dictionaryWithObjectsAndKeys:@"NoAdAvailableYet", @"Network",nil];
                [Flurry logEvent:@"VideoAdShown" withParameters:shareParams];
            }
        }
    }
    else
    {
        NSDictionary *shareParams = [NSDictionary dictionaryWithObjectsAndKeys:@"AdColony", @"Network",nil];
        [Flurry logEvent:@"VideoAdShown" withParameters:shareParams];
    }
}

//Flurry video did finish
- (void) videoDidFinish:(NSString *)adSpace{
    NSLog(@"Ad Space [%@] Flurry Video Did Finish", adSpace);
    [FlurryAds fetchAdForSpace:@"MainSpace" frame:self.view.frame size:FULLSCREEN];
    
    
}


- (void)vungleSDKwillCloseAdWithViewInfo:(NSDictionary*)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet;
{
    NSLog(@"Closing vungle ad");
    if ([viewInfo[@"completedView"] boolValue] == true)
    {
        NSLog(@"Vungle ad was viewed fully");
        NSDictionary *shareParams = [NSDictionary dictionaryWithObjectsAndKeys:@"Vungle", @"Network",nil];
        [Flurry logEvent:@"VideoAdShown" withParameters:shareParams];
    }
    
}

-(void)storePaymentTransactionFinished:(NSNotification*)notification
{
    if (notification && notification.userInfo)
    {
        if ([notification.userInfo[@"productIdentifier"] isEqualToString:@"seventhnight.kaomojikeyboard.removeads"])
        {
            NSLog(@"Transaction finished %@",notification.userInfo[@"productIdentifier"]);
            PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
            [bindings setObject:@"1" forKey:@"removeads"];
        }
    }
    
}


- (IBAction)restorePurchasesPressed:(id)sender {
      [[RMStore defaultStore] restoreTransactionsOnSuccess:^(NSArray *transactions){
          NSLog(@"Purchases finished restoring");
          UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Thank you!"
                                                           message:@"Your previous purchases have been restored."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
          [alert show];

     } failure:^(NSError *error) {
     NSLog(@"Something went wrong while restoring purchases");
     }];

}

- (IBAction)removeAdsPressed:(id)sender {
    
    PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
   
    AppDelegate* ad = [[UIApplication sharedApplication] delegate];
    
    if ([bindings objectForKey:@"removeads"] == nil)
    {
        
        SKProduct* p = (SKProduct*)[ad.iapProducts objectAtIndex:0];
        [[RMStore defaultStore] addPayment:p.productIdentifier success:^(SKPaymentTransaction *transaction) {
            
            
            
            NSLog(@"Product purchased");
        } failure:^(SKPaymentTransaction *transaction, NSError *error) {
            
            
            NSLog(@"Something went wrong with purchase");
        }];
    }

}
@end

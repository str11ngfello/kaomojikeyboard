//
//  ExtrasViewController.h
//  kaomojikeyboard
//
//  Created by Lowell Duke on 1/4/15.
//  Copyright (c) 2015 Seventh Night Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtrasViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)NSMutableArray* kaomojis;
@property (weak,nonatomic)IBOutlet UITableView* tableView;
@end

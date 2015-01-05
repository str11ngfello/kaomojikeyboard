//
//  ExtraCell.h
//  kaomojikeyboard
//
//  Created by Lowell Duke on 1/4/15.
//  Copyright (c) 2015 Seventh Night Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtraCell : UITableViewCell
@property (weak,nonatomic)IBOutlet UILabel* kaomoji;
@property (weak,nonatomic)IBOutlet UISwitch* toggle;
@end

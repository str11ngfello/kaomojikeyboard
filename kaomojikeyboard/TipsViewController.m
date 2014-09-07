//
//  TipsViewController.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 9/6/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "TipsViewController.h"

@interface TipsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray* tips;
@end

@implementation TipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tips = @[@"Tip 1",@"Tip 2",@"Tip 3"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.tintColor = [UIColor flatGreenColorDark];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipsCellID"];
    if(!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TipsCellID"] ;
        
    }
    
    cell.textLabel.text = [self.tips objectAtIndex:indexPath.row];
    return cell;
    

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

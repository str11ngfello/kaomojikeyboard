//
//  TipsViewController.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 9/6/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "TipsViewController.h"
#import <MessageUI/MessageUI.h>

@interface TipsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray* tips;
@end

@implementation TipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tips = @[@"Tip 1",@"Tip 2",@"Tip 3"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greenGradient.png"]];
    imageView.autoresizingMask =    UIViewAutoresizingFlexibleLeftMargin   |
                                    UIViewAutoresizingFlexibleWidth        |
                                    UIViewAutoresizingFlexibleRightMargin  |
                                    UIViewAutoresizingFlexibleTopMargin    |
                                    UIViewAutoresizingFlexibleHeight       |
                                    UIViewAutoresizingFlexibleBottomMargin ;
    
    [self.tableView setBackgroundView:imageView];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)] ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0 green:.5 blue:0 alpha:1];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, -3, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:206/255.0 green:255/255.0 blue:194/255.0 alpha:1];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44)];
    view.backgroundColor = [UIColor colorWithRed:37/255.0 green:167/255.0 blue:31/255.0 alpha:1];
    [view addSubview:label];
    
    return view;
}
- (IBAction)getSupport:(id)sender {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (controller)
    {
        controller.mailComposeDelegate = self;
        [controller setToRecipients:[NSArray arrayWithObject:@"support@7thnight.com"]];
        [controller setSubject:[NSString stringWithFormat:@"Kaomoji Keyboard Support %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]]];
        
        //[controller setMessageBody:[NSString stringWithFormat:@"\n\n--------------------\nMy Device Info\niOS %@\n%@\n%@",[[UIDevice currentDevice] systemVersion],[AppDelegate deviceModelName],[[[UIDevice currentDevice] identifierForVendor] UUIDString]] isHTML:NO];
        [self showViewController:controller sender:nil];
        
    }

}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{

    [self dismissViewControllerAnimated:true completion:nil];
}

/*
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
    

}*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

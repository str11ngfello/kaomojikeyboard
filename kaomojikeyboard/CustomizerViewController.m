//
//  CustomizerViewController.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 8/22/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "CustomizerViewController.h"
#import "TOMSMorphingLabel.h"
#import "ADLivelyCollectionView.h"
#import "LDCollectionViewCell.h"

@interface CustomizerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveToKeyboardButton;
@property (weak, nonatomic) IBOutlet UIButton *randomizeButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray* categoryViews;
@property (weak, nonatomic) IBOutlet UIPageControl* pageControl;
@property (weak, nonatomic) IBOutlet TOMSMorphingLabel *catLabel;
@property (nonatomic, strong) TOMSMorphingLabel* statusLabel;
@property (nonatomic, strong) NSArray* categories;
@property (nonatomic, strong) NSDictionary* parts;

@property (nonatomic, strong) NSUserDefaults* defaults;
@property (weak, nonatomic) IBOutlet TOMSMorphingLabel *emoji;


@property (nonatomic, strong) NSString* leftFlare;
@property (nonatomic, strong) NSString* rightFlare;
@property (nonatomic, strong) NSString* leftArm;
@property (nonatomic, strong) NSString* rightArm;
@property (nonatomic, strong) NSString* leftEye;
@property (nonatomic, strong) NSString* rightEye;
@property (nonatomic, strong) NSString* leftCheek;
@property (nonatomic, strong) NSString* rightCheek;
@property (nonatomic, strong) NSString* leftBracket;
@property (nonatomic, strong) NSString* rightBracket;
@property (nonatomic, strong) NSString* mouth;

@property (nonatomic, strong) NSArray* arrayOfParts;

@end

@implementation CustomizerViewController

- (void)rebuildEmoji
{
    if (!self.leftFlare || [self.leftFlare isEqualToString:@"none"]) self.leftFlare = @"";
    if (!self.leftArm || [self.leftArm isEqualToString:@"none"]) self.leftArm = @"";
    if (!self.leftBracket || [self.leftBracket isEqualToString:@"n"]) self.leftBracket = @"";
    if (!self.leftCheek || [self.leftCheek isEqualToString:@"none"]) self.leftCheek = @"";
    if (!self.leftEye || [self.leftEye isEqualToString:@"none"]) self.leftEye = @"";
    if (!self.mouth || [self.mouth isEqualToString:@"none"]) self.mouth = @"";
    if (!self.rightEye || [self.rightEye isEqualToString:@"none"]) self.rightEye = @"";
    if (!self.rightCheek || [self.rightCheek isEqualToString:@"none"]) self.rightCheek = @"";
    if (!self.rightBracket || [self.rightBracket isEqualToString:@"o"]) self.rightBracket = @"";
    if (!self.rightArm || [self.rightArm isEqualToString:@"none"]) self.rightArm = @"";
    if (!self.rightFlare || [self.rightFlare isEqualToString:@"none"]) self.rightFlare = @"";
    
    
    self.emoji.text = [[[[[[[[[[_leftFlare stringByAppendingString:_leftArm]
                        stringByAppendingString:_leftBracket]
                        stringByAppendingString:_leftCheek]
                        stringByAppendingString:_leftEye]
                        stringByAppendingString:_mouth]
                        stringByAppendingString:_rightEye]
                        stringByAppendingString:_rightCheek]
                        stringByAppendingString:_rightBracket]
                        stringByAppendingString:_rightArm]
                  stringByAppendingString:_rightFlare];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.mouth forKey:@"CurrentMouth"];
    [[NSUserDefaults standardUserDefaults] setObject:self.leftEye forKey:@"CurrentLeftEye"];
    [[NSUserDefaults standardUserDefaults] setObject:self.leftCheek forKey:@"CurrentLeftCheek"];
    [[NSUserDefaults standardUserDefaults] setObject:self.leftBracket forKey:@"CurrentLeftBracket"];
    [[NSUserDefaults standardUserDefaults] setObject:self.leftArm forKey:@"CurrentLeftArm"];
    [[NSUserDefaults standardUserDefaults] setObject:self.leftFlare forKey:@"CurrentLeftFlare"];
    [[NSUserDefaults standardUserDefaults] setObject:self.rightEye forKey:@"CurrentRightEye"];
    [[NSUserDefaults standardUserDefaults] setObject:self.rightCheek forKey:@"CurrentRightCheek"];
    [[NSUserDefaults standardUserDefaults] setObject:self.rightBracket forKey:@"CurrentRightBracket"];
    [[NSUserDefaults standardUserDefaults] setObject:self.rightArm forKey:@"CurrentRightArm"];
    [[NSUserDefaults standardUserDefaults] setObject:self.rightFlare forKey:@"CurrentRightFlare"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadParts
{
    
    
        self.parts = @{ @"Eyes":
                            
                            @[@"none",@"•",@"◦",@"●",@"○",@"◎",@"⊙",@"◉",@"⦿",@"Ꙩ",@"ಠ",@"ಥಿ", @"ಥ",@"⌒",@"◡",@"⁌",@"⁍",@"Ꙩ",@"•̀",@"⌣̀",@"-",@"✖",@"✘",@"■",@"□",@"★",@"✪",@"◇",@"◆",@"▼",@"﹅",@"﹆",
                              @"◯",@"◓",@"◐",@"◑",@"◒",@"◔",@"◕",@"◴",@"◵",@"◶",@"◷",@"＾",@"￣",@"°",@"❛",@"◕",@"╥",@"≖",  @"˘", @"◔", @"O", @"¬", @"T", @"╹",   @"ↀ",  @"ー", @">", @"<",@"◣",@"◢",  @"^",   @"≧",@"≦", @"⋋",@"⋌",@"´",@"►",@"◄",@"•᷅",@"•᷄",@"‾᷆",@"‾᷇",@"ꉺ",@"˃̶",@"˂̶",@"Ơ̴̴̴̴̴̴͡",@"◞ิ",@"◟ิ",],
                          
                    
                       @"Mouths":
                           @[@"none", @"‿",@"╭╮",@"_", @"～", @"ڡ", @"﹏",@"ᴥ",@"ヮ", @"오",@"ε", @"з",@"ω",@"ʖ̫", @"㉨",@"⊆",@"▽",  @"口", @"︿", @"◇", @"△",@"ᗣ",@"꒶̭",@"ȏ",@"へ",@"人",@"エ",@"ᐛ",@"ཅ",@"␣̍",@"∀", @"Д", @"益",@"皿", @"▃", @"A",@"౪"],

                        @"Brackets":
                        @[@"none",@"()",@"❨❩",@"❪❫",@"⎛⎞",@"⎝⎠",@"༼༽",@"ʕʔ",@"／＼",@"⟨⟩",@"{}",@"〔〕"],
                       @"Left Arms":
                            @[@"none", @"ლ",@"ᕙ",@"ᕦ",@"୧",@"щ",@"Ψ",@"＜",@"└", @"┌", @"╭",@"凸",@"┌∩┐", @"o", @"＼", @"¯\\", @"ヽ",  @"シ",  @"ԅ",@"へ"],
                       @"Right Arms":
                            @[@"none",@"ლ",@"ᕗ",@"ᕤ",@"୨",@"щ",@"Ψ",@"＞",@"づ", @"ノ", @"◜", @"ง", @"┘", @"╮",@"凸",@"┌∩┐",@"☞", @"～", @"っ", @"／", @"/¯", @"~", @"⊃",@"へ"],
                        
                        
                        @"Cheeks":
                            @[@"none",@"✿", @"❁", @"๑", @"＠", @"；", @"҂", @"=", @"*", @"｡", @"╬", @"∴",@"メ",],
                        
                        @"Flares":
                            @[@"none"],
                       };
    
    
    
    
    self.categories = @[@"Mouths",@"Eyes",@"Cheeks",@"Brackets",@"Left Arms",@"Right Arms"];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.tintColor = [UIColor flatOrangeColorDark];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.seventhnight.kaomojikeyboard"];
    [self.defaults synchronize];
    
    //NSLog(@"containing app - %@",[self.defaults objectForKey:@"CustomArray"]);
   
    if (![self.defaults objectForKey:@"CustomArray"])
    {
        [self.defaults setObject:[[NSMutableArray alloc] initWithCapacity:0] forKey:@"CustomArray"];
        [self.defaults synchronize];
    }
    
    [self loadParts];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width * [self.categories count], self.scrollView.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    
    self.pageControl.numberOfPages = self.categories.count;
    self.pageControl.currentPage = 0;
    [self.pageControl setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.view addSubview:self.pageControl];
    
    
    self.catLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:20];

    self.catLabel.textAlignment = NSTextAlignmentCenter;
    self.catLabel.text = [self.categories objectAtIndex:0];
    
    self.statusLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(160-75,-5,150,30)];
    self.statusLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    
    [self.statusLabel setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    self.statusLabel.textColor = [UIColor darkGrayColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.statusLabel];
    
    
    self.categoryViews = [[NSMutableArray alloc] initWithCapacity:self.categories.count];
    for (int i = 0;i < self.categories.count;++i)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 25;
        ADLivelyCollectionView* colview = [[ADLivelyCollectionView alloc] initWithFrame:CGRectMake(i*[[UIScreen mainScreen] bounds].size.width, 0, 320, self.scrollView.frame.size.height) collectionViewLayout:layout];
        
        [colview setDataSource:self];
        [colview setDelegate:self];
        
        //[colview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [colview registerNib:[UINib nibWithNibName:@"LDCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
        colview.initialCellTransformBlock = ADLivelyTransformHelix;
        
        UILongPressGestureRecognizer* press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(partHold:)];
        [press setDelegate:self];
        press.minimumPressDuration = .5;
        press.delaysTouchesBegan = YES;
        [colview addGestureRecognizer:press];

        
        colview.tag = i;
        [self.categoryViews addObject:colview];
        [self.scrollView addSubview:colview];
        
}
    
    
    [self.scrollView setNeedsDisplay];
    [self.scrollView setNeedsLayout];

    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentMouth"])
    {
        self.leftArm = @"ლ";
        self.leftBracket = @"(";
        self.leftEye = @"⦿";
        self.mouth = @"ڡ";
        self.rightEye = @"⦿";
        self.rightBracket = @")";
        self.rightArm = @"ლ";
    }
    else
    {
        self.mouth = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentMouth"];
        self.leftEye = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentLeftEye"];
        self.leftCheek = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentLeftCheek"];
        self.leftBracket = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentLeftBracket"];
        self.leftArm = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentLeftArm"];
        self.leftFlare = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentLeftFlare"];
        self.rightEye = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentRightEye"];
        self.rightCheek = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentRightCheek"];
        self.rightBracket = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentRightBracket"];
        self.rightArm = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentRightArm"];
        self.rightFlare = [[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentRightFlare"];
       
    }
    [self rebuildEmoji];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
    
    self.catLabel.text = [self.categories objectAtIndex:page];
    
    
}

- (void)partHold:(UILongPressGestureRecognizer *)sender {
    if ( sender.state == UIGestureRecognizerStateBegan ) {
        
        UICollectionView* colView = (UICollectionView*)sender.view;
        CGPoint p = [sender locationInView:colView];
        
        NSIndexPath *indexPath = [colView indexPathForItemAtPoint:p];
        if (indexPath == nil){
            NSLog(@"couldn't find index path");
        } else {
            // get the cell at indexPath (the one you long pressed)
            UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
            
            //If we are IN favorites, remove the kaomoji, otherwise add it
            NSMutableArray* favorites = [[self.defaults objectForKey:@"FavoriteArray"] mutableCopy];
            UILabel* l = (UILabel*)[cell viewWithTag:100];
            
            //stop if this is a padding cell
            if ([l.text isEqualToString:@""])
                return;
            
            if ([[self.categories objectAtIndex:colView.tag] isEqualToString:@"Eyes"])
            {
                
                RIButtonItem *leftEye = [RIButtonItem itemWithLabel:@"Left Eye" action:^{
                    self.leftEye = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    [self rebuildEmoji];
                }];
                
                RIButtonItem *rightEye = [RIButtonItem itemWithLabel:@"Right Eye" action:^{
                    self.rightEye = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    [self rebuildEmoji];
                    
                }];
                
                RIButtonItem *bothEyes = [RIButtonItem itemWithLabel:@"Both Eyes" action:^{
                    self.leftEye = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    self.rightEye = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    [self rebuildEmoji];
                    
                }];
                
                UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Which eye?" cancelButtonItem:[RIButtonItem itemWithLabel:@"Cancel" action:nil] destructiveButtonItem:nil otherButtonItems:leftEye,rightEye,bothEyes, nil];
                [actionSheet showInView:self.view];
            }
            /*else if ([[self.categories objectAtIndex:colView.tag] isEqualToString:@"Arms"])
            {
                
                RIButtonItem *leftArm = [RIButtonItem itemWithLabel:@"Left Arm" action:^{
                    self.leftArm = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    [self rebuildEmoji];
                }];
                
                RIButtonItem *rightArm = [RIButtonItem itemWithLabel:@"Right Arm" action:^{
                    self.rightArm = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    [self rebuildEmoji];
                    
                }];
                
                RIButtonItem *bothArms = [RIButtonItem itemWithLabel:@"Both Arms" action:^{
                    self.leftArm = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    self.rightArm = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    [self rebuildEmoji];
                    
                }];
                
                UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Which arm?" cancelButtonItem:[RIButtonItem itemWithLabel:@"Cancel" action:nil] destructiveButtonItem:nil otherButtonItems:leftArm,rightArm,bothArms, nil];
                [actionSheet showInView:self.view];
            }*/
            else if ([[self.categories objectAtIndex:colView.tag] isEqualToString:@"Flares"])
            {
                
                RIButtonItem *leftFlare = [RIButtonItem itemWithLabel:@"Left Flare" action:^{
                    self.leftFlare = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    [self rebuildEmoji];
                }];
                
                RIButtonItem *rightFlare = [RIButtonItem itemWithLabel:@"Right Flare" action:^{
                    self.rightFlare = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    [self rebuildEmoji];
                    
                }];
                
                RIButtonItem *bothFlares = [RIButtonItem itemWithLabel:@"Both Flares" action:^{
                    self.leftFlare = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    self.rightFlare = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    [self rebuildEmoji];
                    
                }];
                
                UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Which flare?" cancelButtonItem:[RIButtonItem itemWithLabel:@"Cancel" action:nil] destructiveButtonItem:nil otherButtonItems:leftFlare,rightFlare,bothFlares, nil];
                [actionSheet showInView:self.view];

            }
            else if ([[self.categories objectAtIndex:colView.tag] isEqualToString:@"Cheeks"])
            {
                
                RIButtonItem *leftCheek = [RIButtonItem itemWithLabel:@"Left Cheek" action:^{
                    self.leftCheek = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    [self rebuildEmoji];
                }];
                
                RIButtonItem *rightCheek = [RIButtonItem itemWithLabel:@"Right Cheek" action:^{
                    self.rightCheek = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    [self rebuildEmoji];
                    
                }];
                
                RIButtonItem *bothCheeks = [RIButtonItem itemWithLabel:@"Both Cheeks" action:^{
                    self.leftCheek = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    self.rightCheek = [[self.parts objectForKey:[self.categories objectAtIndex:colView.tag]] objectAtIndex:indexPath.row];
                    [self rebuildEmoji];
                    
                }];
                
                UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Which flare?" cancelButtonItem:[RIButtonItem itemWithLabel:@"Cancel" action:nil] destructiveButtonItem:nil otherButtonItems:leftCheek,rightCheek,bothCheeks, nil];
                [actionSheet showInView:self.view];

            }


            
        }
    }
}

/*- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 22)];
            reusableview.autoresizesSubviews = true;
            reusableview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        }
        
        
        if ([reusableview viewWithTag:100] == nil)
        {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 22)];
            label.text= [[CustomizerViewController emojiParts] objectAtIndex:indexPath.section];
            //label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.05];
            label.textAlignment = NSTextAlignmentCenter;
            label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            label.tag = 100;
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            [reusableview addSubview:label];
            
            if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark)
            {
                reusableview.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.2];
                label.textColor = [UIColor whiteColor];
            }
            else
            {
                reusableview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.05];
                label.textColor = [UIColor darkGrayColor];
            }
            
            
        }
        else
        {
            UILabel *label = (UILabel*)[reusableview viewWithTag:100];
            label.text= [subCategories objectAtIndex:indexPath.section];
        }
        
        return reusableview;
    }
    return nil;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize headerSize = CGSizeMake(self.scrollView.frame.size.width, 25);
    return headerSize;
}
*/

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 5, 5);
}



-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int count = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] count];
    return count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"Cell";
    
    LDCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell.backgroundView) {
        UIView * backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView = backgroundView;
        
    }
    

    if (indexPath.row == 0)
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    else
        cell.textLabel.font = [UIFont systemFontOfSize:26];
    
    
    cell.textLabel.text = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
 
    if (cell.textLabel.text.length > 2)
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    
    cell.textLabel.textColor = [UIColor blackColor];
   
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // [((LDCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath]) selectionEffect];
    
    if ([[self.categories objectAtIndex:collectionView.tag] isEqualToString:@"Mouths"])
    {
        self.mouth = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
    }
    else if ([[self.categories objectAtIndex:collectionView.tag] isEqualToString:@"Eyes"])
    {
        self.leftEye = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
        self.rightEye = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
    }
    else if ([[self.categories objectAtIndex:collectionView.tag] isEqualToString:@"Brackets"])
    {
        unichar c = [[[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row] characterAtIndex:0];
        self.leftBracket = [NSString stringWithCharacters:&c length:1];
        c = [[[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row] characterAtIndex:1];
        self.rightBracket = [NSString stringWithCharacters:&c length:1];
    }
    else if ([[self.categories objectAtIndex:collectionView.tag] isEqualToString:@"Left Arms"])
    {
        self.leftArm = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
    }
    else if ([[self.categories objectAtIndex:collectionView.tag] isEqualToString:@"Right Arms"])
    {
        self.rightArm = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
     }
    else if ([[self.categories objectAtIndex:collectionView.tag] isEqualToString:@"Flares"])
    {
        self.leftFlare = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
        self.rightFlare = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
    }
    else if ([[self.categories objectAtIndex:collectionView.tag] isEqualToString:@"Cheeks"])
    {
        self.leftCheek = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
        self.rightCheek = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
    }
    
    [self rebuildEmoji];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(54,54);
    
}

- (IBAction)saveToKeyboard:(id)sender {
    if (self.emoji.text.length == 0)
        return;
    
    NSMutableArray* customs = [[self.defaults objectForKey:@"CustomArray"] mutableCopy];
    bool found = false;
    for (NSString* s in customs)
    {
        if ([s isEqualToString:self.emoji.text])
        {
            found = true;
            break;
        }
    }
    if (!found)
    {
        
        [customs insertObject:self.emoji.text atIndex:0];
        [self.defaults setObject:customs forKey:@"CustomArray"];
        [self.defaults synchronize];
        [SVProgressHUD showSuccessWithStatus:@"Kaomoji Saved!"];
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"SavedToKeyboardInformed"])
        {
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"SavedToKeyboardInformed"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Saved Kaomoji"
                                                             message:@"You can find all your saved Kaomojis in the keyboard on the last page titled \"Customized\""
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];

        }
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"Kamoji Already Exists"];
    }
    
}

- (IBAction)clear:(id)sender {
    self.leftFlare = @"";
    self.leftArm = @"";
    self.leftBracket = @"";
    self.leftCheek = @"";
    self.leftEye = @"";
    self.mouth = @"";
    self.rightEye = @"";
    self.rightCheek = @"";
    self.rightBracket = @"";
    self.rightArm = @"";
    self.rightFlare = @"";
    
    [self rebuildEmoji];
}
- (IBAction)random:(id)sender {
    
    int random = arc4random()%((NSArray*)self.parts[@"Brackets"]).count;
    unichar c = [[self.parts[@"Brackets"] objectAtIndex:random] characterAtIndex:0];
    self.leftBracket = [NSString stringWithCharacters:&c length:1];
    c = [[self.parts[@"Brackets"] objectAtIndex:random] characterAtIndex:1];
    self.rightBracket = [NSString stringWithCharacters:&c length:1];
    
    random = arc4random()%((NSArray*)self.parts[@"Eyes"]).count;
    self.leftEye = [self.parts[@"Eyes"] objectAtIndex:random];
    self.rightEye = [self.parts[@"Eyes"] objectAtIndex:random];
 
    random = arc4random()%((NSArray*)self.parts[@"Cheeks"]).count;
    self.leftCheek = [self.parts[@"Cheeks"] objectAtIndex:random];
    self.rightCheek = [self.parts[@"Cheeks"] objectAtIndex:random];

    self.leftFlare = @"";
    self.leftArm = [self.parts[@"Left Arms"] objectAtIndex:arc4random()%((NSArray*)self.parts[@"Left Arms"]).count];
    self.mouth = [self.parts[@"Mouths"] objectAtIndex:arc4random()%((NSArray*)self.parts[@"Mouths"]).count];
    self.rightArm = [self.parts[@"Right Arms"] objectAtIndex:arc4random()%((NSArray*)self.parts[@"Right Arms"]).count];
    self.rightFlare = @"";

    
    [self rebuildEmoji];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

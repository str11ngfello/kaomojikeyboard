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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray* categoryViews;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (weak, nonatomic) IBOutlet TOMSMorphingLabel *catLabel;

@property (nonatomic, strong) TOMSMorphingLabel* statusLabel;
@property (nonatomic, strong) NSArray* categories;
@property (nonatomic, strong) NSDictionary* parts;

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
    if (!self.leftFlare) self.leftFlare = @"";
    if (!self.leftArm) self.leftArm = @"";
    if (!self.leftBracket) self.leftBracket = @"";
    if (!self.leftCheek) self.leftCheek = @"";
    if (!self.leftEye) self.leftEye = @"";
    if (!self.mouth) self.mouth = @"";
    if (!self.rightEye) self.rightEye = @"";
    if (!self.rightCheek) self.rightCheek = @"";
    if (!self.rightBracket) self.rightBracket = @"";
    if (!self.rightArm) self.rightArm = @"";
    if (!self.rightFlare) self.rightFlare = @"";
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
}

- (void)loadParts
{
    
    
        self.parts = @{ @"Eyes":
                            
                            @[@"•",@"◦",@"●",@"○",@"◎",@"◉",@"⦿",@"⁌",@"⁍",@"-",@"■",@"□",@"✪",@"◇",@"◆",@"﹅",@"﹆",@"◯",@"◓",@"◐",@"◑",@"◒",@"◔",@"◕",@"◴",@"◵",@"◶",@"◷",@"Ꙩ",@"❁",@"♥",@"＾",@"￣",@"°",@"❛",@"⌒",@"◕",@"╥",@"≖",@"◉", @"・", @"ಠ", @"◠", @"✖", @"˘", @"●", @"◔", @"O", @"¬", @"T", @"╹", @"◡", @"ಥಿ", @"ಥ", @"①", @"★", @"ー", @">", @"•̀", @"╯", @"｀", @"^",@"･",@"⊙", @"ò", @"⌣̀", @"≧", @"｀・", @"´", @"´"],
                          
                    
                       @"Mouths":
                           @[@"ヮ", @"ε", @"з", @"▽", @"∀", @"Д", @"_", @"～", @"ڡ", @"﹏", @"╭╮", @"益", @"▃", @"ᴥ", @"ω", @"A", @"口", @"︿", @"㉨", @"◇", @"△", @"⊆", @"‿", @"3", @"오"],

                        @"Brackets":
                        @[@"()",@"❨❩",@"❪❫",@"⟨⟩",@"{}",@"⎛⎞",@"⎝⎠",@"༼༽",@"ʕʔ",@"〔〕",@"[]",@"／＼",@"⎟⎢",@"⟪⟫",@"«»",@"<>",@"⎩⎭",@"⎣⎦",@"⎧⎫",@"【】"],
                       @"Right Arms":
                            @[@"づ", @"ノ", @"◜", @"ง", @"┘", @"╮", @"☞", @"～", @"っ", @"／", @"/¯", @"ᕗ", @"＞", @"~", @"⊃"],
                        
                        @"Left Arms":
                            @[@"ლ", @"└", @"┌", @"╭", @"щ", @"o", @"＼", @"¯\\", @"ヽ", @"ᕙ", @"シ", @"＜", @"ԅ"],
                        
                        @"Cheeks":
                            @[@"✿", @"❁", @"๑", @"＠", @"；", @"҂", @"=", @"*", @"｡", @"╬", @"∴"],
                        
                        @"Left Flares":
                            @[],
                        @"Right Flares":
                            @[],
                       };
    
    
    
    
    self.categories = @[@"Mouths",@"Eyes",@"Brackets",@"Right Arms",@"Left Arms",@"Cheeks",@"Left Flares",@"Right Flares"];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadParts];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320 * [self.categories count], 158);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(160-75, -8, 150, 40);
    self.pageControl.numberOfPages = self.categories.count;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.pageControl setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.view addSubview:self.pageControl];
    
    
    self.catLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    self.catLabel.textColor = [UIColor darkGrayColor];
    self.catLabel.textAlignment = NSTextAlignmentCenter;
    self.catLabel.text = @"Eyes";
    
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
        ADLivelyCollectionView* colview = [[ADLivelyCollectionView alloc] initWithFrame:CGRectMake(i*320, 0, 320, 158) collectionViewLayout:layout];
        
        [colview setDataSource:self];
        [colview setDelegate:self];
        
        //[colview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [colview registerNib:[UINib nibWithNibName:@"LDCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
        colview.initialCellTransformBlock = ADLivelyTransformHelix;
        
        colview.tag = i;
        [self.categoryViews addObject:colview];
        [self.scrollView addSubview:colview];
        
}
    
    
    [self.scrollView setNeedsDisplay];
    [self.scrollView setNeedsLayout];

    [self rebuildEmoji];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
    
    self.catLabel.text = [self.categories objectAtIndex:page];
    
    
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
    return UIEdgeInsetsMake(0, 20, 20, 20);
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
    

    cell.textLabel.font = [UIFont systemFontOfSize:28];
    
    
    cell.textLabel.text = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
 
    cell.textLabel.textColor = [UIColor blackColor];
   
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [((LDCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath]) selectionEffect];
    
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
    else if ([[self.categories objectAtIndex:collectionView.tag] isEqualToString:@"Left Flares"])
    {
        self.leftFlare = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
    }
    else if ([[self.categories objectAtIndex:collectionView.tag] isEqualToString:@"Right Flares"])
    {
        self.rightFlare = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
    }
    else if ([[self.categories objectAtIndex:collectionView.tag] isEqualToString:@"Cheeks"])
    {
        self.leftCheek = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
        self.rightCheek = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
    }
    else if ([[self.categories objectAtIndex:collectionView.tag] isEqualToString:@"Left Flare"])
    {
        self.leftFlare = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
    }
    else if ([[self.categories objectAtIndex:collectionView.tag] isEqualToString:@"Right Flare"])
    {
        self.rightFlare = [[self.parts objectForKey:[self.categories objectAtIndex:collectionView.tag]] objectAtIndex:indexPath.row];
    }
    
    [self rebuildEmoji];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(32,32);
    
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

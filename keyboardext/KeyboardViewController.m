//
//  KeyboardViewController.m
//  keyboardext
//
//  Created by Lowell Duke on 8/10/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "KeyboardViewController.h"
#import "KeyboardView.h"
#import "TOMSMorphingLabel.h"

#define SCROLL_VIEW_BOTTOM_PADDING 64
#define CELL_HEIGHT 35

@interface KeyboardViewController ()
@property (nonatomic, strong)KeyboardView* keyboardView;
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSMutableArray* categoryViews;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) NSArray* emojiCategories;
@property (nonatomic, strong) NSDictionary* emojiSubCategories;
@property (nonatomic, strong) NSDictionary* emojiColumnWidths;
@property (nonatomic, strong) NSMutableDictionary* emojis;
@property (nonatomic, assign) int sizeOfLastEntry;
@property (nonatomic, strong) NSUserDefaults* defaults;
@property (nonatomic, strong) TOMSMorphingLabel* catLabel;
@property (nonatomic, strong) TOMSMorphingLabel* statusLabel;
@property (nonatomic, assign) bool canStartNewStatus;
@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
    
    self.catLabel.text = [self.emojiCategories objectAtIndex:page];
    
    [self.defaults setInteger:page forKey:@"CurrentPage"];
    [self.defaults synchronize];

}


- (void)favPress:(UILongPressGestureRecognizer *)sender {
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
            
            //Add to favorites if it doesn't already exist
            if (self.pageControl.currentPage == 0)
            {
                [favorites removeObject:l.text];
                [self.defaults setObject:favorites forKey:@"FavoriteArray"];
                [self.defaults synchronize];
                
                if (self.canStartNewStatus)
                {
                    self.canStartNewStatus = false;
                    self.pageControl.hidden = true;
                    self.catLabel.hidden = true;
                    self.statusLabel.text = @"removed from favorites";
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        self.statusLabel.text = @"";
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            self.pageControl.hidden = false;
                            self.catLabel.hidden = false;
                            self.canStartNewStatus = true;
                            
                        });
                    });
                }
                
                //Refresh favorites collectionview
                [((UICollectionView*)[self.categoryViews objectAtIndex:0]) reloadData];
            }
            else
            {
                bool found = false;
                for (NSString* s in favorites)
                {
                    if ([s isEqualToString:l.text])
                    {
                        found = true;
                        break;
                    }
                }
                if (!found)
                {
                    
                    [favorites insertObject:l.text atIndex:0];
                    [self.defaults setObject:favorites forKey:@"FavoriteArray"];
                    [self.defaults synchronize];
                    
                    if (self.canStartNewStatus)
                    {
                        self.canStartNewStatus = false;
                        self.pageControl.hidden = true;
                        self.catLabel.hidden = true;
                        self.statusLabel.text = @"added to favorites";
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            self.statusLabel.text = @"";
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                self.pageControl.hidden = false;
                                self.catLabel.hidden = false;
                                self.canStartNewStatus = true;
                                
                            });
                        });
                    }
                    //Refresh favorites collectionview
                    [((UICollectionView*)[self.categoryViews objectAtIndex:0]) reloadData];
                    
                    
                }
                else
                {
                    if (self.canStartNewStatus)
                    {
                        self.canStartNewStatus = false;
                        self.pageControl.hidden = true;
                        self.catLabel.hidden = true;
                        self.statusLabel.text = @"already in favorites";
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            self.statusLabel.text = @"";
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                self.pageControl.hidden = false;
                                self.catLabel.hidden = false;
                                self.canStartNewStatus = true;
                                
                            });
                        });
                    }

                }
            }
        }
       
       
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.canStartNewStatus = true;
   self.automaticallyAdjustsScrollViewInsets = NO;
     
    //Create shared defaults
    self.defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.seventhnight.kaomojikeyboard"];
    
    if (![self.defaults objectForKey:@"HistoryArray"])
    {
        [self.defaults setObject:[[NSMutableArray alloc] initWithCapacity:0] forKey:@"HistoryArray"];
        [self.defaults synchronize];
    }
    
    if (![self.defaults objectForKey:@"FavoriteArray"])
    {
        [self.defaults setObject:[[NSMutableArray alloc] initWithCapacity:0] forKey:@"FavoriteArray"];
        [self.defaults synchronize];
    }
    

    [self loadEmojis];
    
    
    
    self.sizeOfLastEntry = 5 ;
    
    self.keyboardView = [[[NSBundle mainBundle] loadNibNamed:@"KeyboardView" owner:self options:nil] objectAtIndex:0];
    self.keyboardView.frame = CGRectMake(0, 0, 320, 216);
    [self.keyboardView setNeedsDisplay];
    self.keyboardView.keyboardViewController = self;
    
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 158)];
    [self.keyboardView addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320 * 2, 158);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    

    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(160-75, -8, 150, 40);
    self.pageControl.numberOfPages = [self.emojiCategories count];
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.pageControl setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.keyboardView addSubview:self.pageControl];
    
    
    self.catLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(5,-4,100,30)];
    self.catLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark)
        self.catLabel.textColor = [UIColor whiteColor];
    else
        self.catLabel.textColor = [UIColor darkGrayColor];
    self.catLabel.text = @"Favorites";
    [self.view addSubview:self.catLabel];
 
    self.statusLabel = [[TOMSMorphingLabel alloc] initWithFrame:CGRectMake(160-75,-5,150,30)];
    self.statusLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:14];

    [self.statusLabel setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark)
        self.statusLabel.textColor = [UIColor whiteColor];
    else
        self.statusLabel.textColor = [UIColor darkGrayColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.keyboardView addSubview:self.statusLabel];

   
    self.categoryViews = [[NSMutableArray alloc] initWithCapacity:[self.emojiCategories count]];
    for (int i = 0;i < [self.emojiCategories count];++i)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        ADLivelyCollectionView* colview = [[ADLivelyCollectionView alloc] initWithFrame:CGRectMake(i*320, 0, 320, 158) collectionViewLayout:layout];
        
        [colview setDataSource:self];
        [colview setDelegate:self];
       
        [colview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [colview registerNib:[UINib nibWithNibName:@"LDCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
        colview.initialCellTransformBlock = ADLivelyTransformHelix;
        
        
        colview.tag = i;
        [self.categoryViews addObject:colview];
        [self.scrollView addSubview:colview];
        
        UILongPressGestureRecognizer* press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(favPress:)];
        [press setDelegate:self];
        press.minimumPressDuration = .5;
        press.delaysTouchesBegan = YES;
        [colview addGestureRecognizer:press];
    }
  
    [self.inputView addSubview:self.keyboardView];
    
    [self.scrollView setNeedsDisplay];
    [self.scrollView setNeedsLayout];
    
    
}

-(void)viewDidLayoutSubviews {
    
    int appExtensionWidth = (int)round(self.view.frame.size.width);
    int appExtensionHeight = (int)round(self.view.frame.size.height);
    
    int possibleScreenWidthValue1 = (int)round([[UIScreen mainScreen] bounds].size.width);
    int possibleScreenWidthValue2 = (int)round([[UIScreen mainScreen] bounds].size.height);
    
    
    /*int screenWidthValue;
    
    if (possibleScreenWidthValue1 < possibleScreenWidthValue2) {
        screenWidthValue = possibleScreenWidthValue1;
    } else {
        screenWidthValue = possibleScreenWidthValue2;
    }
    
    if (appExtensionWidth == screenWidthValue) {
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, appExtensionHeight - SCROLL_VIEW_BOTTOM_PADDING);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4, appExtensionHeight - SCROLL_VIEW_BOTTOM_PADDING);
        self.keyboardView.frame = CGRectMake(0, 0, self.view.frame.size.width, appExtensionHeight);
        
    } else {*/
        self.scrollView.frame = CGRectMake(0, 20, self.view.frame.size.width, appExtensionHeight - SCROLL_VIEW_BOTTOM_PADDING);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * [self.emojiCategories count], appExtensionHeight - SCROLL_VIEW_BOTTOM_PADDING);
        self.keyboardView.frame = CGRectMake(0, 0, self.view.frame.size.width, appExtensionHeight);
    
        self.scrollView.contentOffset = CGPointMake([self.defaults integerForKey:@"CurrentPage"]*self.view.frame.size.width,0);
    
    //}

    for (int i = 0;i < [self.emojiCategories count];++i)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        ((ADLivelyCollectionView*)[self.categoryViews objectAtIndex:i]).frame = frame;
        [((ADLivelyCollectionView*)[self.categoryViews objectAtIndex:i]) reloadData];
        
    }

    
    //[self.keyboardView bringSubviewToFront:self.keyboardView.nextKeyboardButton];
    //[self.keyboardView bringSubviewToFront:self.keyboardView.clearButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 22)];
            reusableview.autoresizesSubviews = true;
            reusableview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        }
        
        //Get Category
        NSString* category = [self.emojiCategories objectAtIndex:collectionView.tag];
        
        //Find Subcategories
        NSArray* subCategories = [self.emojiSubCategories objectForKey:category];
        
        if ([reusableview viewWithTag:100] == nil)
        {
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 22)];
            label.text= [subCategories objectAtIndex:indexPath.section];
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


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //Get Category
    NSString* category = [self.emojiCategories objectAtIndex:collectionView.tag];
    
    //Find Subcategories
    NSArray* subCategories = [self.emojiSubCategories objectForKey:category];
    
    if (subCategories != nil)
    {
        return subCategories.count;
    }
    else
        return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    if (collectionView.tag == 0)
    {
        NSArray* favorites = [self.defaults objectForKey:@"FavoriteArray"];
        if ([favorites count] == 0)
            return 1;
        else if ([favorites count] < 4)
            return 4;
        else
            return [favorites count];
    }
    else if (collectionView.tag == 1)
    {
        
        NSArray* history = [self.defaults objectForKey:@"HistoryArray"];
        if ([history count] == 0)
            return 1;
        else if ([history count] < 4)
            return 4;
        else
            return [history count];
    }
    else
    {
        //Get Category
        NSString* category = [self.emojiCategories objectAtIndex:collectionView.tag];
        
        //Find Subcategories
        NSArray* subCategories = [self.emojiSubCategories objectForKey:category];
        
        NSArray* emojiArray = [self.emojis objectForKey:[subCategories objectAtIndex:section]];
        
        
        //Find widths for subcategories
        NSArray* widths = [self.emojiColumnWidths objectForKey:category];
        int numColumns = (self.scrollView.frame.size.width)/[[widths objectAtIndex:section] integerValue];
        
        //Since UICollectionViews don't scroll unless you drag on a cell, it's a poor user experience
        //if they happen to drag on an empty area in a section.  So here we pad the number of collection view
        //cells to always fill the full section.  The padding cells are just blank and are special cased
        //throughout the code to be ignored
        int padding = numColumns - (emojiArray.count % numColumns);
        
        //If no padding needed because cells fill the entire section...
        if (padding == numColumns)
            return emojiArray.count;
        //else pad with empty cells
        else
            return emojiArray.count + padding;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"Cell";
    
    LDCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell.backgroundView) {
        UIView * backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView = backgroundView;
        
    }
    
    if (collectionView.tag == 0)
    {
        //If we don't have any favs, create empty objects so that user can still swipe the page easily
        NSArray* favorites = [self.defaults objectForKey:@"FavoriteArray"];
        if ([favorites count] == 0)
        {
            cell.textLabel.text = @"No favorites.\nTap and hold a kaomoji to add\nas a favorite.";
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
            if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark)
                cell.textLabel.textColor = [UIColor lightGrayColor];
            else
                cell.textLabel.textColor = [UIColor darkGrayColor];
        }
        else
        {
            if (indexPath.row >= [favorites count])
                cell.textLabel.text = @"";
            else
                cell.textLabel.text = [favorites objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark)
                cell.textLabel.textColor = [UIColor whiteColor];
            else
                cell.textLabel.textColor = [UIColor blackColor];

        }

    }
    else if (collectionView.tag == 1)
    {
        //If we don't have any history, create empty objects so that user can still swipe the page easily
        NSArray* history = [self.defaults objectForKey:@"HistoryArray"];
        if ([history count] == 0)
        {
            cell.textLabel.text = @"No recently used.";
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
            if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark)
                cell.textLabel.textColor = [UIColor lightGrayColor];
            else
                cell.textLabel.textColor = [UIColor darkGrayColor];

        }
        else
        {
            if (indexPath.row >= [history count])
                cell.textLabel.text = @"";
            else
                cell.textLabel.text = [history objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark)
                cell.textLabel.textColor = [UIColor whiteColor];
            else
                cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    else
    {
        //Get Category
        NSString* category = [self.emojiCategories objectAtIndex:collectionView.tag];
        
        //Find Subcategories
        NSArray* subCategories = [self.emojiSubCategories objectForKey:category];
        
        NSArray* emojiArray = [self.emojis objectForKey:[subCategories objectAtIndex:indexPath.section]];

        cell.textLabel.font = [UIFont systemFontOfSize:18];
        if (indexPath.row >= [emojiArray count])
            cell.textLabel.text = @"";
        else
            cell.textLabel.text = [emojiArray objectAtIndex:indexPath.row];
        if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark)
            cell.textLabel.textColor = [UIColor whiteColor];
        else
            cell.textLabel.textColor = [UIColor blackColor];
    }
    /*UIColor * altBackgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
     cell.backgroundView.backgroundColor = [indexPath row] % 2 == 0 ? [UIColor whiteColor] : altBackgroundColor;
     */
    //cell.textLabel.backgroundColor = cell.backgroundView.backgroundColor;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [((LDCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath]) selectionEffect];

    if (collectionView.tag == 0)
    {
        NSArray* favorites = [self.defaults objectForKey:@"FavoriteArray"];
        if ([favorites count] == 0)
        {
            //do nothing
        }
        else if (indexPath.row >= [favorites count])
        {
            //do nothing
        }
        else
        {
            [self.textDocumentProxy insertText:[favorites objectAtIndex:indexPath.row]];
            self.sizeOfLastEntry = [[favorites objectAtIndex:indexPath.row] length];
            
        }
    }
    else if (collectionView.tag == 1)
    {
        NSArray* history = [self.defaults objectForKey:@"HistoryArray"];
        if ([history count] == 0)
        {
            //do nothing
        }
        else if (indexPath.row >= [history count])
        {
            //do nothing
        }
        else
        {
            [self.textDocumentProxy insertText:[history objectAtIndex:indexPath.row]];
            self.sizeOfLastEntry = [[history objectAtIndex:indexPath.row] length];
        }
    }
    else
    {
        
        //Get Category
        NSString* category = [self.emojiCategories objectAtIndex:collectionView.tag];
        
        //Find Subcategories
        NSArray* subCategories = [self.emojiSubCategories objectForKey:category];
        
        NSArray* emojiArray = [self.emojis objectForKey:[subCategories objectAtIndex:indexPath.section]];
        
        //Ignore padding cells...
        if (indexPath.row >= emojiArray.count)
            return;
        
        [self.textDocumentProxy insertText:[emojiArray objectAtIndex:indexPath.row]];
        self.sizeOfLastEntry = [[emojiArray objectAtIndex:indexPath.row] length];
    
        //Add to history
        NSMutableArray* history = [[self.defaults objectForKey:@"HistoryArray"] mutableCopy];
        if ([history count] > 250)
            [history removeLastObject];
        [history insertObject:[emojiArray objectAtIndex:indexPath.row] atIndex:0];
        [self.defaults setObject:history forKey:@"HistoryArray"];
        [self.defaults synchronize];
        
        //Refresh history collectionview
        [((UICollectionView*)[self.categoryViews objectAtIndex:1]) reloadData];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //Decide how many columns we want to shoot for because some kaomoji are naturally longer than others
    NSArray* favorites = [[self.defaults objectForKey:@"FavoriteArray"] mutableCopy];
    NSArray* history = [[self.defaults objectForKey:@"HistoryArray"] mutableCopy];
    if ((collectionView.tag == 0 && [favorites count] == 0) ||
        (collectionView.tag == 1 && [history count] == 0))
        return CGSizeMake(640,130);
    else
    {
        //Get Category
        NSString* category = [self.emojiCategories objectAtIndex:collectionView.tag];
        
        //Find widths for subcategories
        NSArray* widths = [self.emojiColumnWidths objectForKey:category];

        int numColumns = (self.scrollView.frame.size.width)/[[widths objectAtIndex:indexPath.section] integerValue];
        if (numColumns != 0)
            return CGSizeMake((self.scrollView.frame.size.width)/numColumns-1, CELL_HEIGHT);
        else
            return CGSizeMake(320,CELL_HEIGHT);
    }
}

-(void)clear
{
    //for (int i = 0;i < self.sizeOfLastEntry;++i)
    [self.textDocumentProxy deleteBackward];

}
-(void)loadEmojis
{
    //self.emojiCategories = @[@"Favorites",@"Recent",@"Faces",@"Actions",@"Hugs",@"Whatever",@"The Bird",@"Trolls",@"Table Flip",@"Phrases",@"Misc"];
    self.emojiCategories = @[@"Favorites",@"Recent",@"Emotions",@"Actions",@"Characters",@"Phrases"];
    //self.emojiColumnWidths = @[@200,@200,@100,@100,@200,@100,@120,@100,@200,@200,@200];

    self.emojiColumnWidths = @{@"Favorites":@[@200],
                               @"Recent":@[@200],
                               @"Emotions":@[@100,@100,@100,@100,@100,@100,@100],
                               @"Actions":@[@100,@120,@120,@120,@120,@120,@200,@100,@200,@200],
                               @"Characters":@[@120,@120,@120,@120,@120,@120,@120,@120,@120,@120],
                               @"Phrases":@[@200],
                               };
    
    self.emojiSubCategories = @{@"Emotions":@[@"Happy",@"Sad",@"Angry",@"Love",@"Worried",@"Shocked",@"Annoyed"],
                                @"Actions":@[@"Flexing",@"Dancing",@"Hugging",@"Kissing", @"Winking",@"Waving",@"Flipping the Bird",@"Whatever",@"High Fiving",@"Table Flipping"],
                                @"Characters":@[@"Dogs",@"Cats",@"Rabbits",@"Bears",@"Pigs",@"Monkeys",@"Devils",@"Zombies",@"Trolls",@"Flower Girls"],
                                @"Phrases":@[@"Phrases"],
                                };
                                
    NSDictionary* lib = @{ @"Happy":
                              @[@"(ʘ‿ʘ)",
                                @"(Ꙩ‿Ꙩ)",
                                @"(◉‿◉)",
                                @"(○‿○)",
                                @"(ಠ◡ಠ)",
                                @"(⌐■_■)",
                                @"(˘◡˘)",
                                @"(☼◡☼)",
                                @"(•‿•)",
                                @"(◔ᴗ◔)",
                                @"(◕◡◕)",
        
                                @"(*‿*)",
                                @"(⚈᷁‿᷇⚈᷁)",
                                @"٩(^ᴗ^)۶",
                                @"٩(●˙▿˙●)۶",
                                @"(❁´◡`❁)",
                                @"(❁◠‿‿◠❁)",
                                ],
                           
                          @"Sad":
                              @[ @"(∩︵∩)",
                                 @"(◕︵◕)",
                                 @"(◜௰◝)",
                                 @"(◉︵◉)",
                                 @"( ◢д◣)",
                                 @".·´¯`(>▂<)´¯`·.",
                                 @"( p′︵‵。)",
                                 @"（´＿｀）",
                                 @"(⊙︵⊙)",
                                 @"(ᗒᗣᗕ)՞",
                                 @"(ఠ్ఠ ˓̭ ఠ్ఠ)",
                                 @"(❛︵❛)",
                                 @"（／_＼）",
                                 @"(╯︵╰,)",
                                 ],
                          @"Angry":
                              @[@"(⋋▂⋌)",
                                @"(ò_ó)",
                                @"(◣д◢)",
                                @"(◣_◢)",
                                @"〴⋋_⋌〵",
                                @"（＞д＜）",
                                @"ヽ(#`Д´)ﾉ",
                                @"(≧σ≦)",
                                @"(∘⁼̴⃙̀˘︷˘⁼̴⃙́∘)",
                                @"(｀皿´)",
                                ],
                           @"Love":
                               @[@"( ˘ ³˘)♡",
                                 @"(´ε｀ )♡",
                                 @"(♡ω♡*)",
                                 @"♡´･ᴗ･`♡",
                                 @"♡＾▽＾♡",
                                 @"✿♡‿♡✿",
                                 @"웃+웃=♡",
                                 @"乂♡‿♡乂",
                                 @"(✿ ♡‿♡)",
                                 @"( •ॢ◡-ॢ)-♡",
                                 @"ƪ(♡ﻬ♡)ʃ",
                                 ],
                          @"Worried":
                              @[@"(⊙﹏⊙)",
                                @"(ಠ~ಠ)",
                                @"(ಥ﹏ಥ)",
                                @"(⊙…⊙)",
                                @"ミ●﹏☉ミ",
                                @"(●´⌓`●)",
                                @"ლ(´﹏`ლ)",
                                @"(◍•﹏•)",
                                @"( ᵒ̴̶̷᷄ д ᵒ̴̶̷᷅ )",
                                @"(╯•﹏•╰)",],
                           
                          @"Shocked":
                              @[
                                @"(⊙_◎)",
                                @"(º_o)",
                                @"＼(●o○)ノ",
                                @"(Ꙩ_Ꙩ)",
                                @"(ಠ_ಠ)",
                                @"(۞_۞)",
                                @"(⊙▃⊙)",
                                @"(⊙︿⊙)",
                                @"(ʘ_ʘ)",
                                @"(⊙ω⊙)",
                                @"(◐ o ◑)",
                                @"(⊙０⊙)",
                                @"w(°ｏ°)w",
                                @"(꒪ö꒪)"],
                           
                           
                           @"Annoyed":
                               @[
                                 @"(◉_◉)",
                                @"(ಠ_ಠ)",
                                 @"(ఠ_ఠ)",
                                 @"(ŏﺡó)",
                                 @"(Ò,ó)",
                                 @"(ಠ╭╮ಠ)",
                                 @"(Ծ_Ծ)",
                                 @"(ಥ_ಥ)",
                                 @"(◕_◕)",
                                 @"(☼_☼)",
                                 @"(○_○)",
                                 @"(︶︹︺)",
                                 
                                 ],
                           
                           
                          
                          
                           @"Monkeys":
                               @[@"@(｡･o･)@",
                                 @"@(*^ｪ^)@",
                                 @"@( oóωò)@",
                                 @"@(o･ｪ･o)@",
                                 @"Ϛ⃘๑•͡ .̫•๑꒜",
                                 @"Ⴚტ◕‿◕ტჂ",
                                 @"⊂((δ⊥δ))⊃",
                                 @"⊂((≧⊥≦))⊃",
                                 @"⊂((＞⊥＜))⊃",
                                 @"⊂((υ⊥υ))⊃",
                                 @"⊂((о∂⊥∂о))⊃",
                                 @"@・ꈊ・@",
                                 ],
                          
                        
                           @"Dogs":
                               @[@"(^・(I)・^)",
                                 @"(^・x・^)",
                                 @"U＾ェ＾U",
                                 @"Ｕ^皿^Ｕ",
                                 @"U｡･ｪ･｡U",
                                 @"ヾ(●ω●)ノ",
                                 @"▼o・ェ・o▼",
                                 @"Uo･ｪ･oU",
                                 @"૮( ᵒ̌ૢ௰ᵒ̌ૢ )ა",
                                 @"૮(•⚈͒࿄⚈͒•)ა",
                                 @"(●⌇ຶ ཅ⌇ຶ●)",
                               
                                 ],
                          @"Bears":
                              @[@"“(`(エ)´)ノ",
                                @"⊂(￣(工)￣)⊃",
                                @"ʕ•͡-•ʔ",
                                @"ʕʘ̅͜ʘ̅ʔ",
                                @"ʢٛ•ꇵٛ•ʡ",
                                @"⊂(◎(工)◎)⊃",
                                @"(●￣(ｴ)￣●)",
                                @"(／(ｴ)＼)",
                                @"(^(エ)^)",
                                @"ʕ̡̢̡ʘ̅͟͜͡ʘ̲̅ʔ̢̡̢	",
                                @"ʕʘ‿ʘʔ",
                                @"ʕ •ᴥ•ʔ",
                                ],
                          @"Pigs":
                              @[@"( ´(00)`)",
                                @"(￣(▽▽)￣)",
                                @"(￣(oo)￣)ﾉ",
                                @"ヽ(’(OO)’)ﾉ",
                                @"(；ﾟ(OO)ﾟ)",
                                @"(￣（∞）￣)",
                                @"(｀(●●) ´)",
                                @"ヾ(；ﾟ(OO)ﾟ)ﾉ",
                                @"ヾ(＠＾(∞)＾＠)ノ",
                                @"q(￣(oo)￣)p",
                                @"╰(　´◔　ω　◔ `)╯",],
                          @"Cats":
                              @[@"(=^･ｪ･^=)",
                                @"(=｀ω´=)",
                                @"(=^･^=)",
                               @"(^._.^)ﾉ",
                               @"(^人^)",
                               @"(=^-ω-^=)",
                               @"ヾ(=ﾟ･ﾟ=)ﾉ",
                               @"（ΦωΦ）",
                               @"(^-人-^)",
                               @"=＾● ⋏ ●＾=",
                               @"(*ΦωΦ*)",
                                @"٩(ↀДↀ)۶",
                                @"( ͒ ु- •̫̮ – ू ͒)",
                                ],
                           
                           @"Rabbits":
                               @[@"／(=๏ x ๏=)＼",
                                 @"／(=´x`=)＼",
                                 @"／(=∵=)＼",
                                 @"⌒(｡･.･｡)⌒",
                                 @"⌒(=･ x ･=)⌒",
                                 @"⌒(=๏ x ๏=)⌒",
                                 @"／(=⌒x⌒=)＼",
                                 @"／(^ x ^)＼",
                                 @"／(･ × ･)＼",
                                 @"૮(⋆❛ہ❛⋆)ა",
                                 @"／(≧ x ≦)＼",
                                 @"／(=✪ x ✪=)＼",
                            
                                 ],
                          
                          @"Devils":
                               @[ @"(｀∀´)Ψ",
                                  @"ψ(｀∇´)ψ",
                                  @"(屮゜Д゜)屮",
                                  @"ψ(*｀ー´)ψ",
                                  @"Ψ(｀◇´)Ψ",
                                  @"←～（o｀▽´)oΨ",
                                
                                  ],
                           @"Zombies":
                               @[@"ヘ(>_<ヘ)",
                                 @"(ʘ෴̴͜ʘ)",
                                 @"┗( ●-﹏ ｀｡)づ",
                                 @"ヘ（。□°）ヘ",
                                 @"٩(•̤̀ᵕ•̤́๑)",
                                 @"ƪ(`▿▿▿▿´ƪ)",
                                 @"⁞⁝•ֱ̀␣̍•́⁝⁞",
                                 @" ԅ(◝﹏◜ ԅ)",
                                 @"٩(×̯×)۶",
                                 @"(˼●̙̂ ̟ ̟̎ ̟ ̘●̂˻)",
                                 @"[¬º-°]¬",
                                 @"(〜￣△￣)〜",
                                 @"ヘ(￣ω￣ヘ)",
                                 @"ლ(ಠ_ಠლ)",
                                 @"ヘ(눈_눈)ヘ",
                                 @"(╯‵Д′)╯"],
                           
                           @"Flower Girls":
                               @[
                                   @"(◕‿◕✿)",
                                   @"(◕ᴗ◕✿)",
                                   @"(◡‿◡✿)",
                                   @"(◠‿◠✿)",
                                   @"(◕ω◕✿)",
                                   @"(◕︿◕✿)",
                                   @"(◕ㅅ◕✿)",
                                   @"(◕▿◕✿)",
                                   @"(˶◕‿◕˶✿)",
                                   @"(/‿＼✿)",
                                   @"(〃‿〃✿)",
                                   
                                   @"(◕__◕✿)",
                                    @"(◕д◕✿)",
                                    @"(◕ㅁ◕✿)",
                                   @" (◕_ゝ ◕✿)",
                                   @"(◕‸ ◕✿)",
                                   ],
                
            
                    
                    @"Flipping the Bird":
                        @[@"┌∩┐(◕_◕)┌∩┐",
                          @"┌∩┐(◣_◢)┌∩┐",
                          @"( ︶︿︶)_╭∩╮",
                          @"凸(｀0´)凸",
                          @"ಠ︵ಠ凸",
                          @"(╹◡╹)凸",
                          @"凸(｀⌒´メ)凸",
                          @"┌П┐(►˛◄)",
                          @"凸ಠ益ಠ)凸",
                          @"凸(￣ヘ￣)",],
                        
                   @"Dancing":
         

                       @[@"♪┌(ಠ‿ಠ)┘♪",
                         @"♪┌(ಥ‿ಥ)┘♪",
                         @"♪└(◉‿◉)┐♪",
                         @"♪└(ꙨꙨ)┐♪",
                          @"♪└(○‿○)┐♪",
                          @"♪└(☼‿☼)┐♪",
                          @"♪└(◔‿◔)┐♪",
                         @"♪└(•‿•)┐♪",
                         @"♪└(◕‿◕)┐♪",
                         @"♪└(･‿･)┐♪",
                            ],
                           
                           @"Winking":
                               @[
                                   @"(ʘ‿-)",
                                   @"(Ꙩ⌵-)",
                                   @"(◉‿-)",
                                   @"(○‿-)",
                                @"(◕‿-)",
                                 @"(－ｏ⌒)",
                                 @"（＾＿−）",
                                 @"(･ｪ-)",
                                 @"( ﾟｏ⌒)",
                                 @"（○゜ε＾○）",
                                 @"(o‿∩)",
                                 @"(^_−)☆",
                                 @"ෆ⃛(ᶿ̴͈᷇◟̵◞̵˂͈᷆ ფ",
                                 @"（ゝ。∂）",
                                 @"d(-_^)",
                                 @"~(＾◇^)/"],
                           
                           @"Waving":
                               @[@"( ´ ▽ ` )ﾉ",
                                 @"(/・0・)",
                                 @"＼(°o°；）",
                                 @"( ･ω･)ﾉ",
                                 @"(¬_¬)ﾉ",
                                 @"(*＾▽＾)／",
                                 @"(￣▽￣)ノ",
                                 @"＼(￣O￣)",
                                 @"ヾ(＾-＾)ノ",
                                 @"ヽ(๏∀๏ )ﾉ",
                                 @"(-_-)ノ",
                                 @"＼( ･_･)"],
                           
                           @"High Fiving":
                               @[@"ヽ( ◠～◠)人(◠～◠ )ﾉ",
                                 @"ヽ( ❛口❛)人(❛口❛ )ﾉ",
                                 @"ヽ( ⊙ڡ⊙)人(⊙ڡ⊙ )ﾉ",
                                 @"ヽ( ★Д★)人(★Д★ )ﾉ",
                                 @"ヽ( ●╭╮●)人(●╭╮● )ﾉ",
                                 @"ヽ( ^･‿･^)人(^･‿･^ )ﾉ",
                                 @"ヽ( O▃O)人(O▃O )ﾉ",
                                 @"ヽ( ╯∀╰)人(╯∀╰ )ﾉ",
                                 @"ヽ( ✖_✖)人(✖_✖ )ﾉ",
                                 @"ヽ( ❛﹏❛)人(❛﹏❛ )ﾉ",
                                ],

                           
                    @"Whatever":
                    @[
                        @" ¯\\_(ツ)_/¯",
                        @"＼(〇_ｏ)／",
                        @"¯\(°_°)/¯",
                        @"ヽ(。_°)ノ",
                        @"ヽ(‘ー`)ノ",
                        @"ヽ(ー_ー )ノ",
                        @"ヽ( ´¬`)ノ",
                        @"╮(─▽─)╭",
                        @"ヾ(´A｀)ノﾟ",
                        @"ƪ(•̃͡ε•̃͡)∫ʃ",
                        @"ƪ(Ơ̴̴̴̴̴̴͡.̮Ơ̴̴͡)ʃ",
                        @"ƪ(‾ε‾“)ʃ",
                        @"＼(;´□｀)/",
                        @"ヾ(*´ー`)ノ",
                        @"┐(‘～`；)┌",
                        @"（＾～＾）",
            
                        
                        ],
        
                    
                @"Flexing":
                    @[@"ᕙ(⇀‸↼‶)ᕗ",
                      @"ᕦ(ò_óˇ)ᕤ",
                      @"ᕕ( ᐛ )ᕗ",
                      @"(ง •̀ゝ•́)ง",
                      @"ᕦ❍ᴗ❍ᕤ",
                      @"ᕦ◉▿◉ᕤ",
                      @"ᕙ(＠▽＠)ᕗ",
                      @"ᕙ(>Д< ᕙ)",
                      @"ᕦ(⌒⊆⌒ ᕦ)",
                      @"ᕙ(♥‿♥ ᕙ )"
                    ],
                
                    
                @"Table Flipping":
                @[
                    @"(┛◉Д◉)┛彡┻━┻",
                    @"(ノಠ益ಠ)ノ彡┻━┻",
                    @"(╯°□°）╯︵ ┻━┻",
                    @"┻━┻ ︵ヽ(`Д´)ﾉ︵ ┻━┻",
                    @"┬──┬◡ﾉ(° -°ﾉ)",
                    @"(╯°Д°）╯︵/(.□ . \\)",
                    @"(╯°□°)╯︵ ʞooqǝɔɐℲ",
                    @"(∿°○°)∿ ︵ ǝʌol",
                    @"ノ┬─┬ノ ︵ ( \\o°o)\\",
                    @"(ノಠ ∩ಠ)ノ彡( \\o°o)\\",
                    @"(/¯◡ ‿ ◡)/¯ ~ ┻━┻" ],
                  
                @"Hugging":
                    @[@"ლ(́◉◞౪◟◉‵ლ)",
                      @"ლ(╹◡╹ლ)",
                      @"(っ˘̩╭╮˘̩)っ",
                      @"ლ(´ڡ`ლ)",
                      @"⊂(◉‿◉)つ",
                      @"(づ￣ ³￣)づ",
                      @"⊂((・▽・))⊃",
                      @"(づ｡◕‿‿◕｡)づ",
                      @"d=(´▽｀)=b"],
                      
                    @"Kissing":
                      @[@"(╯3╰)",
                        @"( ˘ ³˘)",
                        @"(ΦзΦ)",
                        @"( ु ॕ ӟ ॕ)ु",
                        @"（*＾3＾）",
                        @"(○´3｀)ﾉ",
                        @"ヽ(*´з｀*)ﾉ",
                        @"σ(≧ε≦ｏ)",
                        @"ヾ(❛ε❛“)ʃ",
                        @"|°з°|",
                        ],
                        
                           
                    
                    
                @"Trolls":
                    @[@"ヽ༼ಠ益ಠ༽ﾉ",
                      @"༼✷ɷ✷༽",
                      @"༼ԾɷԾ༽",
                      @"༼´༎ຶ ༎ຶ ༽",
                      @"༼ ͒ ̶ ͒༽",
                      @"༼•͟ ͜ •༽",
                      @"༼இɷஇ༽",
                      @"༼≖ɷ≖༽",
                      @"ヽ༼ຈل͜ຈ༽ﾉ",
                      @"༼•̃͡ ɷ•̃͡༽",
                      @"༼•̫͡•༽",
                      @"༼༎ຶ෴༎ຶ༽",
                      @"༼ ͒ ͓ ͒༽",
                      @"ヽ༼ຈل͜ຈ༽ﾉ",],
                
                    @"Phrases":
                        @[@"୨୧ᕼᗩᑭᑭY ᗷIᖇTᕼᗞᗩY୨୧",
                          @"ℋᵅᵖᵖᵞ ℬⁱʳᵗᑋᵈᵃᵞ",
                          @"ℋ੨ppყ ᙖ ౹̊ণ৳hძ੨ყ",
                          @"Ƭʜᵃℕҡ ყօϋ",
                          @"ᎢℋᎪɳᏦ ᎩӫᏌ",
                          @"৳৸ᵃᵑᵏ Ꮍ৹੫",
                          @"[τ̲̅н̲̅a̲̅и̲̅κ̲̅ ч̲̅o̲̅u̲̅]",
                          @"тнайк чоц!",
                          @"ᏩɵɵᎴ ɳɩɠɧt",
                          @"♡ Good Night ♡",
                          @"ɴⁱᵍʰᵗᵎ ɴⁱᵍʰᵗᵎ",
                          @"♬ ɱUꑄյ͛ʗ ♬",
                          @"ɢ∞פ ʍօ૨ɴɪɴɢ",
                          @"LﾛVЁ",
                          @"⋆ᗰદ૨૨ʏ⋆ᘓમ૨ıડτന੨ડ⋆",
                          @"～ΜᎧrRγ сняᎥᎦτмᏜs*～",
                          @"нарру　йёω　уёая!",
                          @"ＨＡＰＰＹ ＮＥＷ ＹＥＡＲ!",
                          @"fෆr yෆu",
                           @"Lᵒᵛᵉᵧₒᵤ ♡",
                          @"꒒ ০ ⌵ ୧ ♡",
                          @"LﾛVЁ",
                          @"˪৹⌵ೕ",
                          @"༝࿆༚࿆༝࿆༚࿆",
                          @"Ɛn꒻öႸ",
                          @"ɢ∞פ⋆ᖙᵒᵝ",
                          @"ᙚᵐⁱᒻᵉ ¨̮",
                          @"ⓗⓔⓛⓛⓞ",
                          @"Ⓗⓐⓟⓟⓨ",
                          @"Ⓦⓗⓨ？",
                          @"Ⓦⓗⓐⓣ？",
                          @"ⒽⓤⒼ!",
                          
                          ],
                
                @"Misc":
                    @[@"(´◔౪◔)✂╰⋃╯",
                      @"╰⋃╯ლ(´ڡ`ლ)",
                      @"( ◜◡＾)っ✂╰⋃╯",
                      
                      ]
                
                    };
    
    
    
    //Add favorites
    self.emojis = [lib mutableCopy];
    //[self.emojis setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"Favorites"];
    //[self.emojis setObject:[NSMutableArray arrayWithCapacity:0] forKey:@"History"];
    
    
    
    
    
    
    

}





@end

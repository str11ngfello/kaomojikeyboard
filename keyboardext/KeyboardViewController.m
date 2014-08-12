//
//  KeyboardViewController.m
//  keyboardext
//
//  Created by Lowell Duke on 8/10/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "KeyboardViewController.h"
#import "KeyboardView.h"



@interface KeyboardViewController ()
@property (nonatomic, strong)KeyboardView* keyboardView;
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) NSMutableArray* categoryViews;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (nonatomic, strong) NSMutableArray* emojis;
@property (nonatomic, assign) int sizeOfLastEntry;

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

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sizeOfLastEntry = 5 ;
    
    self.keyboardView = [[[NSBundle mainBundle] loadNibNamed:@"KeyboardView" owner:self options:nil] objectAtIndex:0];
    self.keyboardView.frame = CGRectMake(0, 0, 320, 216);
    [self.keyboardView setNeedsDisplay];
    self.keyboardView.keyboardViewController = self;
    
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 158)];
    [self.keyboardView addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(320 * 4, 158);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;

    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(160-75, 216-40, 150, 40);
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    [self.pageControl setAutoresizingMask: UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.keyboardView addSubview:self.pageControl];
    
    
    [self loadEmojis];
   
    self.categoryViews = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 0;i < 4;++i)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        ADLivelyCollectionView* colview = [[ADLivelyCollectionView alloc] initWithFrame:CGRectMake(i*320, 0, 320, 158) collectionViewLayout:layout];
        
        [colview setDataSource:self];
        [colview setDelegate:self];
       
        [colview registerNib:[UINib nibWithNibName:@"LDCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
        colview.initialCellTransformBlock = ADLivelyTransformHelix;
        
        [self.categoryViews addObject:colview];
        [self.scrollView addSubview:colview];
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
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, appExtensionHeight - 58);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4, appExtensionHeight - 58);
        self.keyboardView.frame = CGRectMake(0, 0, self.view.frame.size.width, appExtensionHeight);
        
    } else {*/
        self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, appExtensionHeight - 58);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 4, appExtensionHeight - 58);
        self.keyboardView.frame = CGRectMake(0, 0, self.view.frame.size.width, appExtensionHeight);
    //}

    for (int i = 0;i < 4;++i)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        ((ADLivelyCollectionView*)[self.categoryViews objectAtIndex:i]).frame = frame;
        [((ADLivelyCollectionView*)[self.categoryViews objectAtIndex:i]) reloadData];
    }

    
    [self.keyboardView bringSubviewToFront:self.keyboardView.nextKeyboardButton];
    [self.keyboardView bringSubviewToFront:self.keyboardView.clearButton];
    
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



-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.emojis.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"Cell";
    
    LDCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell.backgroundView) {
        UIView * backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView = backgroundView;
        
    }
    
    cell.textLabel.text = [self.emojis objectAtIndex:indexPath.row];
    
    /*UIColor * altBackgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
     cell.backgroundView.backgroundColor = [indexPath row] % 2 == 0 ? [UIColor whiteColor] : altBackgroundColor;
     */
    //cell.textLabel.backgroundColor = cell.backgroundView.backgroundColor;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [((LDCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath]) selectionEffect];
    [self.textDocumentProxy insertText:[self.emojis objectAtIndex:indexPath.row]];
    self.sizeOfLastEntry = [[self.emojis objectAtIndex:indexPath.row] length];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.scrollView.frame.size.width/3)-1, 35);
}

-(void)clear
{
    for (int i = 0;i < self.sizeOfLastEntry;++i)
        [self.textDocumentProxy deleteBackward];

}
-(void)loadEmojis
{
    self.emojis = @[
                    @"(⊙_◎)",
                    @"(ʘ‿ʘ)",
                    @"(ʘ_ʘ)",
                    @"(⋋▂⋌)",
                    @"(⌐■_■)",
                    @"(ಠ‾ಠ﻿)",
                    @"(ಠ‿ʘ)",
                    @"(◣д◢)",
                    @"(∩▂∩)",
                    @"(◕︵◕)",
                    @"(¬‿¬)",
                    @"(¬▂¬)",
                    @"Ꙩ⌵Ꙩ",
                    @"Ꙩ_Ꙩ",
                    @"ꙩ_ꙩ",
                    @"Ꙫ_Ꙫ",
                    @"ꙫ_ꙫ",
                    @"ಠ_ಠ",
                    @"ಠ_๏",
                    @"ಠ~ಠ",
                    @"ఠ_ఠ",
                    @"రృర",
                    @"ಠ¿ಠ",
                    @"ಠ⌣ಠ",
                    @"ಠ╭╮ಠ",
                    @"ಠ▃ಠ",
                    @"ಠ◡ಠ"];
                    

}





@end

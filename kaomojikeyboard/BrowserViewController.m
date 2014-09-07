//
//  BrowserViewController.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 9/6/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "BrowserViewController.h"
#import "ProfileCard.h"

float lerpf(float a, float b, float t)
{
    return a + (b - a) * t;
}

@interface BrowserViewController ()
@property (nonatomic, strong) NSMutableArray *people;
@property (strong,nonatomic) NSMutableArray* profileCards;

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peopleFetchCompleted:)
                                                 name:kPeopleRequestNotification
                                               object:nil];
    
    //Kick off a call to load people
    [self fetchPeople:kNumPeopleEachFetchRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    //NSLog(@"You couldn't decide on ");
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    
    
    if (direction == MDCSwipeDirectionLeft) {
    }
    else {
    }
    
    
    for (int i = 0;i < kCardStackSize-1;++i)
        [self.cardViews replaceObjectAtIndex:i withObject:[self.cardViews objectAtIndex:i+1]];
    
    ProfileCard *newCard = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.cardViews insertObject:newCard atIndex:kCardStackSize-1];
    newCard.alpha = 0;
    [self.view insertSubview:newCard belowSubview:[self.cardViews objectAtIndex:kCardStackSize-2]];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         newCard.alpha = .6f;
                     } completion:nil];
}

- (ProfileCard *)popPersonViewWithFrame:(CGRect)frame {
    
    //Create new profile card with next person.  Fetching process runs concurrently
    @synchronized(self)
    {
        if ([self.people count] == 0)
            return nil;
        
        MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
        options.delegate = self;
        options.threshold = 100.0f;
        options.likedText = @"";
        options.nopeText = @"";
        options.onPan = ^(MDCPanState *state){
            
            for (int i = 1;i < kCardStackSize;++i)
            {
                CGAffineTransform t = CGAffineTransformIdentity;
                
                float scaleFactor = lerpf((1-(i * kCardScaleStep)),1 - ((i-1)*kCardScaleStep),state.thresholdRatio);
                t = CGAffineTransformScale(t,scaleFactor,scaleFactor);
                
                t = CGAffineTransformTranslate(t, 0,lerpf(((i-1)*kCardTransStep),(kCardTransStep*i),(1-state.thresholdRatio)));
                
                ProfileCard* card = [self.cardViews objectAtIndex:i];
                card.transform = t;
                
                float alphaFactor = lerpf((1-(i * kCardAlphaStep)),1 - ((i-1)*kCardAlphaStep),state.thresholdRatio);
                card.alpha = alphaFactor;
            }
            
            ((ProfileCard*)[self.cardViews objectAtIndex:0]).alpha = .7+(.3*(1 - state.thresholdRatio));
        };
        
        ProfileCard *personView = [[ProfileCard alloc] initWithFrame:frame person:[self.people objectAtIndex:0] options:options];
        [self.people removeObjectAtIndex:0];
        
        CGAffineTransform t = CGAffineTransformIdentity;
        float scaleFactor = 1 - (kCardScaleStep*(kCardStackSize-1));
        t = CGAffineTransformScale(t,scaleFactor,scaleFactor);
        
        t = CGAffineTransformTranslate(t, 0, kCardTransStep*(kCardStackSize-1));
        personView.transform = t;
        
        personView.alpha = 1 - (kCardAlphaStep * (kCardStackSize-1));
        
        //Trigger another fetch of people before we run out of profile cards
        if ([self.people count] < 10)
            [self fetchPeople:kNumPeopleEachFetchRequest];
        return personView;
    }
}


- (CGRect)frontCardViewFrame {
    
    return CGRectMake(([[UIScreen mainScreen] bounds].size.width-kCardSize)/2,
                      140,
                      kCardSize,
                      kCardSize);
}

- (CGRect)backCardViewFrame {
    return CGRectMake(([[UIScreen mainScreen] bounds].size.width-kCardSize)/2,
                      140,
                      kCardSize,
                      kCardSize);
}


- (void)fetchPeople:(int)numPeopleToFetch {
    
#ifdef USE_LIVE_DATA
    //Do we have a fetch in process already?
    if (self.fetchInProgress)
        return;
    
    //Asynchronously fetch more people to browse
    self.fetchInProgress = true;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kServerEndPointURL@"people/%d",numPeopleToFetch]]];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (data != nil)
        {
            NSArray *peopleJSON = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:NULL];
            //Do we get some people back?
            if ([peopleJSON count] > 0)
            {
                //Build new Person array
                NSMutableArray* people = [[NSMutableArray alloc] initWithCapacity:[peopleJSON count]];
                for (NSDictionary* d in peopleJSON)
                {
                    [people addObject:[[Person alloc] initWithFirstName:[d objectForKey:@"name"]
                                                               lastName:[d objectForKey:@"name"]
                                                                  image:[UIImage imageNamed:@"user-profile.png"]
                                                                    age:30
                                                                 isMale:[[d objectForKey:@"gender"] isEqualToString:@"male"]?true:false
                                                              interests:[d objectForKey:@"interests"]]];
                    
                    
                    //NSLog(@"%@",[d objectForKey:@"name"]);
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //I'd like to control access to this array even though it's not used
                    //from multiple threads just yet.
                    @synchronized(self)
                    {
                        //If no people exist, assign. Otherwise, tack the new ones onto the end
                        //of the current browse list
                        if (!self.people)
                            self.people = people;
                        else
                            [self.people addObjectsFromArray:people];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPeopleRequestNotification object:nil];
                    self.fetchInProgress = false;
                    
                });
            }
        }
        
    });
#else
    
    //Sample data until web service endpoint is serving
    self.people = [@[[[Person alloc] initWithFirstName:@"Paul" lastName:@"Bedell" image:[UIImage imageNamed:@"user-profile.png"] age:31 isMale:true interests:@[@{@"name":@"3D Printing"},@{@"name":@"Amateur Radio"},@{@"name":@"Baton Twirling"},@{@"name":@"Cleaning"},@{@"name":@"Computer Programming"},@{@"name":@"Cooking"}]],
                     [[Person alloc] initWithFirstName:@"Darren" lastName:@"Turetzky" image:[UIImage imageNamed:@"user-profile.png"] age:32 isMale:true interests:@[@{@"name":@"3D Printing"},@{@"name":@"Amateur Radio"},@{@"name":@"Baton Twirling"},@{@"name":@"Cleaning"},@{@"name":@"Computer Programming"},@{@"name":@"Cooking"}]],
                     [[Person alloc] initWithFirstName:@"Ryan" lastName:@"Engle" image:[UIImage imageNamed:@"user-profile.png"] age:33 isMale:true interests:@[@{@"name":@"3D Printing"},@{@"name":@"Amateur Radio"},@{@"name":@"Baton Twirling"},@{@"name":@"Cleaning"},@{@"name":@"Computer Programming"},@{@"name":@"Cooking"}]],
                     [[Person alloc] initWithFirstName:@"Graham" lastName:@"Perks" image:[UIImage imageNamed:@"user-profile.png"] age:34 isMale:true interests:@[@{@"name":@"3D Printing"},@{@"name":@"Amateur Radio"},@{@"name":@"Baton Twirling"},@{@"name":@"Cleaning"},@{@"name":@"Computer Programming"},@{@"name":@"Cooking"}]],
                     [[Person alloc] initWithFirstName:@"Sean" lastName:@"Dellis" image:[UIImage imageNamed:@"user-profile.png"] age:35 isMale:true interests:@[@{@"name":@"3D Printing"},@{@"name":@"Amateur Radio"},@{@"name":@"Baton Twirling"},@{@"name":@"Cleaning"},@{@"name":@"Computer Programming"},@{@"name":@"Cooking"}]],
                     [[Person alloc] initWithFirstName:@"Ryan" lastName:@"Kennedy" image:[UIImage imageNamed:@"user-profile.png"] age:36 isMale:true interests:@[@{@"name":@"3D Printing"},@{@"name":@"Amateur Radio"},@{@"name":@"Baton Twirling"},@{@"name":@"Cleaning"},@{@"name":@"Computer Programming"},@{@"name":@"Cooking"}]],
                     [[Person alloc] initWithFirstName:@"Steve" lastName:@"Baker" image:[UIImage imageNamed:@"user-profile.png"] age:37 isMale:true interests:@[@{@"name":@"3D Printing"},@{@"name":@"Amateur Radio"},@{@"name":@"Baton Twirling"},@{@"name":@"Cleaning"},@{@"name":@"Computer Programming"},@{@"name":@"Cooking"}]],
                     [[Person alloc] initWithFirstName:@"Erik" lastName:@"Potter" image:[UIImage imageNamed:@"user-profile.png"] age:38 isMale:true interests:@[@{@"name":@"3D Printing"},@{@"name":@"Amateur Radio"},@{@"name":@"Baton Twirling"},@{@"name":@"Cleaning"},@{@"name":@"Computer Programming"},@{@"name":@"Cooking"}]],
                     [[Person alloc] initWithFirstName:@"Lynn" lastName:@"Duke" image:[UIImage imageNamed:@"user-profile.png"] age:39 isMale:true interests:@[@{@"name":@"3D Printing"},@{@"name":@"Amateur Radio"},@{@"name":@"Baton Twirling"},@{@"name":@"Cleaning"},@{@"name":@"Computer Programming"},@{@"name":@"Cooking"}]],
                     [[Person alloc] initWithFirstName:@"Kyle" lastName:@"Turetzky" image:[UIImage imageNamed:@"user-profile.png"] age:40 isMale:true interests:@[@{@"name":@"3D Printing"},@{@"name":@"Amateur Radio"},@{@"name":@"Baton Twirling"},@{@"name":@"Cleaning"},@{@"name":@"Computer Programming"},@{@"name":@"Cooking"}]],
                     [[Person alloc] initWithFirstName:@"Alton" lastName:@"Chaney" image:[UIImage imageNamed:@"user-profile.png"] age:41 isMale:true interests:@[@{@"name":@"3D Printing"},@{@"name":@"Amateur Radio"},@{@"name":@"Baton Twirling"},@{@"name":@"Cleaning"},@{@"name":@"Computer Programming"},@{@"name":@"Cooking"}]],
                     [[Person alloc] initWithFirstName:@"Luis" lastName:@"Delgado-Eberhardt" image:[UIImage imageNamed:@"user-profile.png"] age:42 isMale:true interests:@[@{@"name":@"3D Printing"},@{@"name":@"Amateur Radio"},@{@"name":@"Baton Twirling"},@{@"name":@"Cleaning"},@{@"name":@"Computer Programming"},@{@"name":@"Cooking"}]],
                     ] mutableCopy];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPeopleRequestNotification object:nil];
#endif
}

- (void) peopleFetchCompleted:(NSNotification*) notification
{
    NSLog(@"New People Fetched");
    
    if (self.cardViews == nil)
    {
        self.cardViews = [[NSMutableArray alloc] init];
        for (int i = 0;i < kCardStackSize;++i)
        {
            ProfileCard* card = [self popPersonViewWithFrame:[self frontCardViewFrame]];
            
            CGAffineTransform t = CGAffineTransformIdentity;
            float scaleFactor = 1 - (kCardScaleStep*i);
            t = CGAffineTransformScale(t,scaleFactor,scaleFactor);
            t = CGAffineTransformTranslate(t, 0, i * kCardTransStep);
            
            card.transform = t;
            card.alpha = 1 - (kCardAlphaStep * i);
            [self.cardViews addObject:card];
        }
        
        //Insert cards into view
        ProfileCard *lastCard = nil;
        for (ProfileCard* card in self.cardViews)
        {
            if (!lastCard)
                [self.view addSubview:card];
            else
                [self.view insertSubview:card belowSubview:lastCard];
            
            lastCard = card;
        }
        
        /*POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        anim.fromValue = @(100);
        anim.toValue = @(290);
        anim.springBounciness = 14.6;
        anim.springSpeed = 3.3;
        */
        
        for (ProfileCard* card in self.cardViews)
        {
            [UIView animateWithDuration:1
                                  delay:0
                 usingSpringWithDamping:.2
                  initialSpringVelocity:.1
                                options:0
                             animations:^{
                                 card.center = CGPointMake(card.center.x,290);
                                } completion:nil];
        }
        
    }
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





@end

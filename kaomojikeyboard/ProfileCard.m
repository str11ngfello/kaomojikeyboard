//
//  ProfileCard.m
//  Plutonic
//
//  Created by Lowell Duke on 8/13/14.
//  Copyright (c) 2014 Binocular All rights reserved.
//

#import "ProfileCard.h"
#import "BrowserViewController.h"



@implementation ProfileCard


- (id)initWithFrame:(CGRect)frame person:(Person*)person options:(MDCSwipeToChooseViewOptions *)options;
{
    if ((self = [super initWithFrame:frame options:options]))
    {
        self.person = person;

        UILabel* l = [[UILabel alloc] initWithFrame:frame];
        l.text = person.lastName;
        [self addSubview:l];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(2, 3);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.2;
        
        
    }
    
    return self;
}


@end

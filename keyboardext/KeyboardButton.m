//
//  KeyboardButton.m
//  kaomojikeyboard
//
//  Created by Lowell Duke on 8/28/14.
//  Copyright (c) 2014 Seventh Night Studios. All rights reserved.
//

#import "KeyboardButton.h"

@implementation KeyboardButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) awakeFromNib
{
    self.layer.cornerRadius = 5; // this value vary as per your desire
    self.clipsToBounds = YES;
}


@end

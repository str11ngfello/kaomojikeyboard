//
//  Person.m
//  Plutonic
//
//  Created by Lowell Duke on 8/20/14.
//  Copyright (c) 2014 Binocular All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString*)lastName
                            image:(UIImage *)image
                              age:(NSUInteger)age
                           isMale:(bool)isMale
                        interests:(NSArray*)interests
{
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = firstName;
        self.image = image;
        self.age = age;
        self.isMale = isMale;
        self.interests = interests;
    }
    return self;
}

@end





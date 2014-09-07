//
//  Person.h
//  Plutonic
//
//  Created by Lowell Duke on 8/20/14.
//  Copyright (c) 2014 Binocular All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, assign) bool isMale;
@property (nonatomic, strong) NSArray* interests;


- (instancetype)initWithFirstName:(NSString *)firstName
                         lastName:(NSString*)lastName
                            image:(UIImage *)image
                              age:(NSUInteger)age
                           isMale:(bool)isMale
                        interests:(NSArray*)interests;

@end


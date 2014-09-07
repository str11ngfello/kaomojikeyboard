//
//  Z4BottomButton.m
//  AppZilla4
//
//  Created by Lowell Duke on 11/14/13.
//
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib
{
    //UIImage* pushedImage = [self imageForState:UIControlStateNormal];
    //self.showsTouchWhenHighlighted = false;
   // [self setImage:[self tintedImageUsingColor:[UIColor colorWithRed:0 green:.682 blue:.937 alpha:1] orgImage:pushedImage] forState:UIControlStateHighlighted];
    self.layer.cornerRadius = 5;
    
}

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor orgImage:(UIImage*)orgImage
{
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContextWithOptions(orgImage.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [tintColor setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, orgImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGRect rect = CGRectMake(0, 0, orgImage.size.width, orgImage.size.height);
    CGContextDrawImage(context, rect, orgImage.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, orgImage.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  LDCollectionViewCell.m
//  LivelyDemo
//
//  Created by Patrick Nollet on 07/03/2014.
//
//

#import "LDCollectionViewCell.h"

@implementation LDCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)selectionEffect
{
  /*  UILabel* tempLabel = [[UILabel alloc] initWithFrame:_textLabel.frame];
    tempLabel.text = _textLabel.text;
    [self addSubview:tempLabel];
    
    [UIView animateWithDuration:.1
                          delay:0
                        options:UIViewAnimationCurveLinear
                     animations:^{
                         tempLabel.transform = CGAffineTransformMakeScale(1.5,1.5);
                     }
                     completion:^(BOOL finished) {
                         [tempLabel removeFromSuperview];
                     }];*/
    
}

- (void)dealloc {
    [_textLabel release];
    [super dealloc];
}
@end

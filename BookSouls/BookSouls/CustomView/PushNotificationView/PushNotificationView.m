//
//  PushNotificationView.m
//  BookSouls
//
//  Created by Dong Vo on 11/27/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "PushNotificationView.h"

@interface PushNotificationView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;

@end

@implementation PushNotificationView

#pragma mark - Init
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if(self){
        
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
         [self setup];
    }
    
    return self;
}

#pragma mark - Method

- (void)setup{
    
    self.view = [[NSBundle mainBundle] loadNibNamed:@"PushNotificationView" owner:self options:nil].firstObject;
    
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    
    [self showMessage];
}

-(void)showMessage{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        
        [self performSelector:@selector(closeMessage) withObject:nil afterDelay:8.0f];
    
}

-(void)closeMessage{
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = CGRectMake(0, - (CGRectGetMaxY(self.frame)), self.frame.size.width, self.frame.size.height);
        [UIView commitAnimations];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(closeMessage) object:nil];
}
@end

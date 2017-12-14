//
//  PushNotificationView.m
//  BookSouls
//
//  Created by Dong Vo on 11/27/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "PushNotificationView.h"
#import "Notify.h"
#import "UIColor+HexString.h"
#import "OrderViewController.h"
#import "ContentOrderViewSellingController.h"
#import "ContentOrderBuyingViewController.h"

@interface PushNotificationView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (nonatomic, strong) Notify *notify;

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

- (id)initWithFrame:(CGRect)frame notify:(Notify *)notify{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.notify = notify;
        [self setup];
    }
    
    return self;
}

#pragma mark - Method

- (IBAction)touchNoti:(id)sender {
    
    Appdelegate_BookSouls.notiType = self.notify.type;
    
    if([[SlideMenuViewController sharedInstance] indexSelectedCurr] != Item_Order){
        
        [[SlideMenuViewController sharedInstance] selecItemCurr:Item_Order];
    }
    else{
        
        OrderViewController *vcOrder = [[[[SlideMenuViewController sharedInstance] vcNavigation] viewControllers] firstObject];
        
        if(Appdelegate_BookSouls.notiType){
            
            NSLog(@"%@",Appdelegate_BookSouls.notiType);
            
            if([Appdelegate_BookSouls.notiType isEqualToString:@"BUYER_RECIVED_ORDER"]){
                
                [vcOrder touchBookSelling:nil];
                [vcOrder.vcSelling touchComment:nil];
            }
            else if([Appdelegate_BookSouls.notiType isEqualToString:@"BUYER_CANCEL_ORDER"]){
                
                [vcOrder touchBookSelling:nil];
                [vcOrder.vcSelling touchBtnCancel:nil];
            }
            else if ([Appdelegate_BookSouls.notiType isEqualToString:@"SELLER_CANCEL_ORDER"]){
                
                [vcOrder touchBtnBookEnd:nil];
                [vcOrder.vcBuying touchBtnCancel:nil];
            }
            else if([Appdelegate_BookSouls.notiType isEqualToString:@"SELLER_SUCCESS_ORER"]){
                
                [vcOrder touchBtnBookEnd:nil];
                [vcOrder.vcBuying touchBtnSelled:nil];
            }
            else if ([Appdelegate_BookSouls.notiType isEqualToString:@"SELLER_ACCEPT_ORDER"]){
                
                [vcOrder touchBtnBookEnd:nil];
                [vcOrder.vcBuying touchBtnShping:nil];
            }
            else if([Appdelegate_BookSouls.notiType isEqualToString:@"SELLER_RATING_BUYER"]){
                
                [vcOrder touchBtnBookEnd:nil];
                [vcOrder.vcBuying touchBtnSelled:nil];
            }
            else if([Appdelegate_BookSouls.notiType isEqualToString:@"USER_ORDER_BOOK"]){
                
                [vcOrder touchBookSelling:nil];
                [vcOrder.vcSelling touchBtnWaitingSell:nil];
            }
            
            Appdelegate_BookSouls.notiType = nil;
        }
        
    }
    
    [self closeMessage];
}
- (void)setup{
    
    self.view = [[NSBundle mainBundle] loadNibNamed:@"PushNotificationView" owner:self options:nil].firstObject;
    
    self.view.frame = self.bounds;
    [self addSubview:self.view];
    
    if(self.notify){
        
        self.lblTitle.text = self.notify.title;
        self.lblContent.text = self.notify.content;
        
        if([self.notify.type isEqualToString:@"BUYER_CANCEL_ORDER"]){
            
            [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F44E4E"]];
        }
        else if([self.notify.type isEqualToString:@"SELLER_CANCEL_ORDER"]){
            
            [self.view setBackgroundColor:[UIColor colorWithHexString:@"#F44E4E"]];
        }
        else if ([self.notify.type isEqualToString:@"SELLER_SUCCESS_ORER"]){
            
            [self.view setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        }
        else if ([self.notify.type isEqualToString:@"BUYER_RECIVED_ORDER"]){
            
            [self.view setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        }
        else if ([self.notify.type isEqualToString:@"USER_ORDER_BOOK"]){
            
            [self.view setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        }
    }
    
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

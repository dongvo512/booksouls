//
//  OrderViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/27/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "OrderViewController.h"
#import "UIColor+HexString.h"
#import "ContentOrderViewSellingController.h"
#import "ContentOrderBuyingViewController.h"

typedef NS_ENUM(NSInteger, TypeBook) {
    
    TypeBookSell,
    TypeBookBuy
};

@interface OrderViewController (){
    
    NSInteger indexSelected;
    
    NSInteger indexPage;
    
    BOOL isFullData;
}

@property (weak, nonatomic) IBOutlet UIView *viewTab;
@property (weak, nonatomic) IBOutlet UIView *viewSubSelling;
@property (weak, nonatomic) IBOutlet UIView *viewSubBookEnd;
@property (weak, nonatomic) IBOutlet UIButton *btnSelling;
@property (weak, nonatomic) IBOutlet UIButton *btnBookEnd;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewMaster;


@property (nonatomic, strong) NSMutableArray *arrData;
@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configUI];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(moveWithNotiType) withObject:nil afterDelay:0.3];
}

- (void)moveWithNotiType{
    
    if(Appdelegate_BookSouls.notiType){
        
        NSLog(@"%@",Appdelegate_BookSouls.notiType);
        
        if([Appdelegate_BookSouls.notiType isEqualToString:@"BUYER_RECIVED_ORDER"]){
            
            [self touchBookSelling:nil];
            [self.vcSelling touchComment:nil];
        }
        else if([Appdelegate_BookSouls.notiType isEqualToString:@"BUYER_CANCEL_ORDER"]){
            
            [self touchBookSelling:nil];
            [self.vcSelling touchBtnCancel:nil];
        }
        else if ([Appdelegate_BookSouls.notiType isEqualToString:@"SELLER_CANCEL_ORDER"]){
            
            [self touchBtnBookEnd:nil];
            [self.vcBuying touchBtnCancel:nil];
        }
        else if([Appdelegate_BookSouls.notiType isEqualToString:@"SELLER_SUCCESS_ORER"]){
            
            [self touchBtnBookEnd:nil];
            [self.vcBuying touchBtnSelled:nil];
        }
        else if ([Appdelegate_BookSouls.notiType isEqualToString:@"SELLER_ACCEPT_ORDER"]){
            
            [self touchBtnBookEnd:nil];
            [self.vcBuying touchBtnShping:nil];
        }
        else if([Appdelegate_BookSouls.notiType isEqualToString:@"SELLER_RATING_BUYER"]){
            
            [self touchBtnBookEnd:nil];
            [self.vcBuying touchBtnSelled:nil];
        }
        else if([Appdelegate_BookSouls.notiType isEqualToString:@"USER_ORDER_BOOK"]){
            
            [self touchBookSelling:nil];
            [self.vcSelling touchBtnWaitingSell:nil];
        }
        
        Appdelegate_BookSouls.notiType = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (IBAction)touchBtnMenu:(id)sender {
    
    [[SlideMenuViewController sharedInstance] toggle];
}

- (IBAction)touchBookSelling:(id)sender {
    
    if(indexSelected != TypeBookSell){
        
        indexSelected = TypeBookSell;
        indexPage = 1;
        isFullData = NO;
        
        [self.btnSelling setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.viewSubSelling setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.btnSelling setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnSelling.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        
        [self.btnBookEnd setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
        [self.viewSubBookEnd setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
        [self.btnBookEnd setTitleColor:[UIColor colorWithHexString:@"#1C2D51"] forState:UIControlStateNormal];
        [self.btnBookEnd.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14.0]];
        
        CGPoint scrollPoint = CGPointMake(0, 0);
        [self.scrollViewMaster setContentOffset:scrollPoint animated:YES];
        
    }
    
}
- (IBAction)touchBtnBookEnd:(id)sender {
  
    if(indexSelected != TypeBookBuy){
        
        indexSelected = TypeBookBuy;
        indexPage = 1;
        isFullData = NO;
        
        [self.btnBookEnd setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.viewSubBookEnd setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.btnBookEnd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnBookEnd.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        
        [self.btnSelling setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
        [self.viewSubSelling setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
        [self.btnSelling setTitleColor:[UIColor colorWithHexString:@"#1C2D51"] forState:UIControlStateNormal];
        [self.btnSelling.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14.0]];
        
        CGPoint scrollPoint = CGPointMake(self.scrollViewMaster.frame.size.width, 0);
         [self.scrollViewMaster setContentOffset:scrollPoint animated:YES];
    }
    
}

#pragma mark - Method
- (void)configUI{
    
    self.viewTab.layer.cornerRadius = 15.0f;
    self.viewTab.layer.borderWidth = 1.0f;
    self.viewTab.layer.borderColor = [UIColor colorWithHexString:@"#D3D7E0"].CGColor;
    
    indexSelected = TypeBookSell;
    
    
    // add Content
    
    // 1:List Book Sell
    if(!self.vcSelling){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.vcSelling = [storyboard instantiateViewControllerWithIdentifier:@"ContentOrderViewSellingController"];
        self.vcSelling.vcParent = self;
        [self.scrollViewMaster addSubview: self.vcSelling.view];
        self.vcSelling.view.frame = self.scrollViewMaster.bounds;
    }
    
    // 2:List Book Buy
    if(!self.vcBuying){

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.vcBuying = [storyboard instantiateViewControllerWithIdentifier:@"ContentOrderBuyingViewController"];
        self.vcBuying.vcParent = self;
        [self.scrollViewMaster addSubview: self.vcBuying.view];

         self.vcBuying.view.frame = CGRectMake(SW, 0, self.scrollViewMaster.bounds.size.width, self.scrollViewMaster.bounds.size.height);
    }
    
    [self.scrollViewMaster setContentSize:CGSizeMake(SW*2, SH - 112)];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self.scrollViewMaster == scrollView) {
        if (!decelerate) {
            int index = scrollView.contentOffset.x/scrollView.frame.size.width;
           
            if(index == TypeBookSell){
                
                [self touchBookSelling:nil];
            }
            else{
                
                [self touchBtnBookEnd:nil];
            }
        }
        
    }
    
}// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.scrollViewMaster) {
        int index = scrollView.contentOffset.x/scrollView.frame.size.width;
      
        if(index == TypeBookSell){
            
            [self touchBookSelling:nil];
        }
        else{
            
            [self touchBtnBookEnd:nil];
        }
    }
    
}
@end

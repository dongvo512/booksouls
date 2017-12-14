//
//  SlideMenuViewController.m
//  BookSouls
//
//  Created by Dong Vo on 10/19/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "CommonEnum.h"
#import "CommonDefine.h"
#import "MainViewController.h"
#import "EditUserInfoViewController.h"
#import "MyBookViewController.h"
#import "NotificationViewController.h"
#import "SupportViewController.h"
#import "OrderViewController.h"

@interface SlideMenuViewController ()
{
    
    
    CGFloat ratioWidthMenuLeft;
    
    UIView *viewBackground;
    
     NSLayoutConstraint *leftContraint;
}
@property (nonatomic, strong) NSMutableArray *arrNotiNonRead;
@end

@implementation SlideMenuViewController

static SlideMenuViewController *sharedInstance = nil;

+ (id)sharedInstance {
    
    @synchronized(self) {
        if (sharedInstance == nil) {
          
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            sharedInstance = [storyboard instantiateViewControllerWithIdentifier:@"SlideMenuViewController"];
            
        }
        return sharedInstance;
    }
    
}

+ (void)resetSharedInstance {
    
    @synchronized(self) {
        
        sharedInstance = nil;
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ratioWidthMenuLeft = 0.75;
    
    self.indexSelectedCurr = Item_Home;
    
    if(!Appdelegate_BookSouls.notiType){
        
         [self createNavigationContent];
    }
    else{
        
        [self createOrderNavigationContent];
        
    }
   
    [self createBackgroundView];
    [self createMenuLeft];
    [self addSwipeGestureForViewContent];
    
    self.arrNotiNonRead = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    
    [self getNumNotiNoRead];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method

- (void)getNumNotiNoRead{
    
    [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,GET_NOTIFICATION_NON_READ] withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
       
        if(!isError){
            
            NSNumber *numNotiNonRead = [responseDataObject objectForKey:@"total"];
            
            [self.viewMenuLeft updateNumNoti:numNotiNonRead];
        }
        
    }];
    
}

- (void)createNavigationContent{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MainViewController *vcMain = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    self.vcNavigation = [[UINavigationController alloc] initWithRootViewController:vcMain];
    self.vcNavigation.navigationBarHidden = YES;
    self.vcNavigation.view.frame = self.view.bounds;
    
    [self.view addSubview:self.vcNavigation.view];
    
}

- (void)createOrderNavigationContent{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    OrderViewController *vcOrder = [storyboard instantiateViewControllerWithIdentifier:@"OrderViewController"];
    
    self.vcNavigation = [[UINavigationController alloc] initWithRootViewController:vcOrder];
    self.vcNavigation.navigationBarHidden = YES;
    self.vcNavigation.view.frame = self.view.bounds;
    
    [self.view addSubview:self.vcNavigation.view];
    
    
}

- (void)createBackgroundView{
    
    viewBackground = [[UIView alloc] init];
    
    viewBackground.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [viewBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
    [viewBackground setAlpha:0];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [viewBackground addGestureRecognizer:singleFingerTap];
    
    
    
    [self.view addSubview:viewBackground];
    
    leftContraint = [NSLayoutConstraint constraintWithItem:viewBackground attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1  constant:0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:viewBackground attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:viewBackground attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:viewBackground attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self.view addConstraints:@[leftContraint, top, right, bottom]];
    
}

- (void)selecItemCurr:(NSInteger)index{
    
    if(index == self.indexSelectedCurr){
        return;
    }
    
    switch (index) {
        case Item_Home:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainViewController *vcMain = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self.vcNavigation setViewControllers:@[vcMain] animated:YES];
        }
            break;
        case Item_MyBook:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyBookViewController *vcMyBook = [storyboard instantiateViewControllerWithIdentifier:@"MyBookViewController"];
            [self.vcNavigation setViewControllers:@[vcMyBook] animated:YES];
        }
            break;
        case Item_UserInfo:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EditUserInfoViewController *vcEditUserInfo = [storyboard instantiateViewControllerWithIdentifier:@"EditUserInfoViewController"];
            [self.vcNavigation setViewControllers:@[vcEditUserInfo] animated:YES];
        }
            break;
        case Item_Notification:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NotificationViewController *vcNotification = [storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
            [self.vcNavigation setViewControllers:@[vcNotification] animated:YES];
        }
            break;
        case Item_Support:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SupportViewController *vcSupport = [storyboard instantiateViewControllerWithIdentifier:@"SupportViewController"];
            [self.vcNavigation setViewControllers:@[vcSupport] animated:YES];
        }
            break;
        case Item_Order:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OrderViewController *vcOrder = [storyboard instantiateViewControllerWithIdentifier:@"OrderViewController"];
            [self.vcNavigation setViewControllers:@[vcOrder] animated:YES];
        }
            break;
        default:
            break;
    }
    
    self.indexSelectedCurr = index;
    
}

- (void)selectedItemInMenu:(NSInteger )index{
    
    if(index != Item_Home){
        
        if(index == self.indexSelectedCurr){
            
            [self toggle];
            return;
        }
    }
    
    
    switch (index) {
        case Item_Home:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MainViewController *vcMain = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self.vcNavigation setViewControllers:@[vcMain] animated:YES];
        }
            break;
        case Item_MyBook:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyBookViewController *vcMyBook = [storyboard instantiateViewControllerWithIdentifier:@"MyBookViewController"];
            [self.vcNavigation setViewControllers:@[vcMyBook] animated:YES];
        }
            break;
        case Item_UserInfo:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EditUserInfoViewController *vcEditUserInfo = [storyboard instantiateViewControllerWithIdentifier:@"EditUserInfoViewController"];
            [self.vcNavigation setViewControllers:@[vcEditUserInfo] animated:YES];
        }
            break;
        case Item_Notification:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NotificationViewController *vcNotification = [storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
            [self.vcNavigation setViewControllers:@[vcNotification] animated:YES];
        }
            break;
        case Item_Support:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SupportViewController *vcSupport = [storyboard instantiateViewControllerWithIdentifier:@"SupportViewController"];
            [self.vcNavigation setViewControllers:@[vcSupport] animated:YES];
        }
            break;
        case Item_Order:{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            OrderViewController *vcOrder = [storyboard instantiateViewControllerWithIdentifier:@"OrderViewController"];
            [self.vcNavigation setViewControllers:@[vcOrder] animated:YES];
        }
            break;
        default:
            break;
    }
    
    self.indexSelectedCurr = index;
    
    [self toggle];
}

-(void)createMenuLeft{
    
    self.viewMenuLeft = [[MenuLeftView alloc] init];
    
    self.viewMenuLeft.backgroundColor = [UIColor whiteColor];
    
    [self.viewMenuLeft setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.viewMenuLeft];
    
    leftContraint = [NSLayoutConstraint constraintWithItem:self.viewMenuLeft attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1  constant:-(SW*ratioWidthMenuLeft)];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.viewMenuLeft attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.viewMenuLeft attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1     constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.viewMenuLeft attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:ratioWidthMenuLeft constant:0];
    
    [self.view addConstraints:@[leftContraint, top, height, width]];
    
    
}
- (void)addSwipeGestureForViewContent{
    
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggle)];
    [self.view addGestureRecognizer:swipeRecognizer];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    
    [self toggle];
}

- (void)toggle{
    
    if(leftContraint.constant == 0){
        
        leftContraint.constant = -(SW * ratioWidthMenuLeft);
        
    }
    else{
        
        leftContraint.constant = 0;
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
        
        if(leftContraint.constant == 0){
            
            [viewBackground setAlpha:1.0];
            
        }
        else{
            
            [viewBackground setAlpha:0];
        }
        
    } completion:nil];
    
}
-(void)setRatioWidthMenuLeft:(CGFloat)ratio{
    
    ratioWidthMenuLeft = ratio;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

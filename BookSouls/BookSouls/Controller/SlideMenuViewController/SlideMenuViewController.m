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

@interface SlideMenuViewController ()
{
     UINavigationController *vcNavigation;
    
    CGFloat ratioWidthMenuLeft;
    
    NSInteger indexSelectedCurr;
    
    UIView *viewBackground;
    
     NSLayoutConstraint *leftContraint;
}
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
    
    indexSelectedCurr = Item_Salon;
    
    [self createNavigationContent];
    [self createBackgroundView];
    [self createMenuLeft];
    [self addSwipeGestureForViewContent];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method
- (void)createNavigationContent{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MainViewController *vcMain = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    
    vcNavigation = [[UINavigationController alloc] initWithRootViewController:vcMain];
    vcNavigation.navigationBarHidden = YES;
    vcNavigation.view.frame = self.view.bounds;
    
    [self.view addSubview:vcNavigation.view];
    
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

- (void)selectedItemInMenu:(NSInteger )index{
    
    if(index == indexSelectedCurr){
        
        [self toggle];
        return;
    }
    
    if(self.isUserManager){
        
        [self selectItemManager:index];
    }
    else if (self.isAdmin){
        
        [self selectItemAdmin:index];
    }
    else{
        
        [self selectItemMemeber:index];
    }
    
    indexSelectedCurr = index;
    
    [self toggle];
}
- (void)selectItemManager:(NSInteger)index{
    
    switch (index) {
            
        case Item_InFoUserManger:{
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)selectItemMemeber:(NSInteger)index{
    
    switch (index) {
            
        case Item_Salon:{
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)selectItemAdmin:(NSInteger)index{
    
    switch (index) {
            
        case ItemAdminUser:{
            
        }
            break;
        default:
            break;
    }
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

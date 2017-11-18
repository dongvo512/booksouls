//
//  EditUserInfoViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/16/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "UIColor+HexString.h"

@interface EditUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewUserInfo;

@end

@implementation EditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)touchBtnMenu:(id)sender {
    
    [[SlideMenuViewController sharedInstance] toggle];
}

#pragma mark - Method
- (void)configUI{
    
    self.viewUserInfo.layer.cornerRadius = 6;
   // self.viewUserInfo.layer.borderWidth = 1.0;
    //self.viewUserInfo.layer.borderColor = [UIColor colorWithHexString:@"#95989A"].CGColor;
    self.viewUserInfo.layer.shadowColor = [UIColor colorWithHexString:@"#95989A"].CGColor;
    self.viewUserInfo.layer.masksToBounds = NO;
    self.viewUserInfo.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewUserInfo.layer.shadowRadius = 4;
    self.viewUserInfo.layer.shadowOpacity = 0.3;
    
}

@end

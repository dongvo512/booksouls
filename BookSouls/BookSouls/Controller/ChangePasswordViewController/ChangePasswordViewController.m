//
//  ChangePasswordViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/24/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfRepassword;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)touchBtnConfirm:(id)sender {
    
    
}
- (IBAction)touchBtnShowPassword:(id)sender {
    
    [self.tfPassword setSecureTextEntry:!self.tfPassword.secureTextEntry];
}
- (IBAction)touchBtnRePassword:(id)sender {
    
     [self.tfRepassword setSecureTextEntry:!self.tfRepassword.secureTextEntry];
}

#pragma mark - Call API
- (void)changePassword{
    
    
}

#pragma mark - Method
- (void)configUI{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.viewLogin.layer.cornerRadius = 10;
    self.viewLogin.layer.borderWidth = 0.5;
    self.viewLogin.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewLogin.layer.masksToBounds = NO;
    self.viewLogin.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewLogin.layer.shadowRadius = 8;
    self.viewLogin.layer.shadowOpacity = 0.0;
}

- (NSString *)getStringError{
    
    NSString *error = @"";
    
    if(self.tfPassword.text.length < 6){
        
        error = @"Mật khẩu không được nhỏ hơn 6 ký tự";
    }
    else if(self.tfRepassword.text.length < 6){
        
        error = @"Nhập lại mật khẩu không được nhỏ hơn 6 ký tự";
    }
    else if(![self.tfPassword.text isEqualToString:self.tfRepassword.text]){
        
         error = @"Mật khẩu và Nhập lại mật khẩu không khớp";
    }
    
    if(error.length == 0){
        
        [self.lblError setHidden:YES];
    }
    else{
        
        [self.lblError setHidden:NO];
    }
    
    return error;
}
- (void) keyboardWillHideHandler:(NSNotification *)notification {
    
    [self hideShadowWithAnimation];
    
}

- (void)hideShadowWithAnimation{
    
    self.viewLogin.layer.borderWidth = 0.5;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.2];
    anim.toValue = [NSNumber numberWithFloat:0.0];
    anim.duration = 0.3;
    [self.viewLogin.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.viewLogin.layer.shadowOpacity = 0.0;
}

- (void)addShadowWithAnimation{
    
    self.viewLogin.layer.borderWidth = 0.0;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.toValue = [NSNumber numberWithFloat:0.2];
    anim.duration = 0.3;
    [self.viewLogin.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.viewLogin.layer.shadowOpacity = 0.2;
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self addShadowWithAnimation];
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self hideShadowWithAnimation];
    
    return YES;
}

@end

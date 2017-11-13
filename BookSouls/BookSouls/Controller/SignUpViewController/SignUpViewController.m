//
//  SignUpViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/6/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewRegister;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfRePassword;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Call API

- (void)regisAccount{
    
    [self.view endEditing:YES];
    
    NSString *error = [self getStringValidate];
    
    if(error.length > 0){
        
        self.lblError.text = error;
        [self showError];
    }
    else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.lblError setHidden:YES];
        
        NSDictionary *dicBody = @{@"email":self.tfEmail.text,@"password":self.tfPassword.text,@"password_confirmation":self.tfRePassword.text};
        
        [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,POST_REGISTER] withHttpMethod:kHTTP_METHOD_POST withRequestBody:dicBody callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
           
            if(isError){
                
                 [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
            }
            else{
                
                [Common showAlert:self title:@"Thông báo" message:@"Đăng ký tài khoản thành công" buttonClick:^(UIAlertAction *alertAction) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            
        }];
    }
}

#pragma mark - Action

- (IBAction)touchBtnEyeRePassword:(id)sender {
    
     [self.tfRePassword setSecureTextEntry:!self.tfRePassword.secureTextEntry];
}

- (IBAction)touchButtonEyePassword:(id)sender {
    
    [self.tfPassword setSecureTextEntry:!self.tfPassword.secureTextEntry];
    
}

- (IBAction)touchBtnRegister:(id)sender {
    
    [self regisAccount];
}


- (IBAction)touchBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Method
- (void) keyboardWillHideHandler:(NSNotification *)notification {
    
    [self hideShadowWithAnimation];
    
}
- (void)addShadowWithAnimation{
    
    self.viewRegister.layer.borderWidth = 0.0f;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.toValue = [NSNumber numberWithFloat:0.2];
    anim.duration = 0.3;
    [self.viewRegister.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.viewRegister.layer.shadowOpacity = 0.2;
    
}

- (void)hideShadowWithAnimation{
    
    self.viewRegister.layer.borderWidth = 0.5f;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.2];
    anim.toValue = [NSNumber numberWithFloat:0.0];
    anim.duration = 0.3;
    [self.viewRegister.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.viewRegister.layer.shadowOpacity = 0.0;
}

- (void)showError{
    
    [self.lblError setHidden:NO];
    
    //for zoom in
    [UIView animateWithDuration:0.5f animations:^{
        
        self.lblError.transform = CGAffineTransformMakeScale(2.0, 2.0);
    } completion:^(BOOL finished){
        
    }];
    // for zoom out
    [UIView animateWithDuration:0.5f animations:^{
        
        self.lblError.transform = CGAffineTransformMakeScale(1, 1);
    }completion:^(BOOL finished){}];
}

- (void)configUI{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.viewRegister.layer.cornerRadius = 10;
    
    self.viewRegister.layer.masksToBounds = NO;
    self.viewRegister.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewRegister.layer.shadowRadius = 8;
    self.viewRegister.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewRegister.layer.borderWidth = 0.5;
    self.viewRegister.layer.shadowOpacity = 0.0;
}

- (NSString *)getStringValidate{
    
    NSString *strValidate = _CM_STRING_EMPTY;
    
    if(self.tfEmail.text.length == 0){
        
       return strValidate = @"Email Không được để trống";
    }
    else if(self.tfPassword.text.length == 0){
        
        return strValidate = @"Mật khẩu không được để trống";
    }
    else if(self.tfRePassword.text.length == 0){
        
       return strValidate = @"Nhập lại mật khẩu không được để trống";
    }
    else if(![Common validateEmailAddress:self.tfEmail.text]){
        
        return strValidate = @"Email không đúng định dạng";
    }
    else if(self.tfPassword.text.length < 6 ){
        
        return strValidate = @"Mật khẩu phải lớn hơn 6 ký tự";
    }
    else if(self.tfRePassword.text.length < 6 ){
        
        return strValidate = @"Nhập lại mật khẩu phải lớn hơn 6 ký tự";
    }
    else if(![self.tfRePassword.text isEqualToString:self.tfPassword.text]){
        
        return strValidate = @"Mật khẩu, Nhập lại mật khẩu không khớp";
    }
    
    return strValidate;
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self addShadowWithAnimation];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if([textField isEqual:self.tfEmail]){
        
        if([Common validateEmailAddress:self.tfEmail.text]){
            
            [self.lblError setHidden:YES];
            [self.tfPassword becomeFirstResponder];
           
        }
        else{
            self.lblError.text = @"Email không đúng định dạng";
            [self showError];
           
        }
    }
    else if([textField isEqual:self.tfPassword]){
        
        if(self.tfPassword.text.length >= 6){
            
            [self.tfRePassword becomeFirstResponder];
           
        }
        else{
           
            [self.lblError setHidden:YES];
            self.lblError.text = @"Mật khẩu phải lớn hơn 6 ký tự";
            [self showError];
           
        }
    }
    else if([textField isEqual:self.tfRePassword]){
       
        if(self.tfRePassword.text.length >= 6){
           
            [self.lblError setHidden:YES];
            [self regisAccount];
           
        }
        else{
            
            
            self.lblError.text = @"Mật khẩu phải lớn hơn 6 ký tự";
            [self showError];
           
        }
    }
    
    return YES;
}

@end

//
//  ForgetPasswordViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/22/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ChangePasswordViewController.h"

#define HEIGHT_LOGIN_DEFAULT 60
#define HEIGHT_LOGIN_ENTER_CODE 111

@interface ForgetPasswordViewController (){
    
    BOOL isEnterCode;
}
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet UIView *viewLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UIView *viewCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraintViewLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSendEmail;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method

- (NSString *)getStringError{
    
    NSString *err = @"";
    
    if(self.tfEmail.text.length == 0){
        
        err = @"Bạn chưa nhập địa chỉ Email";
    }
    else if(![Common validateEmailAddress:self.tfEmail.text]){
        
         err = @"Email không đúng định dạng";
    }
    
    if(err.length == 0){
        
        [self.lblError setHidden:YES];
    }
    
    return err;
}

- (void)showError:(NSString *)error{
    
    [self.lblError setHidden:NO];
    self.lblError.text = error;
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
    
    self.heightContraintViewLogin.constant = HEIGHT_LOGIN_DEFAULT;
    self.viewCode.alpha = 0.0f;
    
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
- (void)showViewCode{
    
    self.heightContraintViewLogin.constant = HEIGHT_LOGIN_ENTER_CODE;
    
    [UIView animateWithDuration:0.3 animations:^{
    
        self.viewCode.alpha = 1.0;
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Call API

- (void)confirmCode{
    
    if(self.tfCode.text.length < 4){
        
        [self showError:@"Code xác nhận không hợp lệ"];
    }
    else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary *dic = @{@"token":self.tfCode.text,@"email":self.tfEmail.text};
        
        [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,PUT_VERIFYTOKEN] withHttpMethod:kHTTP_METHOD_PUT withRequestBody:dic callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(isError){
                
                [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
            }
            else{
                
                NSString *token = [responseDataObject objectForKey:@"token"];
                
                Appdelegate_BookSouls.sesstionUser = [[SessionUser alloc] init];
                Appdelegate_BookSouls.sesstionUser.token = token;
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ChangePasswordViewController *vcBookAll = [storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
               
                [self.navigationController pushViewController:vcBookAll animated:YES];
                
            }
        }];
        
    }
}

- (void)getCodeToEmail{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dic = @{@"email":self.tfEmail.text};
    
    [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,PUT_RES_PASSWORD] withHttpMethod:kHTTP_METHOD_PUT withRequestBody:dic callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            [Common showAlert:self title:@"Thông báo" message:@"Code đã được gửi đến mail của bạn" buttonClick:^(UIAlertAction *alertAction) {
                
                [self showViewCode];
                
                [self.btnSendEmail setTitle:@"Xác nhận" forState:UIControlStateNormal];
                
                isEnterCode = YES;
                
                [self.tfCode becomeFirstResponder];
                [self.tfEmail setEnabled:NO];
            }];
            
        }
    }];
}

#pragma mark - Action

- (IBAction)touchBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchBtnSendEmail:(id)sender {
    
    if(!isEnterCode){
        
        NSString *error = [self getStringError];
        
        if(error.length == 0){
            
            [self getCodeToEmail];
        }
        else{
            
            [self showError:error];
        }
        
    }
    else{
        
        [self confirmCode];
    }
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

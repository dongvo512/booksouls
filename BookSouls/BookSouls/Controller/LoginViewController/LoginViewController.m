//
//  LoginViewController.m
//  BookSouls
//
//  Created by Dong Vo on 10/19/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "LoginViewController.h"
#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SignUpViewController.h"
#import "SlideMenuViewController.h"
#import "SessionUser.h"
#import "ForgetPasswordViewController.h"

@interface LoginViewController ()<GIDSignInUIDelegate, GIDSignInDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewLogin;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblError;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action

- (IBAction)touchBtnForgetPass:(id)sender {
    
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ForgetPasswordViewController *vcForgetPass = [mystoryboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
    [self.navigationController pushViewController:vcForgetPass animated:YES];
    
}


- (IBAction)touchBtnRegis:(id)sender {
    
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignUpViewController *signUpVC = [mystoryboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:signUpVC animated:YES];
    
}

- (IBAction)touchBtnEyePassword:(id)sender {
    
     [self.tfPassword setSecureTextEntry:!self.tfPassword.secureTextEntry];
}


- (IBAction)touchBtnLoginAccount:(id)sender {
    
    [self loginAcount];
}

- (IBAction)touchBtnGoogleLogin:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [[GIDSignIn sharedInstance] hasAuthInKeychain];
    [[GIDSignIn sharedInstance] signIn];
    
}
- (IBAction)touchBtnFBLogin:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email",@"user_birthday"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
         } else if (result.isCancelled) {
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
         } else {
             
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             if ([FBSDKAccessToken currentAccessToken]) {
                 
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,first_name,devices,birthday,gender,picture"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                      if (!error) {
                         
                          [self loginFaceBook:[FBSDKAccessToken currentAccessToken].tokenString];
                         
                      }
                      
                  }];
                 
                 
             }
             
         }
     }];
}

#pragma mark - Call API

- (void)loginFaceBook:(NSString *)accessToken {
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dicBody = @{@"accessToken":accessToken, @"deviceToken":(Appdelegate_BookSouls.deviceToken)?Appdelegate_BookSouls.deviceToken:@"", @"deviceType":@"ios"};
    
    [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,POST_LOGIN_FB] withHttpMethod:kHTTP_METHOD_POST withRequestBody:dicBody callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSError *error;
            
            Appdelegate_BookSouls.sesstionUser = [[SessionUser alloc] initWithDictionary:responseDataObject error:&error];
          
            NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:Appdelegate_BookSouls.sesstionUser];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:encodedObject forKey:@"FirstRun"];
            [defaults synchronize];
            
            [self.navigationController pushViewController:[SlideMenuViewController sharedInstance] animated:YES];
            
            self.tfEmail.text = @"";
            self.tfPassword.text = @"";
            
        }
        
    }];
    
}

- (void)loginGoogle:(NSString *)accessToken {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dicBody = @{@"accessToken":accessToken,@"deviceToken":(Appdelegate_BookSouls.deviceToken)?Appdelegate_BookSouls.deviceToken:@"", @"deviceType":@"ios"};
    
    [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,POST_LOGIN_GOOGLE] withHttpMethod:kHTTP_METHOD_POST withRequestBody:dicBody callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSError *error;
            
            Appdelegate_BookSouls.sesstionUser = [[SessionUser alloc] initWithDictionary:responseDataObject error:&error];
            
            NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:Appdelegate_BookSouls.sesstionUser];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:encodedObject forKey:@"FirstRun"];
            [defaults synchronize];
            
            [self.navigationController pushViewController:[SlideMenuViewController sharedInstance] animated:YES];
            
            self.tfEmail.text = @"";
            self.tfPassword.text = @"";
        }
        
    }];
    
}

- (void)loginAcount{
    
    NSString *error = [self getStringValidate];
    
    [self.view endEditing:YES];
   
    if(error.length > 0){
        
        self.lblError.text = error;
        [self showError];
    }
    else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.lblError setHidden:YES];
        
        NSDictionary *dicBody = @{@"email":self.tfEmail.text,@"password":self.tfPassword.text,@"deviceToken":(Appdelegate_BookSouls.deviceToken)?Appdelegate_BookSouls.deviceToken:@"", @"deviceType":@"ios"};
        
        [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,POST_LOGIN] withHttpMethod:kHTTP_METHOD_POST withRequestBody:dicBody callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(isError){
                
                [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
            }
            else{
                
                NSError *error;
                
                Appdelegate_BookSouls.sesstionUser = [[SessionUser alloc] initWithDictionary:responseDataObject error:&error];
                
                NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:Appdelegate_BookSouls.sesstionUser];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:encodedObject forKey:@"FirstRun"];
                [defaults synchronize];
                
                [self.navigationController pushViewController:[SlideMenuViewController sharedInstance] animated:YES];
               
                self.tfEmail.text = @"";
                self.tfPassword.text = @"";
            }
            
        }];
    }
}

#pragma mark - Method

- (void)addShadowWithAnimation{
    
    self.viewLogin.layer.borderWidth = 0.0;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.toValue = [NSNumber numberWithFloat:0.2];
    anim.duration = 0.3;
    [self.viewLogin.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.viewLogin.layer.shadowOpacity = 0.2;
    
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

- (void) keyboardWillHideHandler:(NSNotification *)notification {
   
    [self hideShadowWithAnimation];
    
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

- (NSString *)getStringValidate{
    
    NSString *strValidate = _CM_STRING_EMPTY;
    
    if(self.tfEmail.text.length == 0){
        
        return strValidate = @"Email Không được để trống";
    }
    else if(self.tfPassword.text.length == 0){
        
        return strValidate = @"Mật khẩu không được để trống";
    }
    else if(![Common validateEmailAddress:self.tfEmail.text]){
        
        return strValidate = @"Email không đúng định dạng";
    }
    else if(self.tfPassword.text.length < 6 ){
        
        return strValidate = @"Mật khẩu phải lớn hơn 6 ký tự";
    }
    
    
    return strValidate;
}

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
            
            [self.lblError setHidden:YES];
            [self loginAcount];
            
        }
        else{

            self.lblError.text = @"Mật khẩu phải lớn hơn 6 ký tự";
            [self showError];
            
        }
    }
    
    return YES;
}
#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if(!error && [GIDSignIn sharedInstance].hasAuthInKeychain){
   
        NSString *accessToken = user.authentication.accessToken; // Safe to send to the server
        [self loginGoogle:accessToken];
        
    }
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //  [myActivityIndicator stopAnimating];
    //loginView.btnGoogle.enabled = NO;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if(!error && [GIDSignIn sharedInstance].hasAuthInKeychain){
        
    }else{
        
       // loginView.btnGoogle.enabled = YES;
    }
    
    
    
}


- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    //add your code here
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end

//
//  LoginViewController.m
//  BookSouls
//
//  Created by Dong Vo on 10/19/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "LoginViewController.h"
#import <Google/SignIn.h>


@interface LoginViewController ()<GIDSignInUIDelegate, GIDSignInDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Method

- (IBAction)touchBtnLogin:(id)sender {
   
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [[GIDSignIn sharedInstance] hasAuthInKeychain];
    [[GIDSignIn sharedInstance] signIn];
    
}
#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    //add your code here
    
   // loginView.btnGoogle.enabled = NO;
    
    if(!error && [GIDSignIn sharedInstance].hasAuthInKeychain){
     
//        NSString *userId = user.userID;                  // For client-side use only!
//        NSString *idToken = user.authentication.idToken; // Safe to send to the server
//        NSString *fullName = user.profile.name;
//        NSString *givenName = user.profile.givenName;
//        NSString *familyName = user.profile.familyName;
//        NSString *email = user.profile.email;
        
    }else{
        
       // loginView.btnGoogle.enabled = YES;
    }
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //  [myActivityIndicator stopAnimating];
    //loginView.btnGoogle.enabled = NO;
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

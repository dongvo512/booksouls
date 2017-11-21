//
//  EditUserInfoViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/16/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "UIColor+HexString.h"
#import "TextFieldView.h"
#import "ImagePickerViewController.h"
#import "PreviewImageViewController.h"
#import "Image.h"
#import "SessionUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MenuLeftView.h"

#define WIDTH_STAR 110

@interface EditUserInfoViewController ()<UITextFieldDelegate>{
    
    ImagePickerViewController *vcImagePicker;
    
    NSString *strUrlAvatar;
    
    Image *imgAvatar;
}

@property (weak, nonatomic) IBOutlet TextFieldView *tfName;
@property (weak, nonatomic) IBOutlet TextFieldView *tfPhone;
@property (weak, nonatomic) IBOutlet TextFieldView *tfAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvtar;
@property (weak, nonatomic) IBOutlet UILabel *lblNameTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewStar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthStar;


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

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    vcImagePicker = [[ImagePickerViewController alloc] init];
    vcImagePicker.delegateImg = self;
    vcImagePicker.vcParent = self;
}

#pragma mark - Action

- (IBAction)touchAvatar:(id)sender {
    
    UIAlertController *vcAlert = [UIAlertController alertControllerWithTitle:@"Hình ảnh" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [vcImagePicker takeAPickture:self];
        
    }];
    
    UIAlertAction *photoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [vcImagePicker cameraRoll:self];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Bỏ qua" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [vcAlert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [vcAlert addAction:camera];
    [vcAlert addAction:photoLibrary];
    [vcAlert addAction:cancel];
    
    [self presentViewController:vcAlert animated:YES completion:nil];
}

- (IBAction)touchBtnMenu:(id)sender {
    
    [[SlideMenuViewController sharedInstance] toggle];
}
- (IBAction)touchBtnSave:(id)sender {
    
    [self updateUserInfo];
}

#pragma mark - Call API
- (void)uploadImage:(NSData *)data{
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_DEFAULT,UPLOAD_IMAGE];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    
    // Create path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"newfile.jpg"];
    
    // Save image.
    [data writeToFile:filePath atomically:YES];
    
    [APIRequestHandler uploadImageWithURLString:url filePath:filePath withHttpMethod:kHTTP_METHOD_POST uploadAPIResult:^(BOOL isError, NSString *stringError, id responseDataObject, NSProgress *progress) {
        
        NSError *error;
        hud.progressObject = progress;
        
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        
        if(isError){
            
            [hud hideAnimated:YES];
            [Common showAlert:self title:@"Thông báo" message:@"Lỗi upload hình ảnh" buttonClick:nil];
        }
        else{
            
            if(responseDataObject && !isError){
                
                [hud hideAnimated:YES];
                NSError *error;
                NSDictionary *data = [responseDataObject objectForKey:@"data"];
                
                Image *img = [[Image alloc] initWithDictionary:data error:&error];
                img.url = [NSString stringWithFormat:@"http://203.162.76.2/book/public/%@",img.url];
                imgAvatar = img;
                
                
            }
            
        }
        
    }];
    
}
- (void)updateUserInfo{
    
    [self.view endEditing:YES];
    
    NSString *error = [self checkValidate];
    
    if(error.length > 0 ){
        
        self.lblError.text = error;
        [self showError];
    }
    else{
        
        [self.lblError setHidden:YES];
      
        NSDictionary *dic = nil;
        
        if(imgAvatar){
            
            dic = @{@"name":self.tfName.tfContent.text, @"phone":self.tfPhone.tfContent.text, @"homeAddress":(self.tfAddress.tfContent.text.length > 0)?self.tfAddress.tfContent.text:@"", @"avatarId":imgAvatar.id.stringValue};
        }
        else{
            
            dic = @{@"name":self.tfName.tfContent.text, @"phone":self.tfPhone.tfContent.text, @"homeAddress":(self.tfAddress.tfContent.text.length > 0)?self.tfAddress.tfContent.text:@""};
        }
        
       
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,PUT_USER_UPDATE] withHttpMethod:kHTTP_METHOD_PUT withRequestBody:dic callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(isError){
                
                [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
            }
            else{
                
                [Common showAlert:self title:@"Thông báo" message:@"Cập nhật thông tin thành công" buttonClick:nil];
                NSError *error;
                Appdelegate_BookSouls.sesstionUser.profile = [[UserInfo alloc] initWithDictionary:responseDataObject error:&error];
                
                NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:Appdelegate_BookSouls.sesstionUser];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:encodedObject forKey:@"FirstRun"];
                [defaults synchronize];
                
                MenuLeftView *menuLeft = [[SlideMenuViewController sharedInstance] viewMenuLeft];
                [menuLeft loadUserInfo];
            }
        }];
    }
}

#pragma mark - Method
- (void)showPreviewImage:(UIImage *)img{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PreviewImageViewController *vcPreviewImage = [storyboard instantiateViewControllerWithIdentifier:@"PreviewImageViewController"];
    vcPreviewImage.delegate = self;
    vcPreviewImage.imagePreview = img;
    [self presentViewController:vcPreviewImage animated:YES completion:nil];
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

- (NSString *)checkValidate{
    
    NSString *error = @"";
    
    if(self.tfName.tfContent.text.length == 0){
        
        error = @"Tên đại diện không được để trống";
    }
    else if(!(self.tfPhone.tfContent.text.length >= 8 && self.tfPhone.tfContent.text.length <= 11)){
        
        error = @"Số điện thoại không hợp lệ";
    }
    
    return error;
}

- (void)configUI{
    
    self.viewUserInfo.layer.cornerRadius = 6;
    self.viewUserInfo.layer.borderWidth = 0.5;
    self.viewUserInfo.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewUserInfo.layer.shadowColor = [UIColor colorWithHexString:@"#95989A"].CGColor;
    self.viewUserInfo.layer.masksToBounds = NO;
    self.viewUserInfo.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewUserInfo.layer.shadowRadius = 4;
    self.viewUserInfo.layer.shadowOpacity = 0.0;
    
    self.tfName.strSubTile = @"Tên đại diện";
    self.tfName.strIcon = @"";
    [self.tfName.tfContent setReturnKeyType:UIReturnKeyNext];
    [self.tfName setDataForTextView];
    self.tfName.delegate = self;
    self.tfName.tfContent.delegate = self;
    
    self.tfPhone.strSubTile = @"Số điện thoại";
    self.tfPhone.strIcon = @"";
    [self.tfPhone setDataForTextView];
    [self.tfPhone.tfContent setReturnKeyType:UIReturnKeyNext];
    self.tfPhone.delegate = self;
    self.tfPhone.tfContent.delegate = self;
    
    self.tfAddress.strSubTile = @"Địa chỉ";
    self.tfAddress.strIcon = @"";
    [self.tfAddress.tfContent setReturnKeyType:UIReturnKeyDone];
    [self.tfAddress setDataForTextView];
    self.tfAddress.delegate = self;
    self.tfAddress.tfContent.delegate = self;
    
    if(Appdelegate_BookSouls.sesstionUser.profile){
        
        if(Appdelegate_BookSouls.sesstionUser.profile.name.length > 0){
            
            [self.tfName setDataEditing:Appdelegate_BookSouls.sesstionUser.profile.name];
            self.lblNameTitle.text = Appdelegate_BookSouls.sesstionUser.profile.name;
        }
       
        if(Appdelegate_BookSouls.sesstionUser.profile.phone.length > 0){
            
            [self.tfPhone setDataEditing:Appdelegate_BookSouls.sesstionUser.profile.phone];
        }
        
        if(Appdelegate_BookSouls.sesstionUser.profile.homeAddress.length > 0){
            
            [self.tfAddress setDataEditing:Appdelegate_BookSouls.sesstionUser.profile.homeAddress];
        }
        
        if(Appdelegate_BookSouls.sesstionUser.profile.homeAddress.length > 0){
            
            [self.tfAddress setDataEditing:Appdelegate_BookSouls.sesstionUser.profile.homeAddress];
        }
        
        if(Appdelegate_BookSouls.sesstionUser.profile.avatar.length > 0){
            
            [self.imgAvtar sd_setImageWithURL:[NSURL URLWithString:Appdelegate_BookSouls.sesstionUser.profile.avatar] placeholderImage:[UIImage imageNamed:@"btn_user_edit"]];
        }
        
        self.widthStar.constant = Appdelegate_BookSouls.sesstionUser.profile.avgRating.integerValue * WIDTH_STAR/5;
       
    }
    
}
- (void)addShadowWithAnimation{
    
    self.viewUserInfo.layer.borderWidth = 0.0;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.toValue = [NSNumber numberWithFloat:0.3];
    anim.duration = 0.3;
    [self.viewUserInfo.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.viewUserInfo.layer.shadowOpacity = 0.2;
    
}

- (void)hideShadowWithAnimation{
    
    self.viewUserInfo.layer.borderWidth = 0.5;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.3];
    anim.toValue = [NSNumber numberWithFloat:0.0];
    anim.duration = 0.3;
    [self.viewUserInfo.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.viewUserInfo.layer.shadowOpacity = 0.0;
}
#pragma mark - ImagePickerViewControllerDelegate
- (void)finishGetImage:(NSString *)fileName
                 image:(UIImage *)image{
    
    [self performSelector:@selector(showPreviewImage:) withObject:image afterDelay:0.5];
    
}
#pragma mark - PreviewImageViewControllerDelegate

- (void)touchBtnAcept:(UIImage *)img{
    
    NSData *data= nil;
    
    [self.imgAvtar setImage:img];
    
    float imgValue = MAX(img.size.width, img.size.height);
    
    if(imgValue > 3000){
        
        data = UIImageJPEGRepresentation(img, 0.1);
        
    }
    else if(imgValue > 2000){
        
        data = UIImageJPEGRepresentation(img, 0.3);
    }
    else{
        
        data = UIImageJPEGRepresentation(img, 0.8);
    }
    
    
    [self uploadImage:data];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self addShadowWithAnimation];
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self hideShadowWithAnimation];
  
    if([textField isEqual:self.tfName.tfContent]){
        
        if(textField.text.length > 0){
            
            [self.lblError setHidden:YES];
            [self.tfPhone.tfContent becomeFirstResponder];
            
        }
        else{
            self.lblError.text = @"Tên đại diện không được để trống";
            [self showError];
            
        }
    }
    else if([textField isEqual:self.tfPhone.tfContent]){
        
        if(self.tfPhone.tfContent.text.length >= 8 && self.tfPhone.tfContent.text.length <= 11){
            
            [self.lblError setHidden:YES];
             [self.tfAddress.tfContent becomeFirstResponder];
            
        }
        else{
            
            self.lblError.text = @"Số điện thoại không hợp lệ";
            [self showError];
            
        }
    }else if([textField isEqual:self.tfAddress.tfContent]){
        
        [self updateUserInfo];
    }
    
    
    return YES;
}
@end

//
//  SupportViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/22/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "SupportViewController.h"
#import "UIColor+HexString.h"
#import "TextFieldView.h"

@interface SupportViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewSupport;
@property (weak, nonatomic) IBOutlet TextFieldView *tfTitle;
@property (weak, nonatomic) IBOutlet TextFieldView *tfContent;

@end

@implementation SupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
- (IBAction)touchBtnSend:(id)sender {
    
    [self.view endEditing:YES];
    [self sendSupport];
}

#pragma mark - Call API
- (void)sendSupport{
    
    if(self.tfTitle.tfContent.text.length == 0){
        
        [Common showAlert:self title:@"Thông báo" message:@"Tiêu đề không được để trống" buttonClick:nil];
        return;
    }
    else if(self.tfContent.tfContent.text.length == 0){
        
        [Common showAlert:self title:@"Thông báo" message:@"Nội dung không được để trống" buttonClick:nil];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dic = @{@"subject":self.tfTitle.tfContent.text, @"message":self.tfContent.tfContent.text};
    
    [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,POST_SUPPORT] withHttpMethod:kHTTP_METHOD_POST withRequestBody:dic callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            [Common showAlert:self title:@"Thông báo" message:@"Gửi hỗ trợ thành công" buttonClick:nil];
        }
    }];
}

#pragma mark - Method
- (void)configUI{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.viewSupport.layer.cornerRadius = 6;
    self.viewSupport.layer.borderWidth = 0.5;
    self.viewSupport.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.viewSupport.layer.shadowColor = [UIColor colorWithHexString:@"#95989A"].CGColor;
    self.viewSupport.layer.masksToBounds = NO;
    self.viewSupport.layer.shadowOffset = CGSizeMake(0, 0);
    self.viewSupport.layer.shadowRadius = 4;
    self.viewSupport.layer.shadowOpacity = 0.0;
    
    self.tfTitle.strSubTile = @"Tiêu đề";
    //self.tfTitle.strIcon = @"";
    [self.tfTitle.tfContent setReturnKeyType:UIReturnKeyDone];
    self.tfTitle.tfContent.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [self.tfTitle setDataForTextView];
    self.tfTitle.delegate = self;
    
    self.tfContent.strSubTile = @"Nội dung";
    //self.tfTitle.strIcon = @"";
    [self.tfContent.tfContent setReturnKeyType:UIReturnKeyDone];
    self.tfContent.tfContent.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [self.tfContent setDataForTextView];
    self.tfContent.delegate = self;
  
}

- (void)addShadowWithAnimation{
    
    self.viewSupport.layer.borderWidth = 0.0;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.0];
    anim.toValue = [NSNumber numberWithFloat:0.3];
    anim.duration = 0.3;
    [self.viewSupport.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.viewSupport.layer.shadowOpacity = 0.2;
    
}

- (void)hideShadowWithAnimation{
    
    self.viewSupport.layer.borderWidth = 0.5;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    anim.fromValue = [NSNumber numberWithFloat:0.3];
    anim.toValue = [NSNumber numberWithFloat:0.0];
    anim.duration = 0.3;
    [self.viewSupport.layer addAnimation:anim forKey:@"shadowOpacity"];
    self.viewSupport.layer.shadowOpacity = 0.0;
}

- (void) keyboardWillHideHandler:(NSNotification *)notification {
    
    [self hideShadowWithAnimation];
    
}

#pragma mark - TextFieldViewDelegate

- (void)beginEditing:(TextFieldView *)textField{
    
     [self addShadowWithAnimation];
}
- (void)returnKeyboard:(TextFieldView *)textField{
    
     [self hideShadowWithAnimation];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
  
    [self addShadowWithAnimation];
    
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [self hideShadowWithAnimation];
}
@end

//
//  PreviewImageViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/15/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "PreviewImageViewController.h"

@interface PreviewImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPreView;

@property (weak, nonatomic) IBOutlet UIButton *btnAcept;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation PreviewImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.imgViewPreView setImage:self.imagePreview];
    
    self.btnAcept.layer.borderWidth = 0.5;
    self.btnAcept.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnAcept.layer.masksToBounds = NO;
    self.btnAcept.layer.shadowOffset = CGSizeMake(0, 0);
    self.btnAcept.layer.shadowRadius = 8;
    self.btnAcept.layer.shadowOpacity = 0.2;
    
    self.btnCancel.layer.borderWidth = 0.5;
    self.btnCancel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnCancel.layer.masksToBounds = NO;
    self.btnCancel.layer.shadowOffset = CGSizeMake(0, 0);
    self.btnCancel.layer.shadowRadius = 8;
    self.btnCancel.layer.shadowOpacity = 0.2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBtnAcept:(id)sender {
    
    if([[self delegate] respondsToSelector:@selector(touchBtnAcept:)]){
        
        [[self delegate] touchBtnAcept:self.imagePreview];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)touchBtnCancel:(id)sender {
    
    if([[self delegate] respondsToSelector:@selector(touchBtnCancel)]){
        
        [[self delegate] touchBtnCancel];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

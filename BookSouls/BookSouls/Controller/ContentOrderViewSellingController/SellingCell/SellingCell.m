//
//  SellingCell.m
//  BookSouls
//
//  Created by Dong Vo on 11/28/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "SellingCell.h"
#import "Order.h"
#import "Book.h"
#import "Image.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+HexString.h"

@interface SellingCell()

typedef NS_ENUM(NSInteger, SelectedSeller) {
    
    SellerPending,
    SellerSending,
    SellerSucess,
    SellerSelled,
    SellerCancel
    
};

@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBook;
@property (weak, nonatomic) IBOutlet UILabel *lblBookName;
@property (weak, nonatomic) IBOutlet UILabel *lblIDBook;
@property (weak, nonatomic) IBOutlet UILabel *lblBuyerName;
@property (weak, nonatomic) IBOutlet UILabel *lblBuyerPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblBuyerAddress;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatrBuyer;
@property (weak, nonatomic) IBOutlet UIButton *btnAcept;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UILabel *lblCancel;
@property (nonatomic, strong) Order *orderCurr;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIView *viewPrice;

@end

@implementation SellingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.imgViewBook.layer.shadowOffset = CGSizeMake(-2, 4);
//    self.imgViewBook.layer.shadowRadius = 2;
//    self.imgViewBook.layer.shadowOpacity = 0.2;
    
    self.viewPrice.layer.shadowOffset = CGSizeMake(-2, 0);
    self.viewPrice.layer.shadowRadius = 2;
    self.viewPrice.layer.shadowOpacity = 0.15;
}

#pragma mark - Action

- (IBAction)touchBuyer:(id)sender {
    
    if([[self delegate] respondsToSelector:@selector(selectedBuyer:)]){
        
        [[self delegate] selectedBuyer:self.orderCurr];
    }
}
- (IBAction)touchBook:(id)sender {
    
    if([[self delegate] respondsToSelector:@selector(selectedBook:)]){
        
        [[self delegate] selectedBook:self.orderCurr];
    }
}
- (IBAction)touchBtnAcept:(id)sender {
    
    if([[self delegate] respondsToSelector:@selector(selectedButtonAcept:)]){
        
        [[self delegate] selectedButtonAcept:self.orderCurr];
    }
}
- (IBAction)touchBtnCancel:(id)sender {
    
    if([[self delegate] respondsToSelector:@selector(selectedButtonCancel:)]){
        
        [[self delegate] selectedButtonCancel:self.orderCurr];
    }
}
- (IBAction)touchBtnComment:(id)sender {
    
    if([[self delegate] respondsToSelector:@selector(selectedButtonComment:)]){
        
        [[self delegate] selectedButtonComment:self.orderCurr];
    }
}

#pragma mark - Method
- (void)setDataForCell:(Order *)order indexSelected:(NSInteger)indexSelected{
    
    self.orderCurr = order;
    
    [self.imgAvatrBuyer sd_setImageWithURL:[NSURL URLWithString:order.buyer.avatar] placeholderImage:[UIImage imageNamed:@"ic_avatar"]];
    
    if(order.book.images.count > 0){
        
        Image *img = [order.book.images firstObject];
        
        [self.imgViewBook sd_setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"bg_default"]];
    }
    
    self.lblBookName.text = order.book.name;
    self.lblIDBook.text = [NSString stringWithFormat:@"Mã số %@",order.id.stringValue];
    
    [Common hightLightLabel:self.lblIDBook withSubstring:order.id.stringValue withColor:[UIColor colorWithHexString:@"#252C3A"] font:[UIFont fontWithName:@"Muli-Regular" size:13]];
    
    self.lblBuyerPhone.text = order.buyer.phone;
    self.lblBuyerName.text = order.buyer.name;
    self.lblBuyerAddress.text = order.buyer.homeAddress;
    NSString *priceTemp = [Common getString3DigitsDot:order.book.price.integerValue];
    self.lblPrice.text = priceTemp;
    
    self.lblCancel.text = @"";
    
    if(indexSelected == SellerPending){
        
        [self.btnAcept setHidden:NO];
        [self.btnCancel setHidden:NO];
        [self.btnComment setHidden:YES];
        [self.lblCancel setHidden:YES];
    }
    else if(indexSelected == SellerSending){
        
        [self.btnAcept setHidden:YES];
        [self.btnCancel setHidden:NO];
        [self.btnComment setHidden:YES];
        [self.lblCancel setHidden:YES];
    }
    else if(indexSelected == SellerSucess){
        
        [self.btnAcept setHidden:YES];
        [self.btnCancel setHidden:YES];
        [self.btnComment setHidden:NO];
        [self.lblCancel setHidden:YES];
    }
    else if(indexSelected == SellerSelled){
        
        [self.btnAcept setHidden:YES];
        [self.btnCancel setHidden:YES];
        [self.btnComment setHidden:YES];
        [self.lblCancel setHidden:YES];
    }
    else if(indexSelected == SellerCancel){
        
        [self.btnAcept setHidden:YES];
        [self.btnCancel setHidden:YES];
        [self.btnComment setHidden:YES];
        [self.lblCancel setHidden:NO];
        
        NSString *trimmedString = [order.descriptionStr stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
         self.lblCancel.text = trimmedString;
    }
    
   
}
@end


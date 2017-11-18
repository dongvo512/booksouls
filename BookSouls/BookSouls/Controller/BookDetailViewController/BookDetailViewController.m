//
//  BookDetailViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/10/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookDetailTitleView.h"
#import "Book.h"
#import "BookSellerView.h"
#import "BookContentView.h"
#import "BookView.h"
#import "BookImageViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#define NUM_GROUP 4

#define HEIGHT_HEADER_TITLE 330

#define HEIGHT_HEADER_USER_INFO 98

#define HEIGHT_HEADER_CONTENT_DEFAULT 50

#define HEIGHT_CONTENT_DEFAULT 54

#define HEIGHT_BOOK_RELATED 284

@interface BookDetailViewController ()<MFMessageComposeViewControllerDelegate>{
    
    BOOL isExpand;
    BOOL isShowExpand;
}

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UIView *viewBuyBook;
@property (weak, nonatomic) IBOutlet UICollectionView *cllBookDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceBuy;


@property (nonatomic, strong) NSMutableArray *arrRelated;



typedef NS_ENUM(NSInteger, BookDetail) {
    
    GroupTitle,
    GroupUserInfo,
    GroupContent,
    GroupRelation
};

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *strPrice = [NSString stringWithFormat:@"Đặt sách với giá %@đ",[Common getString3DigitsDot:self.bookCurr.price.integerValue]];
    
    self.lblPriceBuy.text = strPrice;
    
    self.lblTitle.text = self.bookCurr.name;
    
    [self configUI];
    
    [self getListBookRelated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBtnPrice:(id)sender {
    
    [Common showAlertCancel:self title:@"Thông báo" message:@"Bạn có chắc muốn đặt mua cuốn sách này" buttonClick:^(UIAlertAction *alertAction) {
        
        [self orderBook];
        
    } buttonClickCancel:nil];
}


- (IBAction)touchBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Call API

- (void)orderBook{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",URL_DEFAULT,ORDER_BOOK,self.bookCurr.id.stringValue];
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_POST withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            [Common showAlert:self title:@"Thông báo" message:@"Đặt sách thành công vui lòng liên hệ với người bán" buttonClick:nil];
            
        }
        
    }];
    
}

- (void)getListBookRelated{
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/related",URL_DEFAULT,GET_LIST_BOOK_RELATED,self.bookCurr.id.stringValue];
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            self.arrRelated = [NSMutableArray array];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Book *book = [[Book alloc] initWithDictionary:dic error:&error];
                
                [self.arrRelated addObject:book];
                
            }
            
            if(self.arrRelated.count > 0){
                
                [self.cllBookDetail reloadSections:[NSIndexSet indexSetWithIndex:GroupRelation]];
            }
            
        }
        
    }];
    
}

#pragma mark - Method
- (void)configUI{
    
    self.viewBottom.layer.shadowOffset = CGSizeMake(0, -3);
    self.viewBottom.layer.shadowRadius = 2;
    self.viewBottom.layer.shadowOpacity = 0.1;
    
    self.viewBuyBook.layer.shadowOffset = CGSizeMake(0, 3);
    self.viewBuyBook.layer.shadowRadius = 2;
    self.viewBuyBook.layer.shadowOpacity = 0.1;
    
    
    [self.cllBookDetail registerNib:[UINib nibWithNibName:@"BookDetailTitleView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookDetailTitleView"];
    
    [self.cllBookDetail registerNib:[UINib nibWithNibName:@"BookSellerView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookSellerView"];
    
    [self.cllBookDetail registerNib:[UINib nibWithNibName:@"BookContentView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookContentView"];
    
     [self.cllBookDetail registerNib:[UINib nibWithNibName:@"BookView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookView"];
    
}
#pragma mark - UICollectionViewDataSource - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return NUM_GROUP;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor whiteColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 24, 0, 24);
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize headerSize = CGSizeZero;
    
    switch (section) {
        case GroupTitle:{
            
            headerSize = CGSizeMake(SW, HEIGHT_HEADER_TITLE);
            
        }
            break;
        case GroupUserInfo:{
            
            headerSize = CGSizeMake(SW, HEIGHT_HEADER_USER_INFO);
            
        }
            break;
        case GroupContent:{
            
            CGFloat heightCell = 0;
            if(self.bookCurr.descriptionStr.length > 0){
                
                CGFloat heightContent = [Common findHeightForText:self.bookCurr.descriptionStr havingWidth:SW - 40 andFont:[UIFont fontWithName:@"Muli-Regular" size:14]];
                
                if(heightContent > HEIGHT_CONTENT_DEFAULT){
                    
                    isShowExpand = YES;
                    //  +75
                    if(!isExpand){
                        
                        heightCell = HEIGHT_CONTENT_DEFAULT + 75;
                    }
                    else{
                        
                        heightCell = heightContent + 75;
                    }
                    
                }
                else{
                    
                    isShowExpand = NO;
                    isExpand = NO;
                    //  +45
                    heightCell = heightContent + 50;
                }
            }
            headerSize = CGSizeMake(SW, heightCell);
            
        }
            break;
        case GroupRelation:{
            
            if(self.arrRelated.count > 0){
                
                headerSize = CGSizeMake(SW, HEIGHT_BOOK_RELATED);
            }
            else{
                
                headerSize = CGSizeMake(0, 0);
            }
        }
            break;
        default:
            break;
    }
    
    return headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    CGSize headerSize = CGSizeMake(0, 0);
    return headerSize;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        switch (indexPath.section) {
            case GroupTitle:{
                
                BookDetailTitleView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookDetailTitleView" forIndexPath:indexPath];
                headerView.delegate = self;
                [headerView setDataForView:self.bookCurr];
                reusableview = headerView;
            }
                break;
            case GroupUserInfo:{
                
                BookSellerView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookSellerView" forIndexPath:indexPath];
                headerView.delegate = self;
                [headerView setDataForView:self.bookCurr.user];
                reusableview = headerView;
            }
                break;
            case GroupContent:{
                
                BookContentView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookContentView" forIndexPath:indexPath];
                headerView.delegate = self;
                [headerView setDataForView:self.bookCurr.descriptionStr isExpand:isExpand isShowExpand:isShowExpand];
                reusableview = headerView;
            }
                break;
            case GroupRelation:{
                
                BookView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookView" forIndexPath:indexPath];
                [headerView.viewReadMore setHidden:YES];
                headerView.delegate = self;
                if(self.arrRelated.count > 0){
                    
                    [headerView setDataForView:self.arrRelated title:@"Có thể bạn quan tâm"];
                    
                }
                reusableview = headerView;
            }
                break;
            default:
                break;
        }
    }
    
    return reusableview;
}

#pragma mark - BookViewDelegate
- (void)selectedItemBook:(Book *)book{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookDetailViewController *vcBookImage = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
    vcBookImage.bookCurr = book;
    [self.navigationController pushViewController:vcBookImage animated:YES];
}

#pragma mark - BookContentViewDelegate

- (void)selectedBtnExpand{
    
    isExpand = !isExpand;
    
    [self.cllBookDetail reloadSections:[NSIndexSet indexSetWithIndex:GroupContent]];
}

#pragma mark - BookDetailTitleViewDelegate
- (void)selectedImage:(Image *)imgSelected{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookImageViewController *vcBookImage = [storyboard instantiateViewControllerWithIdentifier:@"BookImageViewController"];
    vcBookImage.bookName = self.bookCurr.name;
    vcBookImage.arrImages = self.bookCurr.images;
    vcBookImage.indexCurr = [self.bookCurr.images indexOfObject:imgSelected];
    [self presentViewController:vcBookImage animated:YES completion:nil];
}

#pragma mark - BookSellerViewDelegate
- (void)touchCall{
    
    NSString *phoneNumber = [@"tel://" stringByAppendingString:self.bookCurr.user.phone];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]]) {
        // Check if iOS Device supports phone calls
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        NSString *mnc = [carrier mobileNetworkCode];
        // User will get an alert error when they will try to make a phone call in airplane mode.
      
        if (([mnc length] == 0)) {
            
            [Common showAlert:self title:@"Thông báo" message:@"Máy bận vui lòng gọi lại sau" buttonClick:nil];
            
        } else {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
    } else {
        
        [Common showAlert:self title:@"Thông báo" message:@"Thiết bị của bạn không hỗ trợ chức năng này" buttonClick:nil];
    }
    
}

- (void)touchSMS{
    
    if([MFMessageComposeViewController canSendText]) {
        
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.body = @"";
        controller.recipients = @[self.bookCurr.user.phone];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else{
        
        [Common showAlert:self title:@"Thông báo" message:@"Thiết bị của bạn không hỗ trợ chức năng này" buttonClick:nil];
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end

//
//  SearchBookViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/9/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "SearchBookViewController.h"
#import "UIColor+HexString.h"
#import "SearchBookCell.h"
#import "Book.h"
#import "CategoriesViewController.h"
#import "Categories.h"
#import <CoreLocation/CoreLocation.h>
#import "BookDetailViewController.h"
#import "StatusBookViewController.h"
#import "PriceSortViewControler.h"

#define HEIGHT_EXPAND 240
#define HEIGHT_DEFAULT 50

typedef NS_ENUM(NSInteger, SearchWith) {
    
    NameType,
    SellerType,
    AuthorType
};

@interface SearchBookViewController ()<CLLocationManagerDelegate>{
    
    NSInteger indexPage;
    
    float lat;
    float lng;
    
    NSString *seller;
    NSString *author;
    NSString *name;
    
    NSString *categoryID;
  
    NSInteger typeSearch;
    
    BOOL isLoadingData;
    BOOL isFullData;
    
    CLLocationManager *localManager;
    
    UIRefreshControl *refreshControl;
    
    NSString *strStatus;
    NSString *strPrice;
}

@property (weak, nonatomic) IBOutlet UIButton *btnSeller;
@property (weak, nonatomic) IBOutlet UIButton *btnAuthor;
@property (weak, nonatomic) IBOutlet UIButton *btnBookName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraintOption;
@property (weak, nonatomic) IBOutlet UIView *viewOption;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnExpand;
@property (weak, nonatomic) IBOutlet UICollectionView *cllBook;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIButton *btnNearly;

@property (weak, nonatomic) IBOutlet UILabel *lblCategories;

@property (nonatomic, strong) NSMutableArray *arrSearchBook;
@property (nonatomic, strong) NSMutableArray *arrSearchResult;
@property (weak, nonatomic) IBOutlet UITextField *tfSeach;

@property (weak, nonatomic) IBOutlet UIButton *btnBookStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnSortPrice;


@end

@implementation SearchBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrSearchBook = [NSMutableArray array];
    
    [self configUI];
    
    [self configDefault];
    
    [self getListBookWithKey:@"" isShowHud:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBackground:(id)sender {
    
    [self.btnExpand setSelected:NO];
    
     [self hideViewOptionSearch];
}


- (IBAction)touchBtnNearLy:(id)sender {
    
    [self.btnNearly setSelected:!self.btnNearly.selected];
    
    if (self.btnNearly.selected) {
        
        if(!localManager){
            
            localManager = [[CLLocationManager alloc] init];
            
            localManager.delegate = self;
            localManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        }
        
        
        if([localManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            
            [localManager requestWhenInUseAuthorization];
            
            [localManager startUpdatingLocation];
        }
        
        
    } else {
        
        lat = 0;
        lng = 0;
    }
    
}
- (IBAction)touchBtnPrice:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PriceSortViewControler *vcPrice = [storyboard instantiateViewControllerWithIdentifier:@"PriceSortViewControler"];
    
    vcPrice.delegate = self;
    [vcPrice presentInParentViewController:self];
}

- (IBAction)touchBtnBook:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StatusBookViewController *vcStatus = [storyboard instantiateViewControllerWithIdentifier:@"StatusBookViewController"];
    vcStatus.arrStatus = @[@"Tất cả", @"Sách mới", @"Sách cũ 90%", @"Sách cũ 70%", @"Sách cũ 50%"];
    vcStatus.delegate = self;
    [vcStatus presentInParentViewController:self];
    
}

- (IBAction)touchBtnWithName:(id)sender {
    
    if(typeSearch == NameType){
        
        return;
    }
    
    
    typeSearch = NameType;
    
    self.tfSeach.placeholder = @"Nhập tên sách...";
    [self changeButtonDefault];

    [self changeBtnWithButtonCurr:sender];
}
- (IBAction)touchBtnWithSeller:(id)sender {
    
    if(typeSearch == SellerType){
        
        return;
    }
    
    typeSearch = SellerType;
    
    self.tfSeach.placeholder = @"Nhập tên người bán...";
    [self changeButtonDefault];

    [self changeBtnWithButtonCurr:sender];

}
- (IBAction)touchBtnWithAuthor:(id)sender {
    
    if(typeSearch == AuthorType){
        
        return;
    }
    
    typeSearch = AuthorType;
    
    self.tfSeach.placeholder = @"Nhập tên tác giả...";
    
    [self changeButtonDefault];
    
    [self changeBtnWithButtonCurr:sender];
}


- (IBAction)touchBtnSearch:(id)sender {
    
    indexPage = 1;
    [self searchBook:self.tfSeach.text];
}

- (IBAction)touchBtnCategories:(id)sender {
    
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoriesViewController *vcCategories = [mystoryboard instantiateViewControllerWithIdentifier:@"CategoriesViewController"];
    vcCategories.delegate = self;
    [vcCategories presentInParentViewController:self];
}

- (IBAction)touchBtnClose:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)touchBtnExpand:(id)sender {
    
    [self.btnExpand setSelected:!self.btnExpand.selected];
    
    if(self.btnExpand.selected){
        
        [self showViewOptionSearch];
    }
    else{
        
        [self hideViewOptionSearch];
    }
}

- (void)showViewOptionSearch{
    
    self.heightContraintOption.constant = HEIGHT_EXPAND;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
        self.viewOption.alpha = 1.0;
        self.viewBackground.alpha = 1.0;
    } completion:nil];
    
}

- (void)hideViewOptionSearch{
    
    self.heightContraintOption.constant = HEIGHT_DEFAULT;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
        self.viewOption.alpha = 0.0;
        self.viewBackground.alpha = 0.0;
        
    } completion:nil];
}

#pragma mark - Call API

- (void)getListBookWithKey:(NSString *)keyword isShowHud:(BOOL)isShowHUD{
    
    [self setKeywordWithType:keyword];
    
    NSString *url = @"";
    
    if(lat == 0 && lng == 0){
        
        url = [NSString stringWithFormat:@"%@?limit=%@&page=%@&name=%@&seller=%@&author=%@&category=%@",GET_BOOK_NEARLY,@(LIMIT_ITEM),@(indexPage),name,seller,author,categoryID];
    }
    else{
        
        url = [NSString stringWithFormat:@"%@?limit=%@&page=%@&lat=%f&lng=%f&name=%@&seller=%@&author=%@&category=%@",GET_BOOK_NEARLY,@(LIMIT_ITEM),@(indexPage),lat,lng,name,seller,author,categoryID];
    }
    
    if(isShowHUD){
        
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
   
    
    isLoadingData = YES;
    
    [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,url] withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        isLoadingData = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Book *book = [[Book alloc] initWithDictionary:dic error:&error];
                book.descriptionStr = [dic objectForKey:@"description"];
                [self.arrSearchBook addObject:book];
                
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            if(self.arrSearchBook.count > 0){
                
                self.arrSearchResult = [NSMutableArray arrayWithArray:self.arrSearchBook];
                [self.cllBook reloadData];
            }
            
        }
        
    }];
}

- (void)searchBook:(NSString *)keywork{
   
    isFullData = NO;
    
    if(self.btnExpand.selected){
        
        self.btnExpand.selected = NO;
        
        [self hideViewOptionSearch];
    }
    
    [self setKeywordWithType:keywork];
    
    NSString *url = @"";
    
    if(lat == 0 && lng == 0){
        
         url = [NSString stringWithFormat:@"%@?limit=%@&page=%@&name=%@&seller=%@&author=%@&category=%@",GET_BOOK_NEARLY,@(LIMIT_ITEM),@(indexPage),name,seller,author,categoryID];
    }
    else{
        
        url = [NSString stringWithFormat:@"%@?limit=%@&page=%@&lat=%f&lng=%f&name=%@&seller=%@&author=%@&category=%@",GET_BOOK_NEARLY,@(LIMIT_ITEM),@(indexPage),lat,lng,name,seller,author,categoryID];
    }
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,url] withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        strStatus = @"Tất cả";
        strPrice = @"Mặc định";
        
        [self.btnBookStatus setTitle:strStatus forState:UIControlStateNormal];
        [self.btnSortPrice setTitle:strPrice forState:UIControlStateNormal];
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            [self.arrSearchBook removeAllObjects];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Book *book = [[Book alloc] initWithDictionary:dic error:&error];
                book.descriptionStr = [dic objectForKey:@"description"];
                [self.arrSearchBook addObject:book];
                
            }
            
            self.arrSearchResult = [NSMutableArray arrayWithArray:self.arrSearchBook];
            [self.cllBook reloadData];
            
        }
        
        [refreshControl endRefreshing];
    }];
    
}

#pragma mark - Method

- (void)refreshTable{
    
    indexPage = 1;
    self.tfSeach.text = @"";
    
    [self performSelector:@selector(searchBook:) withObject:self.tfSeach.text afterDelay:1.0f];
    
    
}

- (void)filterWithStatusBook{
    
    NSMutableArray *arrResult;
    
    if([strStatus isEqualToString:@"Tất cả"]){
        
        arrResult = [NSMutableArray arrayWithArray:self.arrSearchBook];
    }
    else{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subStatus contains[cd] %@", strStatus];
        // NSLog(@"%@",textField.text);
        
       // self.arrSearchResult = nil;
        arrResult = [NSMutableArray arrayWithArray: [self.arrSearchBook filteredArrayUsingPredicate:predicate]];
    }
  
    if([strPrice isEqualToString:@"Mặc định"]){
        
        self.arrSearchResult = arrResult;
    }
    else{
        
        if([strPrice isEqualToString:@"Thấp đến cao"]){
            
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
                                                         ascending:YES];
            self.arrSearchResult = [NSMutableArray arrayWithArray:[arrResult sortedArrayUsingDescriptors:@[sortDescriptor]]];
        }
        else{
            
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
                                                         ascending:NO];
            self.arrSearchResult = [NSMutableArray arrayWithArray:[arrResult sortedArrayUsingDescriptors:@[sortDescriptor]]];
        }
    }
    
   
    
    [self.cllBook reloadData];
    
}

- (void)changeBtnWithButtonCurr:(UIButton *)btn{
    
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)changeButtonDefault{
    
    self.tfSeach.text = @"";
    
    [self.btnAuthor setBackgroundColor:[UIColor whiteColor]];
    [self.btnAuthor setTitleColor:[UIColor colorWithHexString:@"#1CB8FF"] forState:UIControlStateNormal];
    
    [self.btnBookName setBackgroundColor:[UIColor whiteColor]];
    [self.btnBookName setTitleColor:[UIColor colorWithHexString:@"#1CB8FF"] forState:UIControlStateNormal];
    
    [self.btnSeller setBackgroundColor:[UIColor whiteColor]];
    [self.btnSeller setTitleColor:[UIColor colorWithHexString:@"#1CB8FF"] forState:UIControlStateNormal];
    
}

- (void)setKeywordWithType:(NSString *)keyword{
    
    switch (typeSearch) {
        case NameType:{
            
            name = keyword;
            author = @"";
            seller = @"";
        }
            
            break;
        case SellerType:{
            
            name = @"";
            author = @"";
            seller = keyword;
        }
            
            break;
        case AuthorType:{
            
            name = @"";
            author = keyword;
            seller = @"";
        }
            
            break;
            
        default:
            break;
    }
}

- (void)configDefault{
    
    typeSearch = NameType;
    self.tfSeach.placeholder = @"Nhập tên Sách...";
    
    name = @"";
    author = @"";
    seller = @"";
    categoryID = @"";
    
   // self.arrStatusBook = @[@"Tất cả", @"Sách mới", @"Sách cũ 90%", @"Sách cũ 70%", @"Sách cũ 50%"];
    
   // self.arrPriceBook = @[@"Mặc định",@"Thấp đến cao", @"Cao đến thấp"];
}

- (void)configUI{
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.cllBook addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.viewBackground.alpha = 0.0f;
    

    strStatus = @"Tất cả";
    strPrice = @"Mặc định";
    
    [self.btnBookStatus setTitle:strStatus forState:UIControlStateNormal];
    
    
    [self.btnSortPrice setTitle:strPrice forState:UIControlStateNormal];
    
    indexPage = 1;
    
    self.btnBookName.layer.borderColor = [UIColor colorWithHexString:@"1CB8FF"].CGColor;
    ;
    self.btnBookName.layer.borderWidth = 0.3;
    
    self.btnAuthor.layer.borderColor = [UIColor colorWithHexString:@"1CB8FF"].CGColor;
    self.btnAuthor.layer.borderWidth = 0.3;
    
    self.btnSeller.layer.borderColor = [UIColor colorWithHexString:@"1CB8FF"].CGColor;
    self.btnSeller.layer.borderWidth = 0.3;
    
    self.heightContraintOption.constant = HEIGHT_DEFAULT;
    self.viewOption.alpha = 0;
    
    [self.cllBook registerNib:[UINib nibWithNibName:@"SearchBookCell" bundle:nil] forCellWithReuseIdentifier:@"SearchBookCell"];
    
}
#pragma mark - UICollectionViewDataSource - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrSearchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchBookCell" forIndexPath:indexPath];
    
    Book *book = [self.arrSearchResult objectAtIndex:indexPath.row];
    
    [cell setDataForCell:book];
   
    if(indexPath.row == self.arrSearchResult.count - 1 && !isLoadingData &&!isFullData){
        
        indexPage ++;
        [self getListBookWithKey:self.tfSeach.text isShowHud:NO];
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (SW - 24*3)/2;
    
    CGFloat height = 0;
  
    float ratio = (float)172/(float)126;
   
    height  = width *ratio + 76;
    
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 24, 0, 24);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Book *book = [self.arrSearchResult objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookDetailViewController *vcBookDetail = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
    vcBookDetail.bookCurr = book;
    [self.navigationController pushViewController:vcBookDetail animated:YES];
}

#pragma mark - CategoriesViewControllerDelegate
- (void)selectedCategories:(Categories *)cat{
    
    if([cat.name isEqualToString:@"Tất cả"]){
        
        categoryID = @"";
    }
    else{
        
        categoryID = cat.id.stringValue;
    }
    
    self.lblCategories.text = cat.name;
    
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    indexPage = 1;
    
    [self searchBook:textField.text];
    
    return YES;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        lat = currentLocation.coordinate.latitude;
        lng = currentLocation.coordinate.longitude;
    }
    
    // Stop Location Manager
    [localManager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    // NSLog(@"%@",error.userInfo);
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied){
            
            [self.btnNearly setImage:[UIImage imageNamed:@"btn_checkbox_none"] forState:UIControlStateNormal];
            
            [Common showAlert:self title:@"Thông báo" message:@"Bạn chưa mở định vị toạ độ" buttonClick:nil];
        }
    }
}

#pragma mark - StatusBookViewControllerDelegate
- (void)selectedStatusBook:(NSString *)status{
    
    strStatus = status;
    
    [self.btnBookStatus setTitle:status forState:UIControlStateNormal];
    
    [self performSelector:@selector(filterWithStatusBook) withObject:nil afterDelay:0.0];
}

#pragma mark - PriceSortViewControlerDelegate
- (void)selectedPriceBook:(NSString *)price{
    
    strPrice = price;
    
    [self.btnSortPrice setTitle:price forState:UIControlStateNormal];
    
    [self performSelector:@selector(filterWithStatusBook) withObject:nil afterDelay:0.0];
}

@end

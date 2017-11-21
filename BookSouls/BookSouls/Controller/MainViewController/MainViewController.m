//
//  MainViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "MainViewController.h"
#import "WellcomeView.h"
#import "Book.h"
#import "BookNewView.h"
#import "BookView.h"
#import "BookCategoriesView.h"
#import "Categories.h"
#import "SellerView.h"
#import "SearchBookViewController.h"
#import "BookDetailViewController.h"
#import "CreateBookViewController.h"
#import "BookAllViewController.h"


#define NUM_GROUP 5
#define MARGIN 24

#define HEIGHT_WELLCOME 124
#define HEIGHT_BOOK_NEW 284
#define HEIGHT_CATEGORIES 120
#define HEIGHT_SELLER 170


typedef NS_ENUM(NSInteger, GroupBook) {
    
    Wellcome = 0,
    NewBook,
    HotBook,
    CategoriesBook,
    Seller
};

@interface MainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>{
    
    NSInteger indexPage;
}

@property (weak, nonatomic) IBOutlet UICollectionView *cllMain;
@property (nonatomic, strong) NSMutableArray *arrListBookNew;
@property (nonatomic, strong) NSMutableArray *arrListBookHot;
@property (nonatomic, strong) NSMutableArray *arrCategories;
@property (nonatomic, strong) NSMutableArray *arrSeller;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getListNewBook];
    
    [self getlistHotBook];
    
    [self getListCategories];
    
    [self getListBestSeller];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBtnCreateBook:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateBookViewController *vcCreateBook = [storyboard instantiateViewControllerWithIdentifier:@"CreateBookViewController"];
    vcCreateBook.strTitle = @"Đăng sách";
    vcCreateBook.btnTitle = @"Đăng sách";
    [self.navigationController pushViewController:vcCreateBook animated:YES];

}
- (IBAction)touchBtnMenu:(id)sender {
    
    [[SlideMenuViewController sharedInstance] toggle];
}

- (IBAction)touchBtnSearch:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchBookViewController *vcSearch = [storyboard instantiateViewControllerWithIdentifier:@"SearchBookViewController"];
    
    [self.navigationController pushViewController:vcSearch animated:YES];
}

#pragma mark - Call API

- (void)getListBestSeller{
    
    [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,GET_BEST_SELLER] withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            self.arrSeller = [NSMutableArray array];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                UserInfo *user = [[UserInfo alloc] initWithDictionary:dic error:&error];
                
                [self.arrSeller addObject:user];
                
            }
            
            if(self.arrSeller.count > 0){
                
                [self.cllMain reloadSections:[NSIndexSet indexSetWithIndex:Seller]];
            }
            
        }
        
    }];
    
}

- (void)getListCategories{
    
    if(!Appdelegate_BookSouls.arrCategories.count){
        
        [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,GET_BOOK_CATEGORIES] withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if(isError){
                
                [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
            }
            else{
                
                NSArray *arrData = [responseDataObject objectForKey:@"result"];
                
                self.arrCategories = [NSMutableArray array];
                
                for(NSDictionary *dic in arrData){
                    
                    NSError *error;
                    
                    Categories *cat = [[Categories alloc] initWithDictionary:dic error:&error];
                    
                    [self.arrCategories addObject:cat];
                    
                }
                
                if(self.arrCategories.count > 0){
                    
                    Appdelegate_BookSouls.arrCategories = self.arrCategories;
                    [self.cllMain reloadSections:[NSIndexSet indexSetWithIndex:CategoriesBook]];
                }
                
            }
            
        }];
    }
    else{
        
        self.arrCategories = Appdelegate_BookSouls.arrCategories;
        
        if(self.arrCategories.count > 0){
            
             [self.cllMain reloadSections:[NSIndexSet indexSetWithIndex:CategoriesBook]];
        }
    }

}

- (void)getlistHotBook{
    
    NSString *url = [NSString stringWithFormat:@"%@?limit=%@&page=%@",GET_BOOK_POPULAR,@(LIMIT_ITEM),@(indexPage)];
    
    [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,url] withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            self.arrListBookHot = [NSMutableArray array];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Book *book = [[Book alloc] initWithDictionary:dic error:&error];
                
                [self.arrListBookHot addObject:book];
                
            }
            
            if(self.arrListBookHot.count > 0){
                
                [self.cllMain reloadSections:[NSIndexSet indexSetWithIndex:HotBook]];
            }
            
        }
        
    }];
}

- (void)getListNewBook{
    
    NSString *url = [NSString stringWithFormat:@"%@?limit=%@&page=%@",GET_BOOK_NEW,@(LIMIT_ITEM),@(indexPage)];
    
    [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,url] withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            self.arrListBookNew = [NSMutableArray array];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Book *book = [[Book alloc] initWithDictionary:dic error:&error];
                
                [self.arrListBookNew addObject:book];
                
            }
            
            if(self.arrListBookNew.count > 0){
                
                [self.cllMain reloadSections:[NSIndexSet indexSetWithIndex:NewBook]];
            }
            
        }
        
    }];
    
}

#pragma mark - Method

- (void)configUI{
    
    indexPage = 1;
    
    [self.cllMain registerNib:[UINib nibWithNibName:@"WellcomeView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WellcomeView"];
    
    [self.cllMain registerNib:[UINib nibWithNibName:@"BookNewView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookNewView"];
    
    [self.cllMain registerNib:[UINib nibWithNibName:@"BookView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookView"];
    
    [self.cllMain registerNib:[UINib nibWithNibName:@"SellerView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SellerView"];
    
     [self.cllMain registerNib:[UINib nibWithNibName:@"BookCategoriesView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookCategoriesView"];
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
        case Wellcome:{
            
            float height = SW *136/360;
            // headerSize = CGSizeMake(SW, height + 104);
             headerSize = CGSizeMake(SW, height);
        }
           
            break;
        case NewBook:{
            
            if(self.arrListBookNew.count > 0){
                
                headerSize = CGSizeMake(SW, HEIGHT_BOOK_NEW);
            }
            else{
                
                headerSize = CGSizeMake(0, 0);
            }
        }
            break;
        case HotBook:{
            
            if(self.arrListBookNew.count > 0){
                
                headerSize = CGSizeMake(SW, HEIGHT_BOOK_NEW);
            }
            else{
                
                headerSize = CGSizeMake(0, 0);
            }
        }
            break;
        case CategoriesBook:{
            
            if(self.arrCategories.count > 0){
                
                headerSize = CGSizeMake(SW, HEIGHT_CATEGORIES);
            }
            else{
                
                headerSize = CGSizeMake(0, 0);
            }
        }
            break;
        case Seller:{
            
            if(self.arrSeller.count > 0){
                
                headerSize = CGSizeMake(SW, HEIGHT_SELLER);
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
            case Wellcome:{
                
                WellcomeView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WellcomeView" forIndexPath:indexPath];
                reusableview = headerView;
            }
                break;
            case NewBook:{
                
                 BookNewView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookNewView" forIndexPath:indexPath];
                headerView.delegate = self;
                if(self.arrListBookNew.count > 0){
                    
                    [headerView setDataForView:self.arrListBookNew];
                  
                }
                 reusableview = headerView;
            }
                break;
            case HotBook:{
                
                  BookView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookView" forIndexPath:indexPath];
                headerView.delegate = self;
                if(self.arrListBookHot.count > 0){
                
                    [headerView setDataForView:self.arrListBookHot title:@"Sách bán chạy"];
                    
                }
                
                reusableview = headerView;
            }
                break;
            case CategoriesBook:{
                
                BookCategoriesView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BookCategoriesView" forIndexPath:indexPath];
                
                if(self.arrCategories.count > 0){
                    
                    [headerView setDataForView:self.arrCategories];
                   
                }
                
                 reusableview = headerView;
            }
                break;
            case Seller:{
                
                 SellerView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SellerView" forIndexPath:indexPath];
                
                if(self.arrCategories.count > 0){
                    
                    [headerView setDataForView:self.arrSeller];
                    
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == NewBook){
        
        Book *book = [self.arrListBookNew objectAtIndex:indexPath.row];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BookDetailViewController *vcBookDetail = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
        vcBookDetail.bookCurr = book;
        [self.navigationController pushViewController:vcBookDetail animated:YES];
    }
    else if(indexPath.section == HotBook){
        
        Book *book = [self.arrListBookHot objectAtIndex:indexPath.row];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BookDetailViewController *vcBookDetail = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
        vcBookDetail.bookCurr = book;
        [self.navigationController pushViewController:vcBookDetail animated:YES];
    }
   
}
#pragma mark - BookNewViewDelegate

- (void)readMoreBookNew{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookAllViewController *vcBookAll = [storyboard instantiateViewControllerWithIdentifier:@"BookAllViewController"];
    vcBookAll.typeBook = 0;
    vcBookAll.strTitle = @"Sách mới";
    [self.navigationController pushViewController:vcBookAll animated:YES];
}

- (void)selectedItemBookNew:(Book *)book{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookDetailViewController *vcBookDetail = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
    vcBookDetail.bookCurr = book;
    [self.navigationController pushViewController:vcBookDetail animated:YES];
}

#pragma mark - BookViewDelegate

- (void)readMoreBookHot{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookAllViewController *vcBookAll = [storyboard instantiateViewControllerWithIdentifier:@"BookAllViewController"];
    vcBookAll.typeBook = 1;
    vcBookAll.strTitle = @"Sách bán chạy";
    [self.navigationController pushViewController:vcBookAll animated:YES];
}
- (void)selectedItemBook:(Book *)book{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookDetailViewController *vcBookDetail = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
    vcBookDetail.bookCurr = book;
    [self.navigationController pushViewController:vcBookDetail animated:YES];
    
}
@end

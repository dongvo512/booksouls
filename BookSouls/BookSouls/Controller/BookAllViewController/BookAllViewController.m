//
//  BookAllViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/17/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookAllViewController.h"
#import "SearchBookCell.h"
#import "BookDetailViewController.h"
#import "Book.h"
#import "CategoriesViewController.h"
#import "Categories.h"
#import "StatusBookViewController.h"



#define HEIGHT_APEND_OPTION 200

typedef NS_ENUM(NSInteger, PriceSort) {
    
    LowToHight,
    HightToLow
};

typedef NS_ENUM(NSInteger, TypeBook) {
   
    TypeBookNew,
    TypeBookHot
};

@interface BookAllViewController (){
    
    BOOL isLoadingData;
    BOOL isFullData;
    
    NSInteger indexPage;
    
    UIRefreshControl *refreshControl;
    
    NSString *categoryID;
    
    NSInteger indexSort;
    
}
@property (weak, nonatomic) IBOutlet UIView *viewBackground;

@property (nonatomic, strong) NSMutableArray *arrSearchBook;
@property (nonatomic, strong) NSMutableArray *arrSearchResult;
@property (weak, nonatomic) IBOutlet UICollectionView *cllBook;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *viewOption;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraintOption;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
@property (weak, nonatomic) IBOutlet UILabel *lblCategories;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnLowToHight;
@property (weak, nonatomic) IBOutlet UIButton *btnHightToLow;

@end

@implementation BookAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    indexPage = 1;
    self.arrSearchBook = [NSMutableArray array];
    
    
    if(self.typeBook == TypeBookNew){
        
        [self getListNewBook:YES];
    }
    else if(self.typeBook == TypeBookHot){
        
        [self getlistHotBook:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBackground:(id)sender {
    
    [self hideViewOptionSearch];
    
    [self.btnFilter setSelected:NO];
}
- (IBAction)touchBtnHightToLow:(id)sender {
    
    [self.btnLowToHight setSelected:NO];
    [self.btnHightToLow setSelected:YES];
    
    indexSort = HightToLow;
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
                                                 ascending:NO];
    
    self.arrSearchResult = [NSMutableArray arrayWithArray:[self.arrSearchResult sortedArrayUsingDescriptors:@[sortDescriptor]]];
    
     [self.cllBook reloadData];
}

- (IBAction)touchBtnLowToHight:(id)sender {
    
    indexSort = LowToHight;
    [self.btnLowToHight setSelected:YES];
    [self.btnHightToLow setSelected:NO];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
                                                 ascending:YES];
    self.arrSearchResult = [NSMutableArray arrayWithArray:[self.arrSearchResult sortedArrayUsingDescriptors:@[sortDescriptor]]];
    
     [self.cllBook reloadData];
}
- (IBAction)touchBtnStatus:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    StatusBookViewController *vcStatus = [storyboard instantiateViewControllerWithIdentifier:@"StatusBookViewController"];
    vcStatus.delegate = self;
    [vcStatus presentInParentViewController:self];
}
- (IBAction)touchBtnCategories:(id)sender {
    
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoriesViewController *vcCategories = [mystoryboard instantiateViewControllerWithIdentifier:@"CategoriesViewController"];
    vcCategories.delegate = self;
    [vcCategories presentInParentViewController:self];
}
- (IBAction)touchBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)touchBtnFilter:(id)sender {
    
    [self.btnFilter setSelected:!self.btnFilter.selected];
    
    if(self.btnFilter.selected){
        
        [self showViewOptionSearch];
    }
    else{
        
        [self hideViewOptionSearch];
    }
}
#pragma mark - Cal API

- (void)refreshNewBook{
    
    NSString *url = [NSString stringWithFormat:@"%@?limit=%@&page=%@",GET_BOOK_NEW,@(LIMIT_ITEM),@(indexPage)];
    
    isLoadingData = YES;
    
    [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,url] withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        isLoadingData = NO;
        
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
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            self.arrSearchResult = self.arrSearchBook;
            [refreshControl endRefreshing];
            [self.cllBook reloadData];
        }
        
    }];
    
}

- (void)refreshHotBook{
    
    NSString *url = [NSString stringWithFormat:@"%@?limit=%@&page=%@",GET_BOOK_POPULAR,@(LIMIT_ITEM),@(indexPage)];
    
    isLoadingData = YES;
    
    [APIRequestHandler initWithURLString:[NSString stringWithFormat:@"%@%@",URL_DEFAULT,url] withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        isLoadingData = NO;
        
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
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            self.arrSearchResult = self.arrSearchBook;
            [refreshControl endRefreshing];
            [self.cllBook reloadData];
            
        }
        
    }];
    
}

- (void)getlistHotBook:(BOOL)isShowHUD{
    
    if(isShowHUD){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?limit=%@&page=%@",GET_BOOK_POPULAR,@(LIMIT_ITEM),@(indexPage)];
    
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
            
            self.arrSearchResult = self.arrSearchBook;
            [self.cllBook reloadData];
            
        }
        
    }];
}

- (void)getListNewBook:(BOOL)isShowHUD{
    
    NSString *url = [NSString stringWithFormat:@"%@?limit=%@&page=%@",GET_BOOK_NEW,@(LIMIT_ITEM),@(indexPage)];
    
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
            
            self.arrSearchResult = self.arrSearchBook;
            [self.cllBook reloadData];
        }
        
    }];
    
}

#pragma mark - Method

- (void)filterBook{
    
  
    NSArray *arrSearch;
    
    if(![self.lblCategories.text isEqualToString:@"Tất cả"]){
        
        NSPredicate *preNameCat = [NSPredicate predicateWithFormat:@"categoryId == %@", categoryID];
        arrSearch = [self.arrSearchBook filteredArrayUsingPredicate:preNameCat];
        
    }
    else{
        
        arrSearch = self.arrSearchBook;
    }
    
    
    if(![self.lblStatus.text isEqualToString:@"Tất cả"]){
        
        NSPredicate *predicateStatus = [NSPredicate predicateWithFormat:@"subStatus contains[cd] %@", self.lblStatus.text];
        arrSearch = [arrSearch filteredArrayUsingPredicate:predicateStatus];
    }
    
    if(indexSort != -1){
        
        if(indexSort == LowToHight){
            
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
                                                         ascending:YES];
            arrSearch = [NSMutableArray arrayWithArray:[arrSearch sortedArrayUsingDescriptors:@[sortDescriptor]]];
        }
        else{
            
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
                                                         ascending:NO];
            
            arrSearch = [NSMutableArray arrayWithArray:[arrSearch sortedArrayUsingDescriptors:@[sortDescriptor]]];
        }
    }
    
    
    self.arrSearchResult = (NSMutableArray *)arrSearch;
    
    [self.cllBook reloadData];
    
}

- (void)showViewOptionSearch{
    
    self.heightContraintOption.constant = HEIGHT_APEND_OPTION;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
        self.viewOption.alpha = 1.0;
        self.viewBackground.alpha = 1.0;
    } completion:nil];
    
}
- (void)hideViewOptionSearch{
    
    self.heightContraintOption.constant = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
        self.viewOption.alpha = 0.0;
        self.viewBackground.alpha = 0.0;
        
    } completion:nil];
}

- (void)configUI{
    
    self.lblTitle.text = self.strTitle;
    
    [self.cllBook registerNib:[UINib nibWithNibName:@"SearchBookCell" bundle:nil] forCellWithReuseIdentifier:@"SearchBookCell"];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.cllBook addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self.btnLowToHight setSelected:NO];
    [self.btnHightToLow setSelected:NO];
    
    categoryID = @"";
    indexSort = -1;
    
}

- (void)refreshTable{
    
    indexPage = 1;
    self.lblCategories.text = @"Tất cả";
    self.lblStatus.text = @"Tất cả";
    
    categoryID = @"";
    indexSort = -1;
    
    
    [self.btnHightToLow setSelected:NO];
    [self.btnLowToHight setSelected:NO];
    

    if(self.typeBook == TypeBookNew){
        
        [self performSelector:@selector(refreshNewBook) withObject:nil afterDelay:1.0f];
    }
    else if(self.typeBook == TypeBookHot){
        
         [self performSelector:@selector(refreshHotBook) withObject:nil afterDelay:1.0f];
    }
}

- (void)refeshListBookHot{
    
    [self getlistHotBook:NO];
}

- (void)refeshListBookNew{
    
    [self getListNewBook:NO];
}

#pragma mark - StatusBookViewControllerDelegate
- (void)selectedStatusBook:(NSString *)status{
    
    if([status isEqualToString:self.lblStatus.text]){
        
        return;
    }
    
    if(status){
        
        self.lblStatus.text = status;
        
    }
    
    [self performSelector:@selector(filterBook) withObject:nil afterDelay:0.0f];
}

#pragma mark - CategoriesViewControllerDelegate
- (void)selectedCategories:(Categories *)cat{
    
    if([cat.id.stringValue isEqualToString:categoryID]){
        
        return;
    }
    
    if([cat.name isEqualToString:@"Tất cả"]){
        
        categoryID = @"";
    }
    else{
        
        categoryID = cat.id.stringValue;
    }
    
    self.lblCategories.text = cat.name;
    
    [self performSelector:@selector(filterBook) withObject:nil afterDelay:0.0f];
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
        
        if(self.typeBook == TypeBookNew){
            
            [self getListNewBook:NO];
        }
        else{
            
             [self getlistHotBook:NO];
        }

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

@end

//
//  MyBookViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/20/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "MyBookViewController.h"
#import "UIColor+HexString.h"
#import "StatusBookViewController.h"
#import "CategoriesViewController.h"
#import "SearchBookCell.h"
#import "BookDetailViewController.h"
#import "Book.h"
#import "Categories.h"
#import "CreateBookViewController.h"

#define HEIGHT_APEND_OPTION 200

typedef NS_ENUM(NSInteger, PriceSort) {
    
    LowToHight,
    HightToLow
};

typedef NS_ENUM(NSInteger, TypeBook) {
    
    TypeBookNew,
    TypeBookHot
};

typedef NS_ENUM(NSInteger, SelectedButton) {
    
    Selling,
    BookEnd
};

@interface MyBookViewController (){
    
    NSInteger indexSort;
    
    NSInteger indexSelected;
    
    NSInteger indexPage;
    
    BOOL isLoadingData;
    BOOL isFullData;
    
    UIRefreshControl *refreshControl;
    
    NSString *categoryID;
}
@property (weak, nonatomic) IBOutlet UIView *viewTab;
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
@property (weak, nonatomic) IBOutlet UIView *viewSubSelling;
@property (weak, nonatomic) IBOutlet UIView *viewSubBookEnd;
@property (weak, nonatomic) IBOutlet UIButton *btnSelling;
@property (weak, nonatomic) IBOutlet UIButton *btnBookEnd;


@end

@implementation MyBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrSearchBook = [NSMutableArray array];
    
    [self configUI];
    
    [self getListBookSelling:@(1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Action

- (IBAction)touchBtnMenu:(id)sender {
    
    [[SlideMenuViewController sharedInstance] toggle];
}

- (IBAction)touchBtnBookEnd:(id)sender {
    
    if(indexSelected != BookEnd){
        
        indexSelected = BookEnd;
        indexPage = 1;
        isFullData = NO;
        
        [self.arrSearchBook removeAllObjects];
        
        [self.btnBookEnd setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.viewSubBookEnd setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.btnBookEnd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnBookEnd.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        
        [self.btnSelling setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
        [self.viewSubSelling setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
        [self.btnSelling setTitleColor:[UIColor colorWithHexString:@"#1C2D51"] forState:UIControlStateNormal];
        [self.btnSelling.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14.0]];
       
        [self setDafaultOptionFilter];
        [self getListBookSelling:@(1)];
    }
   
}
- (IBAction)touchBookSelling:(id)sender {
    
    if(indexSelected != Selling){
        
        indexSelected = Selling;
        indexPage = 1;
        isFullData = NO;
        [self.arrSearchBook removeAllObjects];
        
        [self.btnSelling setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.viewSubSelling setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.btnSelling setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnSelling.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:14.0]];
        
        [self.btnBookEnd setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
        [self.viewSubBookEnd setBackgroundColor:[UIColor colorWithHexString:@"#F5F5F5"]];
        [self.btnBookEnd setTitleColor:[UIColor colorWithHexString:@"#1C2D51"] forState:UIControlStateNormal];
        [self.btnBookEnd.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14.0]];
        
        [self setDafaultOptionFilter];
        [self getListBookSelling:@(1)];
    }
   
}
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

- (IBAction)touchBtnFilter:(id)sender {
    
    [self.btnFilter setSelected:!self.btnFilter.selected];
    
    if(self.btnFilter.selected){
        
        [self showViewOptionSearch];
    }
    else{
        
        [self hideViewOptionSearch];
    }
}

#pragma mark - Call API

- (void)refreshBookSelling{
    
    NSString *url = @"";
    
    if(indexSelected == Selling){
        
        url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_SELLING,@(LIMIT_ITEM),@(indexPage)];
    }
    else{
        
        url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@&qty=0",URL_DEFAULT,GET_LIST_SELLING,@(LIMIT_ITEM),@(indexPage)];
    }
    
  
    
    isLoadingData = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        isLoadingData = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            self.arrSearchBook = [NSMutableArray array];
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Book *book = [[Book alloc] initWithDictionary:dic error:&error];
                book.descriptionStr = [dic objectForKey:@"description"];
                [self.arrSearchBook addObject:book];
                
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            self.arrSearchResult = [NSMutableArray arrayWithArray:self.arrSearchBook];
            [self.cllBook reloadData];
            
        }
        
        [refreshControl endRefreshing];
    }];
    
}

- (void)getListBookSelling:(NSNumber *)numShowHUD{
    
    NSString *url = @"";
    
    if(indexSelected == Selling){
        
        url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_SELLING,@(LIMIT_ITEM),@(indexPage)];
    }
    else{
        
         url = [NSString stringWithFormat:@"%@posts/me?qty=0&limit=%@&page=%@",URL_DEFAULT,@(LIMIT_ITEM),@(indexPage)];
    }
    
    if([numShowHUD boolValue]){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    isLoadingData = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
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
            
            self.arrSearchResult = [NSMutableArray arrayWithArray:self.arrSearchBook];
            [self.cllBook reloadData];
            
        }
        
        [refreshControl endRefreshing];
    }];
    
}

#pragma mark - Method

- (void)setDafaultOptionFilter{
    
    self.lblCategories.text = @"Tất cả";
    self.lblStatus.text = @"Tất cả";
    
    categoryID = @"";
    indexSort = -1;
    
    
    [self.btnHightToLow setSelected:NO];
    [self.btnLowToHight setSelected:NO];
    
}

- (void)refreshTable{
    
    indexPage = 1;
    [self setDafaultOptionFilter];
    [self.arrSearchBook removeAllObjects];
    [self performSelector:@selector(refreshBookSelling) withObject:nil afterDelay:1.0f];
    
    
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
    
    categoryID = @"";
    indexSort = -1;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.cllBook addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self.cllBook registerNib:[UINib nibWithNibName:@"SearchBookCell" bundle:nil] forCellWithReuseIdentifier:@"SearchBookCell"];
    
    self.viewTab.layer.cornerRadius = 15.0f;
    self.viewTab.layer.borderWidth = 1.0f;
    self.viewTab.layer.borderColor = [UIColor colorWithHexString:@"#D3D7E0"].CGColor;
    
    indexSelected = Selling;
}
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

#pragma mark - CreateBookViewControllerDelegate
- (void)finishEditing:(Book *)bookNew bookEdit:(Book*)bookEdit{
    
    NSInteger index = [self.arrSearchResult indexOfObject:bookEdit];
    NSInteger index2 = [self.arrSearchBook indexOfObject:bookEdit];
    
    if(indexSelected == Selling){
        
        if(bookNew.qty.integerValue == 0){
            
            [self.arrSearchResult removeObject:bookEdit];
            [self.arrSearchBook removeObject:bookEdit];
            
            [self.cllBook deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        }
        else{
            
            [self.arrSearchResult replaceObjectAtIndex:index withObject:bookNew];
            
            [self.arrSearchBook replaceObjectAtIndex:index2 withObject:bookNew];
            
            [self.cllBook reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        }
    }
    else{
        
        if(bookNew.qty.integerValue > 0){
            
            [self.arrSearchResult removeObject:bookEdit];
            [self.arrSearchBook removeObject:bookEdit];
            
            [self.cllBook deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        }
    }
   
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
    [cell.viewQuality setHidden:NO];
    [cell setDataForCell:book];
   
    if(indexPath.row == self.arrSearchResult.count - 1 && !isLoadingData &&!isFullData){
        
        indexPage ++;
        
        [self getListBookSelling:@(0)];
        
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
    CreateBookViewController *vcBookDetail = [storyboard instantiateViewControllerWithIdentifier:@"CreateBookViewController"];
    vcBookDetail.bookEdit = book;
    vcBookDetail.delegate = self;
    vcBookDetail.strTitle = book.name;
    vcBookDetail.btnTitle = @"Lưu";
    vcBookDetail.isEdit = YES;
    [self.navigationController pushViewController:vcBookDetail animated:YES];
}
@end

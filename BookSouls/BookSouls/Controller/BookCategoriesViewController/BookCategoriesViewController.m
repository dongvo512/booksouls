//
//  BookCategoriesViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/23/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookCategoriesViewController.h"
#import "SearchBookCell.h"
#import "BookDetailViewController.h"
#import "Book.h"
#import "Categories.h"
#import "PriceSortViewControler.h"
#import "StatusBookViewController.h"

@interface BookCategoriesViewController (){
    
    BOOL isLoadingData;
    BOOL isFullData;
    
    NSInteger indexPage;
    
    NSString *strStatus;
    
    NSString *strPrice;
}

@property (weak, nonatomic) IBOutlet UICollectionView *cllBook;
@property (nonatomic, strong) NSMutableArray *arrSearchBook;
@property (nonatomic, strong) NSMutableArray *arrSearchResult;

@property (weak, nonatomic) IBOutlet UIButton *btnSortPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnBookStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation BookCategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrSearchBook = [NSMutableArray array];
    
    self.lblTitle.text = self.categorieCurr.name;
    
    [self configUI];
    [self getListBookWithIDCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark - Call API
- (void)getListBookWithIDCategories{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@/posts?limit=%@&page=%@",URL_DEFAULT,GET_BOOK_CATEGORIES,self.categorieCurr.id.stringValue,@(LIMIT_ITEM),@(indexPage)];
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
        
    }];
    
}

#pragma mark - Method
- (void)configUI{
  
    strStatus = @"Tất cả";
    strPrice = @"Mặc định";
    
    indexPage = 1;
    [self.cllBook registerNib:[UINib nibWithNibName:@"SearchBookCell" bundle:nil] forCellWithReuseIdentifier:@"SearchBookCell"];
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
        [self getListBookWithIDCategories];
       
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

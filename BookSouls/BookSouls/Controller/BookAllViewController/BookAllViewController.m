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

typedef NS_ENUM(NSInteger, TypeBook) {
   
    TypeBookNew,
    TypeBookHot
};

@interface BookAllViewController (){
    
    BOOL isLoadingData;
    BOOL isFullData;
    
    NSInteger indexPage;
    
    UIRefreshControl *refreshControl;
}

@property (nonatomic, strong) NSMutableArray *arrSearchBook;
@property (nonatomic, strong) NSMutableArray *arrSearchResult;
@property (weak, nonatomic) IBOutlet UICollectionView *cllBook;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

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

#pragma mark - Cal API
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

#pragma mark - Method

- (IBAction)touchBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configUI{
    
    self.lblTitle.text = self.strTitle;
    
    [self.cllBook registerNib:[UINib nibWithNibName:@"SearchBookCell" bundle:nil] forCellWithReuseIdentifier:@"SearchBookCell"];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.cllBook addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}
- (void)refreshTable{
    
    indexPage = 1;
    
    if(self.typeBook == TypeBookNew){
        
        [self performSelector:@selector(refeshListBookNew) withObject:nil afterDelay:1.0f];
    }
    else{
        
        [self performSelector:@selector(refeshListBookHot) withObject:nil afterDelay:1.0f];
    }

}

- (void)refeshListBookHot{
    
    [self getlistHotBook:NO];
}

- (void)refeshListBookNew{
    
    [self getListNewBook:NO];
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

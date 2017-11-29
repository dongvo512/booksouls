//
//  InfoSellerViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/24/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "InfoSellerViewController.h"
#import "Book.h"
#import "UserInfo.h"
#import "SellerInfoView.h"
#import "GroupTititleView.h"
#import "BookDetailViewController.h"
#import "SearchBookCell.h"

#define HEIGHT_HEADER 110

typedef NS_ENUM(NSInteger, GroupBook) {
    
    GroupUserInfo = 0,
    GroupSelling
    
};

@interface InfoSellerViewController (){
    
    NSInteger indexPage;
    
    BOOL isLoadingData;
    
    BOOL isFullData;
    
}

@property (weak, nonatomic) IBOutlet UICollectionView *cllSellerInfo;
@property (nonatomic, strong) NSMutableArray *arrSelling;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation InfoSellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    self.arrSelling = [NSMutableArray array];
    indexPage = 1;
    [self getListBookSelling:@(1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CallAPI
- (void)getListBookSelling:(NSNumber *)numShowHUD{
    
    NSString *url = @"";
    
      url = [NSString stringWithFormat:@"%@users/%@/books?limit=%@&page=%@",URL_DEFAULT,self.userCurr.id,@(LIMIT_ITEM),@(indexPage)];
    
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
                [self.arrSelling addObject:book];
                
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            [self.cllSellerInfo reloadData];
            
        }
    }];
}

#pragma mark - Method
- (void)configUI{
    
    [self.cllSellerInfo registerNib:[UINib nibWithNibName:@"SearchBookCell" bundle:nil] forCellWithReuseIdentifier:@"SearchBookCell"];
    
    [self.cllSellerInfo registerNib:[UINib nibWithNibName:@"SellerInfoView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SellerInfoView"];
    
    [self.cllSellerInfo registerNib:[UINib nibWithNibName:@"GroupTititleView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GroupTititleView"];
    
    self.lblTitle.text = self.userCurr.name;
  
}

#pragma mark - UICollectionViewDataSource - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(section == GroupUserInfo){
        
         return 0;
    }
    else{
        
         return self.arrSelling.count;
    }
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchBookCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchBookCell" forIndexPath:indexPath];
    
    Book *book = [self.arrSelling objectAtIndex:indexPath.row];
    
    [cell setDataForCell:book];
    
    if(indexPath.row == self.arrSelling.count - 1 && !isLoadingData &&!isFullData){
        
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
    
    Book *book = [self.arrSelling objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookDetailViewController *vcBookDetail = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
    vcBookDetail.bookCurr = book;
    [self.navigationController pushViewController:vcBookDetail animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize headerSize = CGSizeZero;
    if(section == GroupUserInfo){
        
        headerSize = CGSizeMake(SW, HEIGHT_HEADER);
    }
    else{
        
        if(self.arrSelling.count > 0){
            
             headerSize = CGSizeMake(SW, 52);
        }
    }
    
    return headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    CGSize headerSize = CGSizeZero;
    return headerSize;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = [[UICollectionReusableView alloc] initWithFrame:CGRectZero];
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        if(indexPath.section == GroupUserInfo){
            
            SellerInfoView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SellerInfoView" forIndexPath:indexPath];
            [headerView setDataForView:self.userCurr];
            reusableview = headerView;
        }
        else if(indexPath.section == GroupSelling){
            
            GroupTititleView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GroupTititleView" forIndexPath:indexPath];
            reusableview = headerView;
        }
        
    }
    
    return reusableview;
}
@end

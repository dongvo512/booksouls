//
//  ContentOrderBuyingViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/27/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "ContentOrderBuyingViewController.h"
#import "UIColor+HexString.h"
#import "Order.h"
#import "BuyingCell.h"
#import "CommentSellerViewController.h"
#import "BuyerCancelViewController.h"
#import "UserInfo.h"
#import "BookDetailViewController.h"
#import "InfoSellerViewController.h"
#import "OrderViewController.h"

#define HEIGHT_CELL_MENU 238

typedef NS_ENUM(NSInteger, SelectedSeller) {
    
    BuyerPending,
    BuyerSending,
    BuyerSelled,
    BuyerCancel
    
};

@interface ContentOrderBuyingViewController (){
    
    NSInteger pageIndex;
    
    NSInteger indexSelected;
    
    BOOL isFullData;
    BOOL isLoading;
    
    Order *orderSelected;
    
}
@property (weak, nonatomic) IBOutlet UIView *viewWaitingSell;
@property (weak, nonatomic) IBOutlet UILabel *lblWaitingSell;

@property (weak, nonatomic) IBOutlet UIView *viewShiping;
@property (weak, nonatomic) IBOutlet UILabel *lblShiping;

@property (weak, nonatomic) IBOutlet UIView *viewSelled;
@property (weak, nonatomic) IBOutlet UILabel *lblSelled;

@property (weak, nonatomic) IBOutlet UIView *viewCancel;
@property (weak, nonatomic) IBOutlet UILabel *lblCancel;

@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation ContentOrderBuyingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self configUI];
    [self getListPending];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
   
}
#pragma mark - Action
- (IBAction)touchBtnWaitingSell:(id)sender {
    
    if(indexSelected != BuyerPending){
        
        [self defaultUI];
        indexSelected = BuyerPending;
        [self.viewWaitingSell setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.lblWaitingSell setTextColor:[UIColor whiteColor]];
        [self.lblWaitingSell setFont:[UIFont fontWithName:@"Muli-SemiBold" size:12]];
        
        [self setDataDefault];
        [self getListPending];
    }
}
- (IBAction)touchBtnShping:(id)sender {
    
    if(indexSelected != BuyerSending){
        
        [self defaultUI];
        indexSelected = BuyerSending;
        [self.viewShiping setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.lblShiping setTextColor:[UIColor whiteColor]];
        [self.lblShiping setFont:[UIFont fontWithName:@"Muli-SemiBold" size:12]];
        
        [self setDataDefault];
        [self getListSending];
    }
}
- (IBAction)touchBtnSelled:(id)sender {
    
    if(indexSelected != BuyerSelled){
        
        [self defaultUI];
        indexSelected = BuyerSelled;
        [self.viewSelled setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.lblSelled setTextColor:[UIColor whiteColor]];
        [self.lblSelled setFont:[UIFont fontWithName:@"Muli-SemiBold" size:12]];
        
        [self setDataDefault];
        [self getListBuyed];
    }
    
}
- (IBAction)touchBtnCancel:(id)sender {
    
    if(indexSelected != BuyerCancel){
        
        [self defaultUI];
        indexSelected = BuyerCancel;
        [self.viewCancel setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.lblCancel setTextColor:[UIColor whiteColor]];
        [self.lblCancel setFont:[UIFont fontWithName:@"Muli-SemiBold" size:12]];
        
        [self setDataDefault];
        [self getListCancel];
    }
}

#pragma mark - Method

- (void)setDataDefault{
    
    pageIndex = 1;
    isFullData = NO;
}

- (void)configUI{
  
    pageIndex = 1;
    indexSelected = BuyerPending;
    [self defaultUI];
    
    [self.viewWaitingSell setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
    [self.lblWaitingSell setTextColor:[UIColor whiteColor]];
    [self.lblWaitingSell setFont:[UIFont fontWithName:@"Muli-SemiBold" size:12]];
    
   
    
    [self.tblView registerNib:[UINib nibWithNibName:@"BuyingCell" bundle:nil] forCellReuseIdentifier:@"BuyingCell"];
}

- (void)defaultUI{
    
    self.viewWaitingSell.layer.borderWidth = 0.5f;
    self.viewWaitingSell.layer.borderColor = [UIColor colorWithHexString:@"#50AFF3"].CGColor;
    [self.viewWaitingSell setBackgroundColor:[UIColor whiteColor]];
    [self.lblWaitingSell setTextColor:[UIColor colorWithHexString:@"#50AFF3"]];
    
    self.viewShiping.layer.borderWidth = 0.5f;
    self.viewShiping.layer.borderColor = [UIColor colorWithHexString:@"#50AFF3"].CGColor;
    [self.viewShiping setBackgroundColor:[UIColor whiteColor]];
    [self.lblShiping setTextColor:[UIColor colorWithHexString:@"#50AFF3"]];
    
    self.viewSelled.layer.borderWidth = 0.5f;
    self.viewSelled.layer.borderColor = [UIColor colorWithHexString:@"#50AFF3"].CGColor;
    [self.viewSelled setBackgroundColor:[UIColor whiteColor]];
    [self.lblSelled setTextColor:[UIColor colorWithHexString:@"#50AFF3"]];
    
    self.viewCancel.layer.borderWidth = 0.5f;
    self.viewCancel.layer.borderColor = [UIColor colorWithHexString:@"#50AFF3"].CGColor;
    [self.viewCancel setBackgroundColor:[UIColor whiteColor]];
    [self.lblCancel setTextColor:[UIColor colorWithHexString:@"#50AFF3"]];
    
}

#pragma mark - Call API

- (void)cancelOrder:(Order *)order {
    
    NSString *url = [NSString stringWithFormat:@"%@orders/%@/cancel",URL_DEFAULT,order.id.stringValue];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    isLoading = YES;
    
    NSDictionary *dic = @{@"description":order.descriptionStr};
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_PUT withRequestBody:dic callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        isLoading = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            [Common showAlert:self title:@"Thông báo" message: [NSString stringWithFormat:@"Đã huỷ bán đơn hàng số %@",order.id.stringValue] buttonClick:^(UIAlertAction *alertAction) {
                
                NSInteger indexRemove = [self.arrData indexOfObject:order];
                
                [self.arrData removeObject:order];
                
                [self.tblView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexRemove inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
            }];
        }
    }];
}
- (void)successOrder:(NSString *)description numStar:(NSInteger)numStar{
    
    NSString *url = [NSString stringWithFormat:@"%@orders/%@/recived",URL_DEFAULT,orderSelected.id.stringValue];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    isLoading = YES;
    
    NSDictionary *dic = @{@"message":description,@"rate":@(numStar)};
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_PUT withRequestBody:dic callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        isLoading = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            [Common showAlert:self title:@"Thông báo" message: [NSString stringWithFormat:@"Đã đánh giá người bán %@",orderSelected.seller.name] buttonClick:^(UIAlertAction *alertAction) {
                
                NSInteger indexRemove = [self.arrData indexOfObject:orderSelected];
                
                [self.arrData removeObject:orderSelected];
                
                [self.tblView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexRemove inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
            }];
        }
    }];
    
}
- (void)loadMoreCancel{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_BUYER_CANCEL,@(LIMIT_ITEM),@(pageIndex)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        isLoading = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Order *order = [[Order alloc] initWithDictionary:dic error:&error];
                order.descriptionStr = [dic objectForKey:@"description"];
                [self.arrData addObject:order];
                
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            [self.tblView reloadData];
        }
    }];
}

- (void)loadMoreBuyed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@?limit=%@&page=%@",URL_DEFAULT,GET_LIST_BUYER_BUYED,@(LIMIT_ITEM),@(pageIndex)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        isLoading = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Order *order = [[Order alloc] initWithDictionary:dic error:&error];
                
                [self.arrData addObject:order];
                
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            [self.tblView reloadData];
        }
    }];
}

- (void)loadMoreSending{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_BUYER_SENDING,@(LIMIT_ITEM),@(pageIndex)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        isLoading = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            self.arrData = [NSMutableArray array];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Order *order = [[Order alloc] initWithDictionary:dic error:&error];
                
                [self.arrData addObject:order];
                
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            [self.tblView reloadData];
        }
    }];
}

- (void)loadMorePending{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_BUYER_PENDING,@(LIMIT_ITEM),@(pageIndex)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        isLoading = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Order *order = [[Order alloc] initWithDictionary:dic error:&error];
                
                [self.arrData addObject:order];
                
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            [self.tblView reloadData];
        }
    }];
}

- (void)getListCancel{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_BUYER_CANCEL,@(LIMIT_ITEM),@(pageIndex)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        isLoading = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            self.arrData = [NSMutableArray array];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Order *order = [[Order alloc] initWithDictionary:dic error:&error];
                order.descriptionStr = [dic objectForKey:@"description"];
                
                [self.arrData addObject:order];
                
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            [self.tblView reloadData];
        }
    }];
    
}

- (void)getListBuyed{
    
    NSString *url = [NSString stringWithFormat:@"%@%@?limit=%@&page=%@",URL_DEFAULT,GET_LIST_BUYER_BUYED,@(LIMIT_ITEM),@(pageIndex)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        isLoading = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            self.arrData = [NSMutableArray array];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Order *order = [[Order alloc] initWithDictionary:dic error:&error];
                
                [self.arrData addObject:order];
                
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            [self.tblView reloadData];
        }
    }];
}

- (void)getListPending{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_BUYER_PENDING,@(LIMIT_ITEM),@(pageIndex)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        isLoading = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            self.arrData = [NSMutableArray array];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Order *order = [[Order alloc] initWithDictionary:dic error:&error];
                
                [self.arrData addObject:order];
                
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            [self.tblView reloadData];
        }
    }];
}

- (void)getListSending{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_BUYER_SENDING,@(LIMIT_ITEM),@(pageIndex)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        isLoading = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            self.arrData = [NSMutableArray array];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                Order *order = [[Order alloc] initWithDictionary:dic error:&error];
                
                [self.arrData addObject:order];
                
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            [self.tblView reloadData];
        }
    }];
}

#pragma mark - Table view DataSource - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BuyingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuyingCell"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Order *order = [self.arrData objectAtIndex:indexPath.row];
    
    [cell setDataForCell:order indexSelected:indexSelected];
    
    if(indexPath.row == self.arrData.count - 1 && !isLoading && !isFullData){

        pageIndex ++;

        if(indexSelected == BuyerPending){

            [self loadMorePending];
        }
        else if(indexSelected == BuyerSending){

            [self loadMoreSending];
        }
        else if(indexSelected == BuyerSelled){

            [self loadMoreBuyed];
        }
        else if(indexSelected == BuyerCancel){

            [self loadMoreCancel];
        }
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HEIGHT_CELL_MENU;
    
}



#pragma mark - BuyingCellDelegate

- (void)selectedSeller:(Order *)order{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoSellerViewController *vcInfoSeller = [storyboard instantiateViewControllerWithIdentifier:@"InfoSellerViewController"];
    vcInfoSeller.userCurr = order.seller;
    [self.vcParent.navigationController pushViewController:vcInfoSeller animated:YES];
}

- (void)selectedBook:(Order *)order{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookDetailViewController *vcBookDetail = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
    vcBookDetail.bookCurr = order.book;
    [self.vcParent.navigationController pushViewController:vcBookDetail animated:YES];
    
}

- (void)selectedButtonAcept:(Order *)order{
    
    orderSelected = order;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CommentSellerViewController *vcComment = [storyboard instantiateViewControllerWithIdentifier:@"CommentSellerViewController"];
    vcComment.delegate = self;
    [vcComment presentInParentViewController:(UIViewController *)self.vcParent];
}

- (void)selectedButtonCancel:(Order *)order{
    
    orderSelected = order;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BuyerCancelViewController *vcBuyerCancel = [storyboard instantiateViewControllerWithIdentifier:@"BuyerCancelViewController"];
    vcBuyerCancel.delegate = self;
    [vcBuyerCancel presentInParentViewController:(UIViewController *)self.vcParent];
}

#pragma mark - CommentSellerViewController
- (void)aceptCommentForSeller:(NSString *)description numStar:(NSInteger)numStar{
    
    [self successOrder:description numStar:numStar];
}

#pragma mark - BuyerCancelViewControllerDelegate
- (void)aceptCancelFromBuyer:(NSString *)description{
    
    orderSelected.descriptionStr = description;
    
    [self cancelOrder:orderSelected];
}
@end

//
//  ContentOrderViewSellingController.m
//  BookSouls
//
//  Created by Dong Vo on 11/27/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "ContentOrderViewSellingController.h"
#import "UIColor+HexString.h"
#import "Order.h"
#import "SellingCell.h"
#import "SellerCancelViewController.h"
#import "CommentBuyerViewController.h"
#import "UserInfo.h"
#import "BookDetailViewController.h"
#import "InfoSellerViewController.h"
#import "OrderViewController.h"

#define HEIGHT_CELL_MENU 238

typedef NS_ENUM(NSInteger, SelectedSeller) {
    
    SellerPending,
    SellerSending,
    SellerSucess,
    SellerSelled,
    SellerCancel
    
};

@interface ContentOrderViewSellingController (){
    
    NSInteger pageIndex;
    
    NSInteger indexSelected;
    
    BOOL isFullData;
    BOOL isLoading;
    
    Order *orderCancelSelected;
    Order *orderCommentSelected;
}

@property (weak, nonatomic) IBOutlet UIView *viewWaitingSell;
@property (weak, nonatomic) IBOutlet UILabel *lblWaitingSell;

@property (weak, nonatomic) IBOutlet UIView *viewShiping;
@property (weak, nonatomic) IBOutlet UILabel *lblShiping;

@property (weak, nonatomic) IBOutlet UIView *viewComment;
@property (weak, nonatomic) IBOutlet UILabel *lblComment;

@property (weak, nonatomic) IBOutlet UIView *viewSelled;
@property (weak, nonatomic) IBOutlet UILabel *lblSelled;

@property (weak, nonatomic) IBOutlet UIView *viewCancel;
@property (weak, nonatomic) IBOutlet UILabel *lblCancel;
@property (weak, nonatomic) IBOutlet UITableView *tblView;


@property (nonatomic, strong) NSMutableArray *arrData;

@end

@implementation ContentOrderViewSellingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    if(indexSelected != SellerPending){
        
        [self defaultUI];
        
        [self.viewWaitingSell setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.lblWaitingSell setTextColor:[UIColor whiteColor]];
        [self.lblWaitingSell setFont:[UIFont fontWithName:@"Muli-SemiBold" size:12]];
        
        indexSelected = SellerPending;
        [self defaulData];
        [self getListPending];
    }
    
}
- (IBAction)touchBtnShping:(id)sender {
    
    if(indexSelected != SellerSending){
        
        [self defaultUI];
        
        [self.viewShiping setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.lblShiping setTextColor:[UIColor whiteColor]];
        [self.lblShiping setFont:[UIFont fontWithName:@"Muli-SemiBold" size:12]];
        
        indexSelected = SellerSending;
        [self defaulData];
        [self getListSending];
    }
}

- (IBAction)touchComment:(id)sender {
    
    if(indexSelected != SellerSucess){
        
        [self defaultUI];
        
        [self.viewComment setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.lblComment setTextColor:[UIColor whiteColor]];
        [self.lblComment setFont:[UIFont fontWithName:@"Muli-SemiBold" size:12]];
        
        indexSelected = SellerSucess;
        [self defaulData];
        [self getListCommentWaiting];
    }
}
- (IBAction)touchBtnSelled:(id)sender {
    
    if(indexSelected != SellerSelled){
        
        [self defaultUI];
        
        [self.viewSelled setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.lblSelled setTextColor:[UIColor whiteColor]];
        [self.lblSelled setFont:[UIFont fontWithName:@"Muli-SemiBold" size:12]];
        
        indexSelected = SellerSelled;
        [self defaulData];
        [self getListSelled];
    }
}
- (IBAction)touchBtnCancel:(id)sender {
    
    if(indexSelected != SellerCancel){
        
        [self defaultUI];
        
        [self.viewCancel setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
        [self.lblCancel setTextColor:[UIColor whiteColor]];
        [self.lblCancel setFont:[UIFont fontWithName:@"Muli-SemiBold" size:12]];
        
        indexSelected = SellerCancel;
        [self defaulData];
        [self getListCancel];
    }
}

#pragma mark - Method

- (void)defaulData{
    
    pageIndex = 1;
    isFullData = NO;
    
}

- (void)configUI{
    
    pageIndex = 1;
    indexSelected = SellerPending;
    [self defaultUI];
    
    [self.viewWaitingSell setBackgroundColor:[UIColor colorWithHexString:@"#50AFF3"]];
    [self.lblWaitingSell setTextColor:[UIColor whiteColor]];
    [self.lblWaitingSell setFont:[UIFont fontWithName:@"Muli-SemiBold" size:12]];
    
    [self.tblView registerNib:[UINib nibWithNibName:@"SellingCell" bundle:nil] forCellReuseIdentifier:@"SellingCell"];
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
    
    self.viewComment.layer.borderWidth = 0.5f;
    self.viewComment.layer.borderColor = [UIColor colorWithHexString:@"#50AFF3"].CGColor;
    [self.viewComment setBackgroundColor:[UIColor whiteColor]];
    [self.lblComment setTextColor:[UIColor colorWithHexString:@"#50AFF3"]];
    
    self.viewSelled.layer.borderWidth = 0.5f;
    self.viewSelled.layer.borderColor = [UIColor colorWithHexString:@"#50AFF3"].CGColor;
    [self.viewSelled setBackgroundColor:[UIColor whiteColor]];
    [self.lblSelled setTextColor:[UIColor colorWithHexString:@"#50AFF3"]];
    
    self.viewCancel.layer.borderWidth = 0.5f;
    self.viewCancel.layer.borderColor = [UIColor colorWithHexString:@"#50AFF3"].CGColor;
    [self.viewCancel setBackgroundColor:[UIColor whiteColor]];
    [self.lblCancel setTextColor:[UIColor colorWithHexString:@"#50AFF3"]];
    
}

#pragma mark - LoadMore
- (void)loadMoreCancel{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_SELLER_CANCEL,@(LIMIT_ITEM),@(pageIndex)];
    
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
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

- (void)loadMoreSelled{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_SELLER_SUCESS,@(LIMIT_ITEM),@(pageIndex)];
    
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
      
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
- (void)loadMoreCommentWaiting{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_SELLER_SELLED,@(LIMIT_ITEM),@(pageIndex)];
    
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_SELLER_SENDING,@(LIMIT_ITEM),@(pageIndex)];
    
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
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

- (void)loadMorePending{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_SELLER_PENDING,@(LIMIT_ITEM),@(pageIndex)];
   
    isLoading = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
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

#pragma mark - Call API

- (void)successOrder:(NSString *)description numStar:(NSInteger)numStar{
    
    NSString *url = [NSString stringWithFormat:@"%@orders/%@/sucess",URL_DEFAULT,orderCommentSelected.id.stringValue];
    
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
            
            [Common showAlert:self title:@"Thông báo" message: [NSString stringWithFormat:@"Đã đánh giá người mua %@",orderCommentSelected.buyer.name] buttonClick:^(UIAlertAction *alertAction) {
                
                NSInteger indexRemove = [self.arrData indexOfObject:orderCommentSelected];
                
                [self.arrData removeObject:orderCommentSelected];
                
                [self.tblView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexRemove inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
            }];
        }
    }];
    
}

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

- (void)aceptOrder:(Order *)order{
    
    NSString *url = [NSString stringWithFormat:@"%@orders/%@/accept",URL_DEFAULT,order.id.stringValue];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    isLoading = YES;
    
    NSDictionary *dic = @{@"qty":@"1",@"sellerId":Appdelegate_BookSouls.sesstionUser.profile.id};
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_PUT withRequestBody:dic callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        isLoading = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            [Common showAlert:self title:@"Thông báo" message:@"Xác nhận đơn hàng thành công" buttonClick:^(UIAlertAction *alertAction) {
                
                NSInteger indexRemove = [self.arrData indexOfObject:order];
                
                [self.arrData removeObject:order];
                
                [self.tblView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexRemove inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
            }];
        }
    }];
    
}

- (void)getListSelled{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_SELLER_SUCESS,@(LIMIT_ITEM),@(pageIndex)];
    
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
- (void)getListCancel{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_SELLER_CANCEL,@(LIMIT_ITEM),@(pageIndex)];
    
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

- (void)getListCommentWaiting{
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_SELLER_SELLED,@(LIMIT_ITEM),@(pageIndex)];
    
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_SELLER_SENDING,@(LIMIT_ITEM),@(pageIndex)];
    
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@&limit=%@&page=%@",URL_DEFAULT,GET_LIST_SELLER_PENDING,@(LIMIT_ITEM),@(pageIndex)];
   
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
    
    SellingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellingCell"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    Order *order = [self.arrData objectAtIndex:indexPath.row];
  
    [cell setDataForCell:order indexSelected:indexSelected];
    
    if(indexPath.row == self.arrData.count - 1 && !isLoading && !isFullData){
        
        pageIndex ++;
        
        if(indexSelected == SellerPending){
            
            [self loadMorePending];
        }
        else if(indexSelected == SellerSending){
            
            [self loadMoreSending];
        }
        else if(indexSelected == SellerSucess){
            
            [self loadMoreCommentWaiting];
        }
        else if(indexSelected == SellerSelled){
            
            [self loadMoreSelled];
        }
        else if(indexSelected == SellerCancel){
            
            [self loadMoreCancel];
        }
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HEIGHT_CELL_MENU;
    
}


#pragma mark - SellingCellDelegate

- (void)selectedBuyer:(Order *)order{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoSellerViewController *vcInfoSeller = [storyboard instantiateViewControllerWithIdentifier:@"InfoSellerViewController"];
    vcInfoSeller.userCurr = order.buyer;
    [self.vcParent.navigationController pushViewController:vcInfoSeller animated:YES];
}

- (void)selectedBook:(Order *)order{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookDetailViewController *vcBookDetail = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewController"];
    vcBookDetail.bookCurr = order.book;
    [self.vcParent.navigationController pushViewController:vcBookDetail animated:YES];
    
}

- (void)selectedButtonAcept:(Order *)order{
    
    [self aceptOrder:order];
}
- (void)selectedButtonCancel:(Order *)order{
    
    orderCancelSelected = order;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
   
    SellerCancelViewController *vcCancelFromSeller = [storyboard instantiateViewControllerWithIdentifier:@"SellerCancelViewController"];
    vcCancelFromSeller.delegate = self;
    [vcCancelFromSeller presentInParentViewController:(UIViewController *)self.vcParent];

}
- (void)selectedButtonComment:(Order *)order{
    
    orderCommentSelected = order;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CommentBuyerViewController *vcComment = [storyboard instantiateViewControllerWithIdentifier:@"CommentBuyerViewController"];
    vcComment.delegate = self;
    [vcComment presentInParentViewController:(UIViewController *)self.vcParent];
}

#pragma mark - SellerCancelViewControllerDelegate
- (void)aceptCancelFromSeller:(NSString *)description{
    
    orderCancelSelected.descriptionStr = description;
    [self cancelOrder:orderCancelSelected];
}

#pragma mark - CommentBuyerViewControllerDelegate
- (void)aceptComment:(NSString *)description numStar:(NSInteger)numStar{
    
    [self successOrder:description numStar:numStar];
}
@end

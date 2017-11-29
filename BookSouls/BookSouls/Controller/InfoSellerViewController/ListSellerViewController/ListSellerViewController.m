//
//  ListSellerViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/23/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "ListSellerViewController.h"
#import "SellerListCell.h"
#import "UserInfo.h"
#import "InfoSellerViewController.h"

#define HEIGHT_CELL 90

@interface ListSellerViewController (){
    
    NSInteger indexPage;
    
    BOOL isFullData;
    
    BOOL isLoadingData;
}

@property (weak, nonatomic) IBOutlet UITableView *tblViewSeller;
@property (nonatomic, strong) NSMutableArray *arrSeller;

@end

@implementation ListSellerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.arrSeller = [NSMutableArray array];
    
    [self configUI];
    
    [self getListBestSeller:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Method
- (void)configUI{
    
    [self.tblViewSeller registerNib:[UINib nibWithNibName:@"SellerListCell" bundle:nil] forCellReuseIdentifier:@"SellerListCell"];
    
    indexPage = 1;
}

#pragma mark - CallAPI
- (void)getListBestSeller:(BOOL)isShowHud{
    

    if(isShowHud){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@?limit=%@&page=%@",URL_DEFAULT,GET_BEST_SELLER,@(LIMIT_ITEM),@(indexPage)];
    isLoadingData = YES;
    
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
       
        isLoadingData = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            for(NSDictionary *dic in arrData){
                
                NSError *error;
                
                UserInfo *user = [[UserInfo alloc] initWithDictionary:dic error:&error];
                
                [self.arrSeller addObject:user];
                
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            
            [self.tblViewSeller reloadData];
            
        }
        
    }];
    
}
#pragma mark - Table view DataSource - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrSeller.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     SellerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SellerListCell"];
    
    UserInfo *user = [self.arrSeller objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setDataForCell:user];
    
    if(indexPath.row == self.arrSeller.count - 1 && !isLoadingData &&!isFullData){
        
        indexPage ++;
        [self getListBestSeller:NO];
        
    }
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HEIGHT_CELL;
    
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserInfo *user = [self.arrSeller objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoSellerViewController *vcInfoSeller = [storyboard instantiateViewControllerWithIdentifier:@"InfoSellerViewController"];
    vcInfoSeller.userCurr = user;
    [self.navigationController pushViewController:vcInfoSeller animated:YES];
    
}
@end

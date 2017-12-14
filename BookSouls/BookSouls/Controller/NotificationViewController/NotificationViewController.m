//
//  NotificationViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/22/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationCell.h"
#import "Notify.h"

@interface NotificationViewController (){
    
    NSInteger indexpage;
    
    BOOL isLoadingData;
    
    BOOL isFullData;
    
    UIRefreshControl *refreshControl;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, strong) NSMutableArray *arrNotification;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    self.arrNotification = [NSMutableArray array];
    
    [self getListNotification:@(1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBtnMenu:(id)sender {
    
    [[SlideMenuViewController sharedInstance] toggle];
}
#pragma mark - Call API

- (void)updateReadedNotification:(Notify *)noti{
    
    NSString *url = [NSString stringWithFormat:@"%@notifications/%@",URL_DEFAULT,noti.id.stringValue];
    isLoadingData = YES;
    
    NSDictionary *dic = @{@"isRead":@(1)};
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_PUT withRequestBody:dic callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        isLoadingData = NO;
        
        if(isError){
            
           // [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
           
            SlideMenuViewController *vcSlide = [SlideMenuViewController sharedInstance];
            [vcSlide getNumNotiNoRead];
            
        }
        
    }];
    
}

- (void)refreshNotificaiton{
    
    indexpage = 1;
    
    NSString *url = [NSString stringWithFormat:@"%@%@?limit=%@&page=%@",URL_DEFAULT,GET_NOTIFICATION,@(LIMIT_ITEM),@(indexpage)];
    isLoadingData = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        isLoadingData = NO;
        
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            self.arrNotification = [NSMutableArray array];
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            NSError *error;
            
            for(NSDictionary *dic in arrData){
                
                Notify *notify = [[Notify alloc] initWithDictionary:dic error:&error];
                
                [self.arrNotification addObject:notify];
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            [refreshControl endRefreshing];
            [self.tblView reloadData];
        }
        
    }];
}

- (void)getListNotification:(NSNumber *)isShowHud{
    
    if([isShowHud boolValue]){
        
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
   
    
    NSString *url = [NSString stringWithFormat:@"%@%@?limit=%@&page=%@",URL_DEFAULT,GET_NOTIFICATION,@(LIMIT_ITEM),@(indexpage)];
    isLoadingData = YES;
    
    [APIRequestHandler initWithURLString:url withHttpMethod:kHTTP_METHOD_GET withRequestBody:nil callApiResult:^(BOOL isError, NSString *stringError, id responseDataObject) {
        
        isLoadingData = NO;
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(isError){
            
            [Common showAlert:self title:@"Thông báo" message:stringError buttonClick:nil];
        }
        else{
            
            NSArray *arrData = [responseDataObject objectForKey:@"data"];
            
            NSError *error;
            
            for(NSDictionary *dic in arrData){
                
                Notify *notify = [[Notify alloc] initWithDictionary:dic error:&error];
                
                [self.arrNotification addObject:notify];
            }
            
            if(arrData.count < LIMIT_ITEM){
                
                isFullData = YES;
            }
            [refreshControl endRefreshing];
            [self.tblView reloadData];
        }
       
    }];
}

#pragma mark - Method

- (void)refreshTable{
    
    indexpage = 1;
    isFullData = NO;
   
    [self performSelector:@selector(refreshNotificaiton) withObject:nil afterDelay:1.0f];
}

- (void)configUI{
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tblView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    [self.tblView registerNib:[UINib nibWithNibName:@"NotificationCell" bundle:nil] forCellReuseIdentifier:@"NotificationCell"];
    
    self.tblView.estimatedRowHeight = 64;
    self.tblView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Table view DataSource - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrNotification.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Notify *notify = [self.arrNotification objectAtIndex:indexPath.row];
    
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell"];
    [cell setDataForCell:notify];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == self.arrNotification.count - 1 && !isLoadingData &&!isFullData){
        
        indexpage ++;
        
        [self getListNotification:@(0)];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Notify *noti = [self.arrNotification objectAtIndex:indexPath.row];
    
    [self updateReadedNotification:noti];
    
    Appdelegate_BookSouls.notiType = noti.contentKey;
    
    SlideMenuViewController *vcSlide = [SlideMenuViewController sharedInstance];
    
    [vcSlide selecItemCurr:Item_Order];
    
}

@end

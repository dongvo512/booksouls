//
//  CategoriesViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/10/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "CategoriesViewController.h"
#import "Categories.h"
#import "CategoriesTblCell.h"
#import "UIColor+HexString.h"

#define HEIGHT_ROW 44

@interface CategoriesViewController ()<UISearchBarDelegate>{
    
    NSString *keyword;
    
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tblCategories;
@property (nonatomic, strong) NSMutableArray *arrCategories;
@property (nonatomic, strong) NSMutableArray *arrSearch;

@end

@implementation CategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tblCategories registerNib:[UINib nibWithNibName:@"CategoriesTblCell" bundle:nil] forCellReuseIdentifier:@"CategoriesTblCell"];
    
    [self getListCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBtnClose:(id)sender {
    
    [self dismissFromParentViewController];
}

#pragma mark - Call API
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
                     self.arrSearch = [NSMutableArray arrayWithArray:self.arrCategories];
                    Categories *cat_all = [[Categories alloc] init];
                    cat_all.name = @"Tất cả";
                    [self.arrSearch insertObject:cat_all atIndex:0];
                    [self.tblCategories reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                }
                
            }
            
        }];
    }
    else{
        
        self.arrCategories = Appdelegate_BookSouls.arrCategories;
        
        if(self.arrCategories.count > 0){
            
            self.arrSearch = [NSMutableArray arrayWithArray:self.arrCategories];
            Categories *cat_all = [[Categories alloc] init];
            cat_all.name = @"Tất cả";
            [self.arrSearch insertObject:cat_all atIndex:0];
            [self.tblCategories reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}

#pragma mark - Method

- (void)presentInParentViewController:(UIViewController *)parentViewController {
    //[self.view removeFromSuperview];
    
    self.view.frame = parentViewController.view.bounds;
    [parentViewController.view addSubview:self.view];
    self.view.center = parentViewController.view.center;
    [parentViewController addChildViewController:self];
    self.view.alpha = 0.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.alpha = 1.0;
        
    } completion:nil];
    
}

- (void)dismissFromParentViewController {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
       
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
    }];
    
}

#pragma mark - Table view DataSource - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrSearch.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoriesTblCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoriesTblCell"];
    
    Categories *cat = [self.arrSearch objectAtIndex:indexPath.row];
    
    if(indexPath.row % 2){
        
        [cell.contentView setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
    }
    else{
        
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setDataForCell:cat];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return HEIGHT_ROW;
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Categories *cat = [self.arrSearch objectAtIndex:indexPath.row];
    
    if([[self delegate] respondsToSelector:@selector(selectedCategories:)]){
        
        [[self delegate] selectedCategories:cat];
    }
    
    [self dismissFromParentViewController];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length == 0) {
        
        self.arrSearch = nil;
        self.arrSearch = [NSMutableArray arrayWithArray:self.arrCategories];
        [self.tblCategories reloadData];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
    // NSLog(@"%@",textField.text);
    
    self.arrSearch = nil;
    self.arrSearch = [NSMutableArray arrayWithArray: [self.arrCategories filteredArrayUsingPredicate:predicate]];
    [self.tblCategories reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.view endEditing:YES];
    
}
- (IBAction)btnPrice:(id)sender {
}
@end

//
//  AllCategoriesViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/23/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "AllCategoriesViewController.h"
#import "CategoriesCell.h"
#import "Categories.h"
#import "BookCategoriesViewController.h"

@interface AllCategoriesViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *cllCategories;
@property (nonatomic, strong) NSMutableArray *arrSearch;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation AllCategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.arrSearch = [NSMutableArray arrayWithArray:self.arrCategories];
    
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma nark - Action

- (IBAction)touchBtnBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Method


- (void)configUI{
    
    [self.cllCategories registerNib:[UINib nibWithNibName:@"CategoriesCell" bundle:nil] forCellWithReuseIdentifier:@"CategoriesCell"];
}
#pragma mark - UICollectionViewDataSource - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrSearch.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoriesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoriesCell" forIndexPath:indexPath];
    Categories *cat = [self.arrSearch objectAtIndex:indexPath.row];
    [cell setDataForCell:cat];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    float width = (float)(SW - 24*3)/2;
    
    float ratio = (float)120/(float)172;
    float height = width *ratio;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 24, 0, 24);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Categories *cat = [self.arrCategories objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookCategoriesViewController *vcCreateBook = [storyboard instantiateViewControllerWithIdentifier:@"BookCategoriesViewController"];
    vcCreateBook.categorieCurr = cat;
    [self.navigationController pushViewController:vcCreateBook animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length == 0) {
        
        self.arrSearch = nil;
        self.arrSearch = [NSMutableArray arrayWithArray:self.arrCategories];
        [self.cllCategories reloadData];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", searchText];
    // NSLog(@"%@",textField.text);
    
    self.arrSearch = nil;
    self.arrSearch = [NSMutableArray arrayWithArray: [self.arrCategories filteredArrayUsingPredicate:predicate]];
     [self.cllCategories reloadData];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.view endEditing:YES];
    
}

@end

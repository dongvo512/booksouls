//
//  BookCategoriesView.m
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookCategoriesView.h"
#import "CategoriesCell.h"
#import "Categories.h"
#import "UIColor+HexString.h"


@interface BookCategoriesView ()

@property (nonatomic, strong) NSMutableArray *arrCategories;

@property (weak, nonatomic) IBOutlet UICollectionView *cllCategories;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation BookCategoriesView

- (void)setDataForView:(NSMutableArray *)arrSeller{
    
    self.arrCategories = arrSeller;
    [self.cllCategories reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.cllCategories registerNib:[UINib nibWithNibName:@"CategoriesCell" bundle:nil] forCellWithReuseIdentifier:@"CategoriesCell"];
}

#pragma mark - UICollectionViewDataSource - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrCategories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoriesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoriesCell" forIndexPath:indexPath];
    Categories *cat = [self.arrCategories objectAtIndex:indexPath.row];
    [cell setDataForCell:cat];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(120, 72);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 24, 0, 24);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end

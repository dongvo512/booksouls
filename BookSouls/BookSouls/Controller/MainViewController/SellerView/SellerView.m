//
//  SellerView.m
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "SellerView.h"
#import "SellerCell.h"
#import "Categories.h"
#import "UIColor+HexString.h"
#import "UserInfo.h"

@interface SellerView ()

@property (nonatomic, strong) NSMutableArray *arrSeller;

@property (weak, nonatomic) IBOutlet UICollectionView *cllSeller;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation SellerView

- (void)setDataForView:(NSMutableArray *)arrSeller{
    
    self.arrSeller = arrSeller;
    [self.cllSeller reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.cllSeller registerNib:[UINib nibWithNibName:@"SellerCell" bundle:nil] forCellWithReuseIdentifier:@"SellerCell"];
}

#pragma mark - UICollectionViewDataSource - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrSeller.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SellerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SellerCell" forIndexPath:indexPath];
    UserInfo *user = [self.arrSeller objectAtIndex:indexPath.row];
    [cell setDataForCell:user];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100, 120);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(24, 0, 24, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end

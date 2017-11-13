//
//  BookNewView.m
//  BookSouls
//
//  Created by Dong Vo on 11/7/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookNewView.h"
#import "BookNewCell.h"
#import "Book.h"
#import "UIColor+HexString.h"

@interface BookNewView ()

@property (nonatomic, strong) NSMutableArray *arrBookNew;

@property (weak, nonatomic) IBOutlet UICollectionView *cllBookNew;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation BookNewView

- (void)setDataForView:(NSMutableArray *)arrBookNew{
    
    self.arrBookNew = arrBookNew;
    [self.cllBookNew reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.cllBookNew registerNib:[UINib nibWithNibName:@"BookNewCell" bundle:nil] forCellWithReuseIdentifier:@"BookNewCell"];
}

#pragma mark - UICollectionViewDataSource - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrBookNew.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BookNewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookNewCell" forIndexPath:indexPath];
    Book *book = [self.arrBookNew objectAtIndex:indexPath.row];
    [cell setDataForCell:book];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(126, 246);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Book *book = [self.arrBookNew objectAtIndex:indexPath.row];
    
    if([[self delegate] respondsToSelector:@selector(selectedItemBookNew:)]){
        
        [[self delegate] selectedItemBookNew:book];
    }
}

@end
//
//  BookDetailTitleView.m
//  BookSouls
//
//  Created by Dong Vo on 11/10/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookDetailTitleView.h"
#import "BookDetailBannerCell.h"
#import "Book.h"
#import "UserInfo.h"
#import "Image.h"
#import "UIColor+HexString.h"

#define HEIGHT_BANNER 230

@interface BookDetailTitleView ()
@property (weak, nonatomic) IBOutlet UICollectionView *cllBanner;

@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;
@property (weak, nonatomic) IBOutlet UILabel *lblSubStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (nonatomic, strong) NSMutableArray *arrBanner;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation BookDetailTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.cllBanner registerNib:[UINib nibWithNibName:@"BookDetailBannerCell" bundle:nil] forCellWithReuseIdentifier:@"BookDetailBannerCell"];
}

- (void)setDataForView:(Book *)book{
    
     self.arrBanner = book.images;
   
    self.lblName.text = book.name;
    self.lblAuthor.text = [NSString stringWithFormat:@"bởi %@ NXB %@",book.author,book.nxb];
    
    [Common hightLightLabel:self.lblAuthor withSubstring:book.author withColor:[UIColor colorWithHexString:@"#7CAAFC"] font:[UIFont fontWithName:@"Muli-SemiBoldItalic" size:14.0]];
    
    self.lblSubStatus.text = book.subStatus;
    [self.pageControl setNumberOfPages:self.arrBanner.count];
    
    [self.cllBanner reloadData];
}

#pragma mark - UICollectionViewDataSource - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrBanner.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BookDetailBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookDetailBannerCell" forIndexPath:indexPath];
    
    Image *img = [self.arrBanner objectAtIndex:indexPath.row];
    [cell setDataForCell:img];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SW, HEIGHT_BANNER);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Image *img = [self.arrBanner objectAtIndex:indexPath.row];
    
    if([[self delegate] respondsToSelector:@selector(selectedImage:)]){
        
        [[self delegate] selectedImage:img];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.cllBanner.frame.size.width;
    float currentPage = self.cllBanner.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
    {
        self.pageControl.currentPage = currentPage + 1;
    }
    else
    {
        self.pageControl.currentPage = currentPage;
    }
    
}

@end

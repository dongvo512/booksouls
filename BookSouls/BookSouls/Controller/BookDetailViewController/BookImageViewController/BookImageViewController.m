//
//  BookImageViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/13/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookImageViewController.h"
#import "BookImageCell.h"
#import "Image.h"

@interface BookImageViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *cllImage;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;

@end

@implementation BookImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.lblTitle.text = self.bookName;
    
    [self.cllImage registerNib:[UINib nibWithNibName:@"BookImageCell" bundle:nil] forCellWithReuseIdentifier:@"BookImageCell"];
    
     [self.cllImage scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.indexCurr inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    

    [self showButtonWithIndexCurr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)touchBtnRight:(id)sender {
    
    if(self.indexCurr +1 < self.arrImages.count){
        
        self.indexCurr++;
        [self showButtonWithIndexCurr];
        [self.cllImage scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.indexCurr inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
}
- (IBAction)touchBtnLeft:(id)sender {
    
    if(self.indexCurr != 0){
        
        self.indexCurr--;
        [self showButtonWithIndexCurr];
        [self.cllImage scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.indexCurr inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
}
- (IBAction)touchBtnCLose:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Method

- (void)showButtonWithIndexCurr{
    
    if(self.arrImages.count == 1){
        
        [self.btnLeft setHidden:YES];
        [self.btnRight setHidden:YES];
    }
    else{
        
        if(self.indexCurr == 0){
            
            [self.btnLeft setHidden:YES];
            [self.btnRight setHidden:NO];
        }
        else if(self.indexCurr != 0 && self.indexCurr +1 < self.arrImages.count ){
            
            [self.btnLeft setHidden:NO];
            [self.btnRight setHidden:NO];
        }
        else{
            
            [self.btnLeft setHidden:NO];
            [self.btnRight setHidden:YES];
        }
    }
    
}

#pragma mark - UICollectionViewDataSource - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BookImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookImageCell" forIndexPath:indexPath];
    Image *img = [self.arrImages objectAtIndex:indexPath.row];
    [cell setDataForCell:img];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SW, SH - 64);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.cllImage.frame.size.width;
    float currentPage = self.cllImage.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
    {
        self.indexCurr = currentPage + 1;
    }
    else
    {
        self.indexCurr = currentPage;
    }
    
    [self showButtonWithIndexCurr];
}
@end

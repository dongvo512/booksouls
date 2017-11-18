//
//  BookSearchViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/15/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BookSearchViewController.h"
#import "BookSearchCell.h"

@interface BookSearchViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *cllView;

@end

@implementation BookSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.cllView registerNib:[UINib nibWithNibName:@"BookSearchCell" bundle:nil] forCellWithReuseIdentifier:@"BookSearchCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBtnClose:(id)sender {
    
    [self dismissFromParentViewController];
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

#pragma mark - UICollectionViewDataSource - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.arrSearch.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BookSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookSearchCell" forIndexPath:indexPath];
    
    Book *book = [self.arrSearch objectAtIndex:indexPath.row];
  
    [cell setDataForCell:book];
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (SW - 12*3 - 48)/2;
    
    CGFloat height = 0;
    
    float ratio = (float)172/(float)126;
    
    height  = width *ratio + 76;
    
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Book *book = [self.arrSearch objectAtIndex:indexPath.row];
    
    if([[self delegate] respondsToSelector:@selector(selectedBook:)]){
        
        [[self delegate] selectedBook:book];
    }
    
    [self dismissFromParentViewController];
}

@end

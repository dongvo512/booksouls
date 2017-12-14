//
//  PriceSortViewControler.m
//  BookSouls
//
//  Created by Dong Vo on 11/15/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "PriceSortViewControler.h"
#import "StatusCell.h"
#import "UIColor+HexString.h"

@interface PriceSortViewControler ()
@property (weak, nonatomic) IBOutlet UITableView *tblStatus;

@end

@implementation PriceSortViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tblStatus.estimatedRowHeight = 44;
    self.tblStatus.rowHeight = UITableViewAutomaticDimension;
    
    if(!self.arrPrice){
        
        self.arrPrice = @[@"Mặc định",@"Thấp đến cao", @"Cao đến thấp"];
    }
    
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
#pragma mark - Table view DataSource - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arrPrice.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatusCell"];
    
    NSString *strStatus = [self.arrPrice objectAtIndex:indexPath.row];
    
    if(indexPath.row % 2){
        
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        
        [cell.contentView setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblStatus.text = strStatus;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSString *strStatus = [self.arrPrice objectAtIndex:indexPath.row];
    
    if([[self delegate] respondsToSelector:@selector(selectedPriceBook:)]){
        
        [[self delegate] selectedPriceBook:strStatus];
    }
    
    [self dismissFromParentViewController];
}

@end
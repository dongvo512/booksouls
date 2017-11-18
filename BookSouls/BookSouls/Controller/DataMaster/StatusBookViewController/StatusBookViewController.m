//
//  StatusBookViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/15/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "StatusBookViewController.h"
#import "StatusCell.h"
#import "UIColor+HexString.h"

@interface StatusBookViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tblStatus;
@property (nonatomic, strong) NSArray *arrStatus;
@end

@implementation StatusBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tblStatus.estimatedRowHeight = 44;
    self.tblStatus.rowHeight = UITableViewAutomaticDimension;
    
    self.arrStatus = @[@"Sách mới", @"Sách cũ 90%", @"Sách cũ 70%", @"Sách cũ 50%"];
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
    
    return self.arrStatus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatusCell"];
    
   NSString *strStatus = [self.arrStatus objectAtIndex:indexPath.row];
    
    if(indexPath.row % 2){
        
        [cell.contentView setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
    }
    else{
        
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblStatus.text = strStatus;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSString *strStatus = [self.arrStatus objectAtIndex:indexPath.row];
    
    if([[self delegate] respondsToSelector:@selector(selectedStatusBook:)]){
        
        [[self delegate] selectedStatusBook:strStatus];
    }
    
    [self dismissFromParentViewController];
}

@end

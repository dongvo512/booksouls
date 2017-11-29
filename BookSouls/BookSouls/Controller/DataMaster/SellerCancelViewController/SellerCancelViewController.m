//
//  SellerCancelViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/29/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "SellerCancelViewController.h"
#import "CommentCell.h"
#import "UIColor+HexString.h"
#import "Comment.h"

@interface SellerCancelViewController ()<UITextViewDelegate>{
    
    NSString *descriptionSelected;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, strong) NSMutableArray *arrDescription;
@end

@implementation SellerCancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrDescription = [NSMutableArray array];
    
    Comment *comment_1 = [[Comment alloc] init];
    comment_1.title = @"Chưa liên hệ được người mua";
    
    [self.arrDescription addObject:comment_1];
    
    Comment *comment_2 = [[Comment alloc] init];
    comment_2.title = @"Sách đã bán";
    
    [self.arrDescription addObject:comment_2];
    
    Comment *comment_3 = [[Comment alloc] init];
    comment_3.title = @"Không còn nhu cầu bán sách";
    
    [self.arrDescription addObject:comment_3];
    
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"#95989A"].CGColor;
    self.textView.layer.borderWidth = 0.5;
    
    [self.tblView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
    self.tblView.estimatedRowHeight = 48;
    self.tblView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)touchBtnClose:(id)sender {
    
    [self dismissFromParentViewController];
}
- (IBAction)touchAcept:(id)sender {
    
    if(descriptionSelected.length > 0 ){
        
        if([[self delegate] respondsToSelector:@selector(aceptCancelFromSeller:)]){
            
            [[self delegate] aceptCancelFromSeller:descriptionSelected];
        }
    }
    
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
    
    return self.arrDescription.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    
    Comment *comment = [self.arrDescription objectAtIndex:indexPath.row];
    
    if(indexPath.row % 2){
        
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    else{
        
        [cell.contentView setBackgroundColor:[UIColor colorWithHexString:@"#F6F6F6"]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setDataForCell:comment];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    Comment *comment = [self.arrDescription objectAtIndex:indexPath.row];
    
    for(Comment *comment in self.arrDescription){
        
        comment.isSelected = NO;
    }
    
    descriptionSelected = comment.title;
    comment.isSelected = YES;
    self.textView.text = @"";
    [self.tblView reloadData];
}

#pragma mark - TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    for(Comment *comment in self.arrDescription){
        
        comment.isSelected = NO;
    }
    
    descriptionSelected = textView.text;
    [self.tblView reloadData];
    
    return YES;
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    descriptionSelected = textView.text;
}
@end

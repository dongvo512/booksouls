//
//  BuyerCancelViewController.m
//  BookSouls
//
//  Created by Dong Vo on 11/29/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import "BuyerCancelViewController.h"
#import "CommentCell.h"
#import "UIColor+HexString.h"
#import "Comment.h"

@interface BuyerCancelViewController ()<UITextViewDelegate>{
    
    NSString *descriptionSelected;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, strong) NSMutableArray *arrDescription;
@end

@implementation BuyerCancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrDescription = [NSMutableArray array];
    
    Comment *comment_1 = [[Comment alloc] init];
    comment_1.title = @"Người bán sách chưa liên hệ";
    [self.arrDescription addObject:comment_1];
    
    Comment *comment_2 = [[Comment alloc] init];
    comment_2.title = @"Giá sách tăng cao";
    [self.arrDescription addObject:comment_2];
    
    Comment *comment_3 = [[Comment alloc] init];
    comment_3.title = @"Sách đã bán";
    [self.arrDescription addObject:comment_3];
    
    Comment *comment_4 = [[Comment alloc] init];
    comment_4.title = @"Người bán không muốn bán";
    [self.arrDescription addObject:comment_4];
    
    Comment *comment_5 = [[Comment alloc] init];
    comment_5.title = @"Không còn nhu cầu mua sách";
    [self.arrDescription addObject:comment_5];
    
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
        
        if([[self delegate] respondsToSelector:@selector(aceptCancelFromBuyer:)]){
            
            [[self delegate] aceptCancelFromBuyer:descriptionSelected];
        }
        
         [self dismissFromParentViewController];
    }
    else{
        
        [Common showAlert:self title:@"Thông báo" message:@"Bạn chưa chọn lý do huỷ" buttonClick:nil];
    }
    
   
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

//
//  CommentCell.h
//  BookSouls
//
//  Created by Dong Vo on 11/29/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Comment;

@interface CommentCell : UITableViewCell

- (void)setDataForCell:(Comment *)comment;

@end

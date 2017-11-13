//
//  BookContentView.h
//  BookSouls
//
//  Created by Dong Vo on 11/11/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookContentView : UICollectionReusableView

- (void)setDataForView:(NSString *)contentBook isExpand:(BOOL)isExpand isShowExpand:(BOOL)isShowExpand;
@property (nonatomic, weak) id delegate;

@end

@protocol BookContentViewDelegate <NSObject>
- (void)selectedBtnExpand;
@end

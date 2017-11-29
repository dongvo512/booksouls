//
//  TextFieldView.h
//  BookSouls
//
//  Created by Dong Vo on 11/14/17.
//  Copyright © 2017 Dong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldView : UIView
@property (nonatomic) BOOL isDisable;
@property (weak, nonatomic) IBOutlet UITextField *tfContent;
@property (nonatomic, strong) NSString *strIcon;
@property (nonatomic, strong) NSString *strSubTile;
@property (nonatomic) BOOL isPrice;
- (void)setDataEditing:(NSString *)content;
- (void)setDataForTextView;
- (void)clearData;
@property (nonatomic, weak) id delegate;
@end
@protocol TextFieldViewDelegate <NSObject>
- (void)touchIconButton:(TextFieldView *)textField;
- (void)beginEditing:(TextFieldView *)textField;
- (void)returnKeyboard:(TextFieldView *)textField;
@end

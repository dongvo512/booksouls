//
//  UIColor+Config.h
//  SAMS
//
//  Created by NCXT on 06/10/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Method)

+ (UIColor *)colorFromHexString:(NSString *)sString;
+ (UIColor *)colorFromARGB:(NSInteger)argb;
+ (UIColor *)colorFromCharacter:(NSString *)character;
+ (UIColor *)grayBorder;
+ (UIColor *)grayTextCombobox;
+ (UIColor *)blueDateToday;

@end

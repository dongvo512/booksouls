//
//  UIColor+Config.m
//  SAMS
//
//  Created by NCXT on 06/10/2014.
//  Copyright (c) Năm 2014 NCXT. All rights reserved.
//

#import "UIColor+Method.h"

@implementation UIColor (Method)

+ (UIColor *)colorFromHexString:(NSString *)sString{
    
//    NSString *noHashString = [sString stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:sString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

+ (UIColor *)colorFromARGB:(NSInteger)argb{
    
    int blue = argb & 0xff;
    int green = argb >> 8 & 0xff;
    int red = argb >> 16 & 0xff;
    int alpha = argb >> 24 & 0xff;
    
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha/255.f];
}

+ (UIColor *)colorFromCharacter:(NSString *)character{
    
    if([character isEqualToString:@"A"]){
        //00bfa5
        return [UIColor colorFromHexString:@"00bfa5"];
        
    } else if ([character isEqualToString:@"B"]){
        //6200ea
        return [UIColor colorFromHexString:@"6200ea"];
    }
    else if ([character isEqualToString:@"C"]){
        //ffd600
        return [UIColor colorFromHexString:@"ffd600"];
    }
    else if ([character isEqualToString:@"D"]){
        //64dd17
        return [UIColor colorFromHexString:@"64dd17"];
    }
    else if ([character isEqualToString:@"E"]){
        //aa00ff
        return [UIColor colorFromHexString:@"aa00ff"];
    }
    else if ([character isEqualToString:@"F"]){
        //c51162
        return [UIColor colorFromHexString:@"c51162"];
    }
    else if ([character isEqualToString:@"G"]){
        //2962ff
        return [UIColor colorFromHexString:@"2962ff"];
    }
    else if ([character isEqualToString:@"H"]){
        //00c853
        return [UIColor colorFromHexString:@"00c853"];
    }
    else if ([character isEqualToString:@"I"]){
        //ffab00
        return [UIColor colorFromHexString:@"ffab00"];
    }
    else if ([character isEqualToString:@"J"]){
        //0091ea
        return [UIColor colorFromHexString:@"0091ea"];
    }
    else if ([character isEqualToString:@"K"]){
        //3e2723
        return [UIColor colorFromHexString:@"3e2723"];
    }
    else if ([character isEqualToString:@"L"]){
        //304ffe
        return [UIColor colorFromHexString:@"304ffe"];
    }
    else if ([character isEqualToString:@"M"]){
        //d50000
        return [UIColor colorFromHexString:@"d50000"];
        
    }else if ([character isEqualToString:@"N"]){
        //aeea00
        return [UIColor colorFromHexString:@"aeea00"];
        
    }
    else if ([character isEqualToString:@"O"]){
        //263238
        return [UIColor colorFromHexString:@"263238"];
        
    }
    else if ([character isEqualToString:@"P"]){
        //dd2c00
        return [UIColor colorFromHexString:@"dd2c00"];
        
    }
    else if ([character isEqualToString:@"Q"]){
        //212121
        return [UIColor colorFromHexString:@"212121"];
        
    }else if ([character isEqualToString:@"R"]){
        //ff6d00
        return [UIColor colorFromHexString:@"ff6d00"];
        
    }
    else if ([character isEqualToString:@"S"]){
        //00b8d4
        return [UIColor colorFromHexString:@"00b8d4"];
    }
    else if ([character isEqualToString:@"T"]){
        //00bfa5
        return [UIColor colorFromHexString:@"00bfa5"];
    }
    else if ([character isEqualToString:@"U"]){
        //6200ea
        return [UIColor colorFromHexString:@"6200ea"];
    }
    else if ([character isEqualToString:@"V"]){
        //ffd600
        return [UIColor colorFromHexString:@"ffd600"];
        
    }else if ([character isEqualToString:@"W"]){
        //64dd17
        return [UIColor colorFromHexString:@"64dd17"];
    }
    else if ([character isEqualToString:@"X"]){
        //aa00ff
        return [UIColor colorFromHexString:@"aa00ff"];
        
    }else if ([character isEqualToString:@"Y"]){
        //c51162
        return [UIColor colorFromHexString:@"c51162"];
        
    }else {// "Z"
        //2962ff
        return [UIColor colorFromHexString:@"2962ff"];
    }
    
}

+ (UIColor *)grayBorder{
    
    UIColor *color = [UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:230.0f/255.0f alpha:1];
    return color;
}

+ (UIColor *)grayTextCombobox{
    
    UIColor *color = [UIColor colorWithRed:47.0f/255.0f green:47.0f/255.0f blue:47.0f/255.0f alpha:1];
    return color;
}

+ (UIColor *)blueDateToday{
    
    UIColor *color = [UIColor colorWithRed:5.0f/255.0f green:76.0f/255.0f blue:130.0f/255.0f alpha:1];
    return color;
}
@end

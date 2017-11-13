//
//  Common.m
//  eGovernment
//
//  Created by Dong Vo on 1/7/16.
//  Copyright © 2016 NhatCuongMobile. All rights reserved.
//

#import "Common.h"
#import "CommonDefine.h"
#import "Reachability.h"

@interface Common()

@end

@implementation Common

#pragma mark - System

+ (instancetype)sharedInstance{
    
    static Common *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Common alloc] init];
        
    });
    return sharedInstance;
}

+ (BOOL)checkForWIFIConnection{
    
    BOOL statusInternet = FALSE;
    
    Reachability *wifiReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    switch (netStatus){
            
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            statusInternet = FALSE;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            statusInternet = TRUE;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            statusInternet = TRUE;
            
            break;
        }
    }
    
    return statusInternet;
}


+ (NSInteger)yearFromDate:(NSDate *)date{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    return [components year];
}

+ (NSString *)getStringDisplayFormDate:(NSDate *)date andFormatString:(NSString *)format{

    NSString *convertString = @"";
    
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setDateFormat:format];

    convertString = [fm stringFromDate:date];
    
    return convertString;
    
}
+(BOOL)validateEmailAddress:(NSString *)address
{
    @try
    {
        BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
        NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
        NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:address];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Invalid email address exception");
        return NO;
    }
    
    return NO;
}


+(NSString *)convertPhone84:(NSString *)phone{

    NSString *stringConvert = phone;
    
    if(phone.length > 3){
    
        NSString *firstCharactor = [stringConvert substringToIndex:3];
        
        if([firstCharactor isEqualToString:@"+84"]){
        
            firstCharactor = @"0";
            
            NSString *newString = [stringConvert substringWithRange:NSMakeRange(3, [stringConvert length]-3)];
            
            stringConvert = [NSString stringWithFormat:@"%@%@",firstCharactor,newString];
        }
    }
    
    return stringConvert;
}

+ (NSString *)getString3DigitsDot:(NSInteger )number{

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:number]];

    return formatted;
}

+ (void)hightLightLabel:(UILabel *)label withSubstring:(NSString*)substring withColor:(UIColor *)color font:(UIFont *)font{
    if (![label respondsToSelector:@selector(setAttributedText:)])
    {
        return;
    }
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern: substring options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!error)
    {
        NSString * str =[label text];
        
        if (str) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
            NSArray *allMatches = [regex matchesInString:[label text] options:0 range:NSMakeRange(0, [str length])];
            NSDictionary * attributes =   @{NSForegroundColorAttributeName: color,
                                            NSFontAttributeName:font};
            
            for (NSTextCheckingResult *aMatch in allMatches)
            {
                NSRange matchRange = [aMatch range];
                [attributedString setAttributes:attributes range: matchRange];
            }
            [label setAttributedText:attributedString];
        }
        
    }
}

+(NSDate *)getDateFromStringFormat:(NSString *)dateString format:(NSString *)format{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:format];
    NSDate *dateFromString;
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    
    return dateFromString;
}
+ (NSString *)getDayInWeekVietNamese:(NSDate *)date{
    
    NSString  *strDay = _CM_STRING_EMPTY;
    
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE"];
    
    NSString *strDayInWeek = [weekday stringFromDate:date];
    
    if([strDayInWeek isEqualToString:@"Monday"]){
        
        strDay = @"Thứ hai";
    }
    
    
    if([strDayInWeek isEqualToString:@"Tuesday"]){
        
        strDay = @"Thứ ba";
    }
    
    
    if([strDayInWeek isEqualToString:@"Wednesday"]){
        
        strDay = @"Thứ tư";
    }
    
    if([strDayInWeek isEqualToString:@"Thursday"]){
        
        strDay = @"Thứ năm";
    }
    
    if([strDayInWeek isEqualToString:@"Friday"]){
        
        strDay = @"Thứ sáu";
    }
    
    if([strDayInWeek isEqualToString:@"Saturday"]){
        
        strDay = @"Thứ bảy";
    }
    
    if([strDayInWeek isEqualToString:@"Sunday"]){
        
        strDay = @"Chủ nhật";
    }
    
    return strDay;
}


+ (NSString *)formattedDateTimeWithDateString:(NSString *)inputDateString inputFormat:(NSString *)inputFormat outputFormat:(NSString *)outputFormat
{
    NSString *formattedDateTime = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:inputFormat];
    
    NSDate *inputDate = [dateFormatter dateFromString:inputDateString];
    
    [dateFormatter setDateFormat:outputFormat];
    formattedDateTime = [dateFormatter stringFromDate:inputDate];
    
    return formattedDateTime;
}
+(void)showAlert:(UIViewController *)controller title:(NSString *)title message:(NSString *)message buttonClick:(ButtonClick)buttonClick{

    UIAlertController *vcAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Oke = [UIAlertAction actionWithTitle:@"Đồng ý" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        
        if(buttonClick){
        
             buttonClick(action);
        }
       
    }];
    
    
    [vcAlert addAction:Oke];
    
    [controller presentViewController:vcAlert animated:YES completion:nil];

}

+(void)showAlertCancel:(UIViewController *)controller title:(NSString *)title message:(NSString *)message buttonClick:(ButtonClick)buttonClickOk buttonClickCancel:(ButtonClick)buttonClickCancel{
    
    UIAlertController *vcAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Oke = [UIAlertAction actionWithTitle:@"Đồng ý" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(buttonClickOk){
            
            buttonClickOk(action);
        }
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(buttonClickCancel){
            
            buttonClickCancel(action);
        }
        
    }];
    
    
    [vcAlert addAction:Oke];
    
    [vcAlert addAction:cancel];
    
    [controller presentViewController:vcAlert animated:YES completion:nil];
    
}
+ (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];

}
+ (NSInteger)monthFromDate:(NSDate *)date{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    return [components month];
}

+ (NSInteger)dayFromDate:(NSDate *)date{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    return [components day];
}

+ (NSInteger)hourFromDate:(NSDate *)date{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    return [components hour];
}

+ (NSInteger)minuteFromDate:(NSDate *)date{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    return [components minute];
}

+ (NSInteger)secondFromDate:(NSDate *)date{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    return [components second];
}

//+ (Date *)getStartEndDate:(NSCalendarUnit)typeOutput formatOutPut:(NSString *)format{
//
//    Date *date = [[Date alloc] init];
//
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDate *now = [NSDate date];
//    NSDate *startOfTheWeek;
//    NSDate *endOfWeek;
//    NSTimeInterval interval;
//    [cal rangeOfUnit:typeOutput
//           startDate:&startOfTheWeek
//            interval:&interval
//             forDate:now];
//    //startOfWeek holds now the first day of the week, according to locale (monday vs. sunday)
//
//    endOfWeek = [startOfTheWeek dateByAddingTimeInterval:interval-1];
//
//    date.startDate = [self getStringDisplayFormDate:startOfTheWeek andFormatString:format];
//    date.endDate = [self getStringDisplayFormDate:endOfWeek andFormatString:format];
//    return date;
//
//}
+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    
    CGSize stringSize = [string sizeWithFont:font];
    
    CGFloat width = stringSize.width;
    return width;
}
+ (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size.height;
}
+ (NSString *)upperFirstLetter:(NSString *)strKeyWord{
    
    NSString *capitalisedSentence = _CM_STRING_EMPTY;
    
    if(strKeyWord.length > 0){
        
        capitalisedSentence = [[strKeyWord lowercaseString] stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                                    withString:[[strKeyWord  substringToIndex:1] capitalizedString]];
    }
    
    return capitalisedSentence;
}


+ (BOOL)checkLeastOneWordAndOneNumber:(NSString *) strValue{
    
    BOOL isNumber = FALSE;
    BOOL isText = FALSE;
    
    for (int i = 0; i < strValue.length; i++) {
        NSString *ch = [strValue substringWithRange:NSMakeRange(i, 1)];
        if ([self checkIsNumber:ch]) {
            isNumber = TRUE;
        }
        
        if ([self checkIsNumber:ch] == FALSE) {
            isText = TRUE;
        }
        
        if (isNumber == TRUE && isText == TRUE) {
            return TRUE;
        }
    }
    
    if (isNumber == TRUE && isText == TRUE) {
        return TRUE;
    }
    else{
        return FALSE;
    }
}
+ (BOOL)checkIsNumber:(NSString *)strValue{
    
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:strValue];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}
@end

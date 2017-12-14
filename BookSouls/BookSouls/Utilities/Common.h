//
//  Common.h
//  eGovernment
//
//  Created by Dong Vo on 1/7/16.
//  Copyright © 2016 NhatCuongMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Date;

#define MAX_TOTAL_MB_FILE 4*1024*1024

@interface Common : NSObject

typedef void (^ButtonClick)(UIAlertAction *alertAction);
typedef void (^DataAPIResult)(NSError *error, id idObject, NSString *strError);
typedef void (^CallAPIResult)(BOOL isError, NSString *stringError, id responseDataObject);
typedef void (^UploadResult)(BOOL isError, NSString *stringError, id responseDataObject, NSProgress *progress);
#pragma mark - System
+ (instancetype)sharedInstance;
+ (BOOL)checkForWIFIConnection;

#pragma mark - Devices
+ (NSInteger)yearFromDate:(NSDate *)date;

+ (NSInteger)monthFromDate:(NSDate *)date;

+ (NSInteger)dayFromDate:(NSDate *)date;

+ (NSInteger)hourFromDate:(NSDate *)date;

+ (NSInteger)minuteFromDate:(NSDate *)date;

+ (NSInteger)secondFromDate:(NSDate *)date;

+ (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font;

+ (BOOL)checkLeastOneWordAndOneNumber:(NSString *) strValue;

+ (NSString *)upperFirstLetter:(NSString *)strKeyWord;

+ (NSString *)getStringDisplayFormDate:(NSDate *)date andFormatString:(NSString *)format;
+ (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2;

+ (NSString *)formattedDateTimeWithDateString:(NSString *)inputDateString inputFormat:(NSString *)inputFormat outputFormat:(NSString *)outputFormat;
#pragma mark - Alert
+(void)showAlert:(UIViewController *)controller title:(NSString *)title message:(NSString *)message buttonClick:(ButtonClick)buttonClick;
+ (NSString *)getString3DigitsDot:(NSInteger )number;
+(NSDate *)getDateFromStringFormat:(NSString *)dateString format:(NSString *)format;
+ (Date *)getStartEndDate:(NSCalendarUnit)typeOutput formatOutPut:(NSString *)format;
+ (NSString *)getDayInWeekVietNamese:(NSDate *)date;
+ (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;
+(NSString *)convertPhone84:(NSString *)phone;
+(BOOL)validateEmailAddress:(NSString *)address;
+(void)showAlertCancel:(UIViewController *)controller title:(NSString *)title message:(NSString *)message buttonClick:(ButtonClick)buttonClickOk buttonClickCancel:(ButtonClick)buttonClickCancel;
+(void)hightLightLabel:(UILabel *)label withSubstring:(NSString*)substring withColor:(UIColor *)color font:(UIFont *)font;
+ (NSString*)formattedDateTimeWithDateString7:(NSString *)inputDateString inputFormat:(NSString *)inputFormat outputFormat:(NSString *)outputFormat;
@end

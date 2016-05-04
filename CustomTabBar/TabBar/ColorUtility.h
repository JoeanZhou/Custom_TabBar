//
//  ColorUtility.h
//  Jml2.0
//
//  Created by user on 11-8-4.
//  Copyright 2011 dajie.com. All rights reserved.
//  颜色转换

#import <UIKit/UIKit.h>
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface ColorUtility : NSObject {

}
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;

@end
